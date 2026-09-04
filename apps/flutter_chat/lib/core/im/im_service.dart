import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:wukongimfluttersdk/common/options.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import '../../config/app_config.dart';
import '../../config/server_settings.dart';
import '../auth/token_store.dart';
import 'chat_message_content.dart';
import 'read_receipt_outbox.dart';

enum ImConnectionState {
  disconnected,
  connecting,
  connected,
  noNetwork,
  kicked,
}

class MessageReceipt {
  const MessageReceipt({
    required this.messageId,
    required this.readCount,
    required this.unreadCount,
  });

  final String messageId;
  final int readCount;
  final int unreadCount;
}

class ConversationSetting {
  const ConversationSetting({
    this.pinned = false,
    this.muted = false,
    this.archived = false,
  });

  final bool pinned;
  final bool muted;
  final bool archived;
}

class ImService extends ChangeNotifier {
  ImService(
    this._dio, {
    PendingReadStore? pendingReadStore,
    InstallationIdStore? installationIdStore,
  }) : _installationIdStore = installationIdStore ?? InstallationIdStore() {
    _readOutbox = ReadReceiptOutbox(
      namespace: storageNamespace,
      store: pendingReadStore,
      send: _sendRead,
    );
  }

  static const _listenerKey = 'flutter-chat-app';
  final Dio _dio;
  final InstallationIdStore _installationIdStore;
  late final ReadReceiptOutbox _readOutbox;
  bool _reconciling = false;
  String get storageNamespace => _dio.options.baseUrl.isEmpty
      ? 'default'
      : serverNamespace(_dio.options.baseUrl);
  bool _disposed = false;

  @override
  void notifyListeners() {
    // In-flight HTTP completions can arrive after logout/page teardown.
    if (!_disposed) super.notifyListeners();
  }

  bool _resumeAfterRefresh = false;

  ImConnectionState connectionState = ImConnectionState.disconnected;
  List<WKUIConversationMsg> conversations = const [];
  final Map<String, ConversationSetting> conversationSettings = {};
  final Set<String> _updatingSettings = {};

  bool isUpdatingSetting(String channelId, int channelType) =>
      _updatingSettings.contains(_conversationKey(channelId, channelType));

  List<WKUIConversationMsg> conversationsFor({required bool archived}) =>
      conversations
          .where(
            (c) => settingFor(c.channelID, c.channelType).archived == archived,
          )
          .toList();
  Object? error;
  int historyRevision = 0;
  final _callSignals = StreamController<ChatCallSignalContent>.broadcast();

  Stream<ChatCallSignalContent> get callSignals => _callSignals.stream;
  final _groupChanges = StreamController<String>.broadcast();
  Stream<String> get groupChanges => _groupChanges.stream;

  @visibleForTesting
  void handleGroupNotice(WKMsg message) {
    if (_disposed || message.channelType != 2 || message.channelID.isEmpty) {
      return;
    }
    if (message.messageContent case ChatSystemContent notice) {
      if (notice.event == 'group.avatar_changed') {
        _groupChanges.add(message.channelID);
      }
    }
  }

  Future<void> updateSession(StoredTokens? session) async {
    if (_disposed) return;
    _resumeAfterRefresh = false;
    if (session == null) {
      WKIM.shared.connectionManager.disconnect(true);
      conversations = const [];
      conversationSettings.clear();
      connectionState = ImConnectionState.disconnected;
      notifyListeners();
      return;
    }

    try {
      _removeListeners();
      final address = AppConfig.resolveDeviceHost(session.imAddress);
      final installationId = await _installationIdStore.getOrCreate();
      final ready = await WKIM.shared.setup(
        Options.newDefault(session.imUid, session.imToken, addr: address)
          ..deviceId = installationId
          ..databaseNamespace = storageNamespace,
      );
      if (!ready) throw StateError('WuKongIM 本地数据库初始化失败');
      WKIM.shared.messageManager.registerMsgContent(
        ChatMessageType.image,
        (data) =>
            ChatImageContent().decodeJson(Map<String, dynamic>.from(data)),
      );
      WKIM.shared.messageManager.registerMsgContent(
        ChatMessageType.video,
        (data) =>
            ChatVideoContent().decodeJson(Map<String, dynamic>.from(data)),
      );
      WKIM.shared.messageManager.registerMsgContent(
        ChatMessageType.file,
        (data) => ChatFileContent().decodeJson(Map<String, dynamic>.from(data)),
      );
      WKIM.shared.messageManager.registerMsgContent(
        ChatMessageType.audio,
        (data) =>
            ChatAudioContent().decodeJson(Map<String, dynamic>.from(data)),
      );
      WKIM.shared.messageManager.registerMsgContent(
        ChatMessageType.revoke,
        (data) =>
            ChatRevokeContent().decodeJson(Map<String, dynamic>.from(data)),
      );
      WKIM.shared.messageManager.registerMsgContent(
        ChatMessageType.callSignal,
        (data) =>
            ChatCallSignalContent().decodeJson(Map<String, dynamic>.from(data)),
      );
      WKIM.shared.messageManager.registerMsgContent(
        ChatMessageType.system,
        (data) =>
            ChatSystemContent().decodeJson(Map<String, dynamic>.from(data)),
      );
      _addListeners();
      await _loadConversationSettings();
      await _loadConversations();
      unawaited(_readOutbox.flush(session.imUid));
      WKIM.shared.connectionManager.connect();
    } catch (caught) {
      error = caught;
      connectionState = ImConnectionState.disconnected;
      notifyListeners();
    }
  }

