import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/core/theme/app_theme.dart';
import 'package:flutter_chat/features/auth/data/auth_repository.dart';
import 'package:flutter_chat/features/auth/presentation/auth_controller.dart';
import 'package:flutter_chat/features/auth/presentation/login_page.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  int calls = 0;
  Completer<void>? pending;
  Object? error;
  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {
    calls++;
    if (error != null) throw error!;
    await pending?.future;
  }

  @override
  Future<void> register({
    required String username,
    required String nickname,
    required String password,
  }) => login(username: username, password: password);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'only one authentication request while pending, retry allowed afterwards',
    () async {
      final repo = FakeAuthRepository()..pending = Completer<void>();
      final controller = AuthController(repository: repo);
      final first = controller.login('alice', 'password');
      expect(await controller.login('alice', 'password'), isFalse);
      expect(await controller.register('alice', 'Alice', 'password'), isFalse);
      expect(repo.calls, 1);
      repo.pending!.complete();
      expect(await first, isTrue);
      expect(await controller.login('alice', 'password'), isTrue);
      expect(repo.calls, 2);
      controller.dispose();
    },
  );
  test(
    'late completion after disposal does not notify or report successful navigation',
    () async {
      final repo = FakeAuthRepository()..pending = Completer<void>();
      final controller = AuthController(repository: repo);
      var notifications = 0;
      controller.addListener(() => notifications++);
      final first = controller.login('alice', 'password');
      controller.dispose();
      repo.pending!.complete();
      expect(await first, isFalse);
      expect(notifications, 1);
    },
  );
  test('server response details never become visible login errors', () async {
    final request = RequestOptions(path: '/auth/login');
    final repo = FakeAuthRepository()
      ..error = DioException(
        requestOptions: request,
        response: Response(
          requestOptions: request,
          statusCode: 500,
          data: {'message': 'private database password'},
        ),
      );
    final controller = AuthController(repository: repo);
    expect(await controller.login('alice', 'password'), isFalse);
    expect(controller.errorMessage, '服务暂时不可用，请稍后重试');
    controller.dispose();
  });
  for (final dark in [false, true]) {
    testWidgets(
      'registration validation and password reset on mode switch, dark=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(320, 700);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = FakeAuthRepository();
        final controller = AuthController(repository: repo);
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? AppTheme.dark() : AppTheme.light(),
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
              child: LoginPage(controller: controller, onLoggedIn: () {}),
            ),
          ),
        );
        await tester.ensureVisible(find.text('没有账号？立即注册'));
        await tester.tap(find.text('没有账号？立即注册'));
        await tester.pumpAndSettle();
        Finder field(String label) => find.widgetWithText(TextFormField, label);
        await tester.enterText(field('用户名'), 'bad user');
        await tester.enterText(field('昵称'), '测试');
        await tester.enterText(field('密码'), 'password123');
        await tester.enterText(field('确认密码'), 'mismatch');
        await tester.ensureVisible(find.text('注册并登录'));
        await tester.tap(find.text('注册并登录'));
        await tester.pumpAndSettle();
        expect(find.text('仅支持字母、数字和下划线'), findsOneWidget);
        expect(find.text('两次密码不一致'), findsOneWidget);
        expect(repo.calls, 0);
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text('已有账号？返回登录'));
        await tester.tap(find.text('已有账号？返回登录'));
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextFormField>(field('密码')).controller!.text,
          isEmpty,
        );
        expect(
          tester.widget<TextFormField>(field('用户名')).controller!.text,
          'bad user',
        );
        expect(
          tester
              .widget<TextField>(
                find.descendant(
                  of: field('密码'),
                  matching: find.byType(TextField),
                ),
              )
              .autofillHints,
          contains(AutofillHints.password),
        );
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        controller.dispose();
      },
    );
  }
}
