import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chat/core/calls/call_service.dart';
import 'package:flutter_chat/core/files/file_transfer_service.dart';
import 'package:flutter_chat/features/auth/data/auth_repository.dart';
import 'package:flutter_chat/features/home/data/home_repository.dart';
import 'package:flutter_chat/features/home/presentation/home_controller.dart';
import 'package:flutter_chat/features/home/presentation/profile_page.dart';
import 'package:flutter_chat/features/home/presentation/security_privacy_page.dart';
import 'package:flutter_test/flutter_test.dart';

class _UnusedRepository implements HomeRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Files implements FileTransferService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Calls implements CallService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Controller extends HomeController {
  _Controller() : super(_UnusedRepository());
  bool failLoad = false;
  bool failPassword = false;
  int revocations = 0;
  int passwordChanges = 0;
  Completer<void>? revokePending;

  @override
  Future<List<DeviceSummary>> devices() async {
    if (failLoad) throw StateError('internal-failure');
    return const [
      DeviceSummary(
        id: 'device-2',
        name: '测试手机',
        type: 'APP',
        ipAddress: null,
        lastSeenAt: null,
        current: false,
      ),
    ];
  }

  @override
  Future<void> revokeDevice(String sessionId) async {
    revocations++;
    await revokePending?.future;
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    passwordChanges++;
    if (failPassword) throw StateError('internal-password-failure');
  }
}

class _Auth implements AuthRepository {
  int deactivations = 0;
  Completer<void>? pending;
  @override
  Future<void> deactivateAccount(String currentPassword) async {
    deactivations++;
    await pending?.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text).last);
  await tester.tap(find.text(text).last);
  await tester.pumpAndSettle();
}

void main() {
  late _Controller controller;
  late _Auth auth;
  setUp(() {
    controller = _Controller();
    auth = _Auth();
  });

  Future<void> security(
    WidgetTester tester, {
    VoidCallback? onDeactivated,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SecurityPrivacyPage(
          controller: controller,
          authRepository: auth,
          onDeactivated: onDeactivated ?? () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('device load failure can be retried', (tester) async {
    controller.failLoad = true;
    await security(tester);
    expect(find.text('设备列表加载失败'), findsOneWidget);
    expect(find.textContaining('internal-failure'), findsNothing);
    controller.failLoad = false;
    await _tap(tester, '重试');
    expect(find.text('测试手机'), findsOneWidget);
    expect(find.text('设备列表加载失败'), findsNothing);
  });

  testWidgets(
    'device revocation requires confirmation and blocks duplicate submission',
    (tester) async {
      controller.revokePending = Completer<void>();
      await security(tester);
      await _tap(tester, '下线');
      await _tap(tester, '取消');
      expect(controller.revocations, 0);
      await _tap(tester, '下线');
      await _tap(tester, '下线');
      expect(controller.revocations, 1);
      final button = tester.widget<TextButton>(
        find.widgetWithText(TextButton, '处理中…'),
      );
      expect(button.onPressed, isNull);
      controller.revokePending!.complete();
      await tester.pumpAndSettle();
      expect(find.text('设备已下线'), findsOneWidget);
    },
  );

  testWidgets(
    'deactivation validates password and cancellation performs no request',
    (tester) async {
      await security(tester);
      await _tap(tester, '注销账号');
      await _tap(tester, '确认注销');
      expect(find.text('请输入至少 8 位的当前密码'), findsOneWidget);
      expect(auth.deactivations, 0);
      await _tap(tester, '取消');
      expect(auth.deactivations, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('deactivation stays locked until the request finishes', (
    tester,
  ) async {
    auth.pending = Completer<void>();
    var exited = false;
    await security(tester, onDeactivated: () => exited = true);
    await _tap(tester, '注销账号');
    await tester.enterText(find.byType(TextFormField), 'password123');
    await _tap(tester, '确认注销');
    expect(auth.deactivations, 1);
    expect(exited, isFalse);
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );
    auth.pending!.complete();
    await tester.pumpAndSettle();
    expect(exited, isTrue);
  });

  for (final fails in [true, false]) {
    testWidgets(
      'password change ${fails ? 'failure never reports success' : 'success reports success'}',
      (tester) async {
        controller.failPassword = fails;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ProfilePage(
                controller: controller,
                fileTransferService: _Files(),
                callService: _Calls(),
                authRepository: auth,
                onDeactivated: () {},
                onLogout: () async {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await _tap(tester, '修改密码');
        await tester.enterText(
          find.byType(TextFormField).at(0),
          'oldpassword1',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'newpassword123',
        );
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'newpassword123',
        );
        await _tap(tester, '修改');
        expect(controller.passwordChanges, 1);
        expect(find.text('密码修改成功'), fails ? findsNothing : findsOneWidget);
        if (fails) expect(find.text('操作失败，请稍后重试'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