  Future<void> reconnect() async {
    error = null;
    WKIM.shared.connectionManager.connect();
  }

  void prepareCredentialsRefresh(StoredTokens session) {
    if (_disposed) return;
    if (WKIM.shared.options.uid != session.imUid) return;
    _resumeAfterRefresh = true;
    // Preserve uid, database and listeners; prevent the server's token-rotation
    // kick from being interpreted by the SDK as a full logout.
    WKIM.shared.connectionManager.disconnect(false);
  }

  // Refresh rotates the server IM token too. Update the active SDK credentials
  // without HTTP requests or database setup inside the refresh interceptor.
  void updateCredentials(StoredTokens session) {
    if (_disposed) return;
    final options = WKIM.shared.options;
    if (options.uid != session.imUid) return;
    options.token = session.imToken;
    options.addr = AppConfig.resolveDeviceHost(session.imAddress);
    if (_resumeAfterRefresh) {
      _resumeAfterRefresh = false;
      WKIM.shared.connectionManager.connect();
    }
  }

  Future<void> revokeMessage({
    required String channelId,
    required int channelType,
    required String clientMsgNo,
  }) async {
    await _dio.post<Object>(
      '/api/v1/im/messages/revoke',
      data: {
        'channelId': channelId,
        'channelType': channelType,
        'clientMsgNo': clientMsgNo,
      },
    );
  }

  Future<void> markRead(
    String channelId,
    int channelType, {
    int messageSeq = 0,
  }) async {
    await WKIM.shared.conversationManager.updateRedDot(
      channelId,
      channelType,
      0,
    );
    try {
      final uid = WKIM.shared.options.uid ?? '';
      await _readOutbox.record(uid, channelId, channelType, messageSeq);
      await _readOutbox.flush(uid);
    } catch (caught) {
      error = caught;
      notifyListeners();
    }
  }

  Future<void> _sendRead(
    String channelId,
    int channelType,
    int messageSeq,
  ) async {
    await _dio.post<Object>(
      '/api/v1/im/conversations/read',
      data: {
        'channelId': channelId,
        'channelType': channelType,
        'messageSeq': messageSeq,
      },
    );
  }

  /// Pulls server-owned state and retries durable operations after reconnect or
  /// foreground resume. Calls are collapsed to avoid concurrent reconciliation.
  Future<void> reconcileRemoteState() async {
    if (_disposed || _reconciling) return;
    final uid = WKIM.shared.options.uid ?? '';
    if (uid.isEmpty) return;
    _reconciling = true;
    try {
      await _readOutbox.flush(uid);
      await _loadConversationSettings();
      await _loadConversations();
      error = null;
      notifyListeners();
    } catch (caught) {
      error = caught;
      notifyListeners();
    } finally {
      _reconciling = false;
    }
  }

  String _conversationKey(String channelId, int channelType) =>
      '$channelType:$channelId';

  ConversationSetting settingFor(String channelId, int channelType) =>
      conversationSettings[_conversationKey(channelId, channelType)] ??
      const ConversationSetting();

  Future<void> updateConversationSetting({
    required String channelId,
    required int channelType,
    bool? pinned,
    bool? muted,
    bool? archived,
  }) async {
    final key = _conversationKey(channelId, channelType);
    if (!_updatingSettings.add(key)) return;
    notifyListeners();
    try {
      final data = <String, Object>{
        'channelId': channelId,
        'channelType': channelType,
      };
      if (pinned != null) data['pinned'] = pinned;
      if (muted != null) data['muted'] = muted;
      if (archived != null) data['archived'] = archived;
      await _dio.patch<Object>('/api/v1/conversations/settings', data: data);
      await refreshConversationSettings();
    } finally {
      _updatingSettings.remove(key);
      notifyListeners();
    }
  }

