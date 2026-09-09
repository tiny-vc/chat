import 'dart:async';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  syncing,
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
    Dio dio, {
    PendingReadStore? pendingReadStore,
    InstallationIdStore? installationIdStore,
    Stream<List<ConnectivityResult>>? networkChanges,
    VoidCallback? connectTransport,
    VoidCallback? clearNetworkUnavailable,
    bool Function()? hasCredentials,
  }) : _dio = dio,
       _api = ChatApiClient(dio: dio, interceptors: const []),
       _installationIdStore = installationIdStore ?? InstallationIdStore() {
    _readOutbox = ReadReceiptOutbox(
      namespace: storageNamespace,
      store: pendingReadStore,
      send: _sendRead,
    );
    _connectTransport =
        connectTransport ?? WKIM.shared.connectionManager.connect;
    _clearNetworkUnavailable =
        clearNetworkUnavailable ??
        () => WKIM.shared.connectionManager.isNetworkUnavailable = false;
    _hasCredentials =
        hasCredentials ??
        () =>
            (WKIM.shared.options.uid ?? '').isNotEmpty &&
            (WKIM.shared.options.token ?? '').isNotEmpty;
    _networkChanges = networkChanges?.listen(_handleNetworkChange);
  }

  static const _listenerKey = 'flutter-chat-app';
  final Dio _dio;
  final ChatApiClient _api;
  final InstallationIdStore _installationIdStore;
  late final ReadReceiptOutbox _readOutbox;
  late final VoidCallback _connectTransport;
  late final VoidCallback _clearNetworkUnavailable;
  late final bool Function() _hasCredentials;
  StreamSubscription<List<ConnectivityResult>>? _networkChanges;
  bool _reconciling = false;
  bool get isReconciling => _reconciling;
  DateTime? lastReconciledAt;
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

  @visibleForTesting
  static bool isVisibleConversation(
    WKUIConversationMsg conversation,
    String currentUserId,
  ) =>
      conversation.channelID.isNotEmpty &&
      // A personal channel addressed to the current account is transport-only
      // state from older call signaling and must never be rendered as a chat.
      !(conversation.channelType == WKChannelType.personal &&
          conversation.channelID == currentUserId);
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
      if ({
        'group.avatar_changed',
        'group.name_changed',
        'group.announcement_changed',
        'group.member_role_changed',
        'group.owner_transferred',
        'group.join_request_approved',
      }.contains(notice.event)) {
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
        ChatMessageType.callRecord,
        (data) =>
            ChatCallRecordContent().decodeJson(Map<String, dynamic>.from(data)),
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

  static bool shouldReconnect(ImConnectionState state) =>
      state == ImConnectionState.disconnected ||
      state == ImConnectionState.noNetwork;

  Future<void> reconnect() async {
    if (_disposed || !shouldReconnect(connectionState)) return;
    if (!_hasCredentials()) return;
    error = null;
    connectionState = ImConnectionState.connecting;
    notifyListeners();
    // On some Android network transitions connectivity_plus has already
    // reported an available transport while the SDK still retains its
    // previous `isNetworkUnavailable` guard. An explicit app/user retry must
    // be allowed to probe the socket again.
    _clearNetworkUnavailable();
    _connectTransport();
  }

  void _handleNetworkChange(List<ConnectivityResult> results) {
    if (_disposed || results.contains(ConnectivityResult.none)) return;
    if (shouldReconnect(connectionState)) unawaited(reconnect());
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
    final response = await _api.getImSyncApi().imSyncRevokeMessage(
      revokeImMessageDto: RevokeImMessageDto(
        (builder) => builder
          ..channelId = channelId
          ..channelType = channelType == 1
              ? RevokeImMessageDtoChannelTypeEnum.n1
              : channelType == 2
              ? RevokeImMessageDtoChannelTypeEnum.n2
              : throw ArgumentError.value(channelType, 'channelType')
          ..clientMsgNo = clientMsgNo,
      ),
    );
    if (response.data?.success != true) {
      throw StateError('服务器未确认消息撤回');
    }
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
    final response = await _api.getImSyncApi().imSyncMarkRead(
      markImReadDto: MarkImReadDto(
        (builder) => builder
          ..channelId = channelId
          ..channelType = channelType == 1
              ? MarkImReadDtoChannelTypeEnum.n1
              : channelType == 2
              ? MarkImReadDtoChannelTypeEnum.n2
              : throw ArgumentError.value(channelType, 'channelType')
          ..messageSeq = messageSeq,
      ),
    );
    if (response.data?.success != true) {
      throw StateError('服务器未确认已读状态');
    }
  }

  /// Pulls server-owned state and retries durable operations after reconnect or
  /// foreground resume. Calls are collapsed to avoid concurrent reconciliation.
  Future<bool> reconcileRemoteState() async {
    if (_disposed || _reconciling) return false;
    final uid = WKIM.shared.options.uid ?? '';
    if (uid.isEmpty) return false;
    _reconciling = true;
    notifyListeners();
    try {
      await _readOutbox.flush(uid);
      await _loadConversationSettings();
      await _loadConversations();
      error = null;
      lastReconciledAt = DateTime.now();
      return true;
    } catch (caught) {
      error = caught;
      return false;
    } finally {
      _reconciling = false;
      notifyListeners();
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
      final response = await _api.getConversationsApi().conversationsUpdate(
        updateConversationSettingDto: UpdateConversationSettingDto(
          (builder) => builder
            ..channelId = channelId
            ..channelType = channelType == 1
                ? UpdateConversationSettingDtoChannelTypeEnum.n1
                : channelType == 2
                ? UpdateConversationSettingDtoChannelTypeEnum.n2
                : throw ArgumentError.value(channelType, 'channelType')
            ..pinned = pinned
            ..muted = muted
            ..archived = archived,
        ),
      );
      if (response.data == null) throw StateError('服务器未返回会话设置');
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
    final response = await _api.getConversationsApi().conversationsRemove(
      channelType: channelType,
      channelId: channelId,
    );
    if (response.data?.success != true) {
      throw StateError('服务器未确认删除会话');
    }
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
    final response = await _api.getImSyncApi().imSyncReceipts(
      syncImReceiptsDto: SyncImReceiptsDto(
        (builder) => builder
          ..channelId = channelId
          ..channelType = channelType == 1
              ? SyncImReceiptsDtoChannelTypeEnum.n1
              : channelType == 2
              ? SyncImReceiptsDtoChannelTypeEnum.n2
              : throw ArgumentError.value(channelType, 'channelType')
          ..messages.addAll([
            for (final message in eligible)
              ReceiptMessageDto(
                (item) => item
                  ..messageId = message.messageID
                  ..messageSeq = message.messageSeq,
              ),
          ]),
      ),
    );
    return (response.data ?? const Iterable<MessageReceiptResponse>.empty())
        .map(
          (row) => MessageReceipt(
            messageId: row.messageId,
            readCount: row.readCount.toInt(),
            unreadCount: row.unreadCount.toInt(),
          ),
        )
        .where((item) => item.messageId.isNotEmpty)
        .toList();
  }

  Future<void> _loadConversations() async {
    final currentUserId = WKIM.shared.options.uid ?? '';
    conversations = (await WKIM.shared.conversationManager.getAll())
        .where((item) => isVisibleConversation(item, currentUserId))
        .toList(growable: false);
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
    final response = await _api.getConversationsApi().conversationsList();
    final next = <String, ConversationSetting>{};
    final rows = response.data;
    if (rows == null) {
      throw const FormatException('Invalid conversation settings response');
    }
    for (final row in rows) {
      if (row.channelId.isEmpty) continue;
      next[_conversationKey(
        row.channelId,
        row.channelType,
      )] = ConversationSetting(
        pinned: row.pinned,
        muted: row.muted,
        archived: row.archived,
      );
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
        WKConnectStatus.syncMsg => ImConnectionState.syncing,
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
      final response = await _api.getImSyncApi().imSyncSyncConversations(
        syncImConversationsDto: SyncImConversationsDto(
          (builder) => builder
            ..lastMsgSeqs = lastMsgSeqs
            ..msgCount = msgCount.clamp(0, 200)
            ..version = version,
        ),
      );
      final result = WKSyncConversation()..conversations = [];
      final rows = response.data ?? const <ImSyncConversationResponse>[];
      if (_disposed) return;
      for (final row in rows) {
        final conversation = WKSyncConvMsg()
          ..channelID = row.channelId
          ..channelType = row.channelType
          ..unread = row.unread
          ..timestamp = row.timestamp
          ..lastMsgSeq = row.lastMsgSeq
          ..lastClientMsgNO = row.lastClientMsgNo
          ..version = row.version
          ..recents = _messagesFrom(row.recents);
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
      final response = await _api.getImSyncApi().imSyncSyncMessages(
        syncImChannelMessagesDto: SyncImChannelMessagesDto(
          (builder) => builder
            ..channelId = channelId
            ..channelType = channelType == 1
                ? SyncImChannelMessagesDtoChannelTypeEnum.n1
                : channelType == 2
                ? SyncImChannelMessagesDtoChannelTypeEnum.n2
                : throw ArgumentError.value(channelType, 'channelType')
            // SDK 1.7.9 subtracts one from the zero (latest) cursor when
            // filling an incomplete local page. API cursors are nonnegative.
            ..startMessageSeq = startMessageSeq == -1 && pullMode == 0
                ? 0
                : startMessageSeq
            ..endMessageSeq = endMessageSeq
            ..limit = limit.clamp(1, 100)
            ..pullMode = pullMode == 0
                ? SyncImChannelMessagesDtoPullModeEnum.n0
                : pullMode == 1
                ? SyncImChannelMessagesDtoPullModeEnum.n1
                : throw ArgumentError.value(pullMode, 'pullMode'),
        ),
      );
      final row = response.data;
      if (row == null) throw StateError('服务器未返回消息历史');
      if (_disposed) {
        complete(null);
        return;
      }
      complete(
        WKSyncChannelMsg()
          ..startMessageSeq = row.startMessageSeq
          ..endMessageSeq = row.endMessageSeq
          ..more = row.more
          ..messages = _messagesFrom(row.messages),
      );
    } catch (caught) {
      error = caught;
      // Null is the SDK failure path; an empty success would imply end of history.
      complete(null);
      notifyListeners();
    }
  }

  List<WKSyncMsg> _messagesFrom(Iterable<ImSyncMessageResponse> messages) {
    return messages.map((row) {
      return WKSyncMsg()
        ..channelID = row.channelId
        ..channelType = row.channelType
        ..messageID = row.messageId
        ..messageSeq = row.messageSeq
        ..clientMsgNO = row.clientMsgNo
        ..fromUID = row.fromUid
        ..timestamp = row.timestamp
        ..setting = row.setting
        ..payload = {
          for (final entry in row.payload.entries)
            entry.key: entry.value?.value,
        };
    }).toList();
  }

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
    unawaited(_networkChanges?.cancel());
    _networkChanges = null;
    _removeListeners();
    WKIM.shared.connectionManager.disconnect(false);
    _callSignals.close();
    _groupChanges.close();
    super.dispose();
  }
}