  Future<void> refreshConversationSettings() async {
    await _loadConversationSettings();
    _sortConversations();
    notifyListeners();
  }

  Future<void> deleteConversation(String channelId, int channelType) async {
    await _dio.delete<Object>(
      '/api/v1/conversations/settings/$channelType/$channelId',
    );
    await WKIM.shared.conversationManager.deleteMsg(channelId, channelType);
    conversationSettings.remove(_conversationKey(channelId, channelType));
    await _loadConversations();
  }

  Future<List<MessageReceipt>> loadReceipts({
    required String channelId,
    required int channelType,
    required List<WKMsg> messages,
  }) async {
    final eligible = messages.reversed
        .where(
          (message) => message.messageID.isNotEmpty && message.messageSeq > 0,
        )
        .take(100)
        .toList();
    if (eligible.isEmpty) return const [];
    final response = await _dio.post<Object>(
      '/api/v1/im/messages/receipts',
      data: {
        'channelId': channelId,
        'channelType': channelType,
        'messages': [
          for (final message in eligible)
            {'messageId': message.messageID, 'messageSeq': message.messageSeq},
        ],
      },
    );
    final rows = response.data;
    if (rows is! List) return const [];
    return rows
        .map((value) {
          final row = _asMap(value);
          return MessageReceipt(
            messageId: row['messageId']?.toString() ?? '',
            readCount: _asInt(row['readCount']),
            unreadCount: _asInt(row['unreadCount']),
          );
        })
        .where((item) => item.messageId.isNotEmpty)
        .toList();
  }

  Future<void> _loadConversations() async {
    conversations = await WKIM.shared.conversationManager.getAll();
    _sortConversations();
    notifyListeners();
  }

  void _sortConversations() {
    conversations = [...conversations]
      ..sort((a, b) {
        final aPinned = settingFor(a.channelID, a.channelType).pinned;
        final bPinned = settingFor(b.channelID, b.channelType).pinned;
        if (aPinned != bPinned) return aPinned ? -1 : 1;
        return b.lastMsgTimestamp.compareTo(a.lastMsgTimestamp);
      });
  }

  Future<void> _loadConversationSettings() async {
    final response = await _dio.get<Object>('/api/v1/conversations/settings');
    final next = <String, ConversationSetting>{};
    if (response.data is! List) {
      throw const FormatException('Invalid conversation settings response');
    }
    if (response.data case final List rows) {
      for (final value in rows) {
        final row = _asMap(value);
        final channelId = row['channelId']?.toString() ?? '';
        final channelType = _asInt(row['channelType']);
        if (channelId.isEmpty || channelType == 0) continue;
        next[_conversationKey(channelId, channelType)] = ConversationSetting(
          pinned: row['pinned'] == true,
          muted: row['muted'] == true,
          archived: row['archived'] == true,
        );
      }
    }
    conversationSettings
      ..clear()
      ..addAll(next);
  }

  void _addListeners() {
    WKIM.shared.connectionManager.addOnConnectionStatus(_listenerKey, (
      int status,
      int? reason,
      dynamic info,
    ) {
      connectionState = switch (status) {
        WKConnectStatus.connecting => ImConnectionState.connecting,
        WKConnectStatus.success ||
        WKConnectStatus.syncCompleted => ImConnectionState.connected,
        WKConnectStatus.noNetwork => ImConnectionState.noNetwork,
        WKConnectStatus.kicked => ImConnectionState.kicked,
        _ => ImConnectionState.disconnected,
      };
      notifyListeners();
      if (status == WKConnectStatus.syncCompleted) {
        unawaited(reconcileRemoteState());
      }
    });
    WKIM.shared.conversationManager.addOnRefreshMsgListListener(
      _listenerKey,
      (_) => _loadConversations(),
    );
    WKIM.shared.messageManager.addOnNewMsgListener('${_listenerKey}_calls', (
      messages,
    ) {
      for (final message in messages) {
        handleGroupNotice(message);
        if (message.messageContent case ChatCallSignalContent signal) {
          signal.fromUserId = message.fromUID;
          _callSignals.add(signal);
        }
      }
    });
    WKIM.shared.conversationManager.addOnDeleteMsgListener(
      _listenerKey,
      (_, _) => _loadConversations(),
    );
    WKIM.shared.conversationManager.addOnSyncConversationListener(
      _syncConversations,
    );
    WKIM.shared.messageManager.addOnSyncChannelMsgListener(syncChannelMessages);
  }

  Future<void> _syncConversations(
    String lastMsgSeqs,
    int msgCount,
    int version,
    Function(WKSyncConversation) complete,
  ) async {
    try {
      final response = await _dio.post<Object>(
        '/api/v1/im/conversations/sync',
        data: {
          'lastMsgSeqs': lastMsgSeqs,
          'msgCount': msgCount.clamp(0, 200),
          'version': version,
        },
      );
      final result = WKSyncConversation()..conversations = [];
      final rows = response.data is List
          ? response.data! as List<Object?>
          : const [];
      if (_disposed) return;
      for (final value in rows) {
        final row = _asMap(value);
        final conversation = WKSyncConvMsg()
          ..channelID = row['channel_id']?.toString() ?? ''
          ..channelType = _asInt(row['channel_type'])
          ..unread = _asInt(row['unread'])
          ..timestamp = _asInt(row['timestamp'])
          ..lastMsgSeq = _asInt(row['last_msg_seq'])
          ..lastClientMsgNO = row['last_client_msg_no']?.toString() ?? ''
          ..version = _asInt(row['version'])
          ..recents = _messagesFrom(row['recents']);
        result.conversations!.add(conversation);
      }
      complete(result);
      await _loadConversations();
      // The SDK only emits individual new-message events for batches < 20.
      // Open chat pages must also refresh after larger history sync batches.
      historyRevision++;
      notifyListeners();
    } catch (caught) {
      error = caught;
      complete(WKSyncConversation()..conversations = []);
      notifyListeners();
    }
  }

  @visibleForTesting
  Future<void> syncChannelMessages(
    String channelId,
    int channelType,
    int startMessageSeq,
    int endMessageSeq,
    int limit,
    int pullMode,
    Function(WKSyncChannelMsg?) complete,
  ) async {
    try {
      final response = await _dio.post<Object>(
        '/api/v1/im/messages/sync',
        data: {
          'channelId': channelId,
          'channelType': channelType,
          // SDK 1.7.9 subtracts one from the zero (latest) cursor when
          // filling an incomplete local page. API cursors are nonnegative.
          'startMessageSeq': startMessageSeq == -1 && pullMode == 0
              ? 0
              : startMessageSeq,
          'endMessageSeq': endMessageSeq,
          'limit': limit.clamp(1, 100),
          'pullMode': pullMode,
        },
      );
      final row = _asMap(response.data);
      if (_disposed) {
        complete(null);
        return;
      }
      complete(
        WKSyncChannelMsg()
          ..startMessageSeq = _asInt(row['start_message_seq'])
          ..endMessageSeq = _asInt(row['end_message_seq'])
          ..more = _asInt(row['more'])
          ..messages = _messagesFrom(row['messages']),
      );
    } catch (caught) {
      error = caught;
      // Null is the SDK failure path; an empty success would imply end of history.
      complete(null);
      notifyListeners();
    }
  }

  List<WKSyncMsg> _messagesFrom(Object? value) {
    if (value is! List) return [];
    return value.map((item) {
      final row = _asMap(item);
      return WKSyncMsg()
        ..channelID = row['channel_id']?.toString() ?? ''
        ..channelType = _asInt(row['channel_type'])
        ..messageID = row['message_id']?.toString() ?? ''
        ..messageSeq = _asInt(row['message_seq'])
        ..clientMsgNO = row['client_msg_no']?.toString() ?? ''
        ..fromUID = row['from_uid']?.toString() ?? ''
        ..timestamp = _asInt(row['timestamp'])
        ..setting = _asInt(row['setting'])
        ..payload = row['payload'];
    }).toList();
  }

  Map<String, dynamic> _asMap(Object? value) =>
      value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};

  int _asInt(Object? value) => switch (value) {
    int number => number,
    num number => number.toInt(),
    String text => int.tryParse(text) ?? 0,
    _ => 0,
  };

  void _removeListeners() {
    WKIM.shared.connectionManager.removeOnConnectionStatus(_listenerKey);
    WKIM.shared.messageManager.removeNewMsgListener('${_listenerKey}_calls');
    WKIM.shared.conversationManager.removeOnRefreshMsgListListener(
      _listenerKey,
    );
    WKIM.shared.conversationManager.removeDeleteMsgListener(_listenerKey);
  }

  @override
  void dispose() {
    _disposed = true;
    _removeListeners();
    WKIM.shared.connectionManager.disconnect(false);
    _callSignals.close();
    _groupChanges.close();
    super.dispose();
  }
}
