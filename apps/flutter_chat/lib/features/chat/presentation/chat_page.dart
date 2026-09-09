import 'dart:async';
import '../../../core/theme/chat_styles.dart';
import 'message_details.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';
import 'package:wukongimfluttersdk/entity/channel.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';
import 'package:wukongimfluttersdk/model/wk_message_content.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';
import 'package:wukongimfluttersdk/type/const.dart';
import 'package:wukongimfluttersdk/wkim.dart';

import '../../../config/app_config.dart';
import '../../../core/im/im_service.dart';
import '../../../core/permissions/permission_ui.dart';
import '../../../core/im/conversation_draft_store.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/files/download_scheduler.dart';
import '../../../core/files/file_open_service.dart';
import '../../../core/files/file_size.dart';
import '../../../core/files/image_send_preparation.dart';
import '../../../core/files/video_thumbnail_service.dart';
import '../../../core/files/video_send_preparation.dart';
import '../../../core/calls/call_service.dart';
import '../../../core/permissions/app_permission_service.dart';
import '../../../core/im/chat_message_content.dart';
import '../../calls/presentation/outgoing_call_launcher.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/im_connection_banner.dart';
import '../../../core/im/recording_session.dart';
import '../../../core/im/message_pagination.dart';
import '../../../core/text/utf16_length_formatter.dart';
import '../../../core/theme/app_motion.dart';
import '../../../core/widgets/message_text.dart';
import 'message_renderer_registry.dart';
import 'media_send_queue.dart';
import '../../../config/server_settings.dart';

class ForwardTarget {
  const ForwardTarget({
    required this.channelId,
    required this.channelType,
    required this.title,
  });

  final String channelId;
  final int channelType;
  final String title;
}

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.channelId,
    required this.channelType,
    required this.title,
    required this.imService,
    required this.fileTransferService,
    required this.forwardTargets,
    required this.callService,
    this.memberNames = const {},
    this.memberAvatarFileIds = const {},
    this.capabilities = ServerCapabilities.all,
  });

  final String channelId;
  final int channelType;
  final String title;
  final ImService imService;
  final FileTransferService fileTransferService;
  final List<ForwardTarget> forwardTargets;
  final CallService callService;
  final Map<String, String> memberNames;
  final Map<String, String?> memberAvatarFileIds;
  final ServerCapabilities capabilities;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  ServerCapabilities get _capabilities =>
      ServerCapabilitiesScope.maybeOf(context) ?? widget.capabilities;
  static const _listenerKey = 'flutter-chat-page';
  static const _emojis = [
    '😀',
    '😃',
    '😄',
    '😁',
    '😆',
    '😅',
    '😂',
    '🤣',
    '😊',
    '🙂',
    '🙃',
    '😉',
    '😍',
    '🥰',
    '😘',
    '😋',
    '😎',
    '🤓',
    '🧐',
    '🤔',
    '🤗',
    '🤭',
    '🤫',
    '😴',
    '🥳',
    '😢',
    '😭',
    '😤',
    '😡',
    '🤯',
    '😱',
    '🥶',
    '👍',
    '👎',
    '👌',
    '✌️',
    '🤞',
    '👏',
    '🙌',
    '🙏',
    '💪',
    '👀',
    '❤️',
    '🧡',
    '💛',
    '💚',
    '💙',
    '💜',
    '💯',
    '🔥',
    '✨',
    '🎉',
    '🎁',
    '🌹',
    '☕',
    '🍻',
    '✅',
    '❌',
    '⭐',
    '🌙',
    '☀️',
    '🚀',
    '💡',
    '📌',
  ];
  final _composer = TextEditingController();
  late final _draftStore = ConversationDraftStore(
    namespace: widget.imService.storageNamespace,
  );
  final _composerFocus = FocusNode();
  final _scrollController = ScrollController();
  final _messages = <WKMsg>[];
  final _revokedClientMsgNos = <String>{};
  final _messageKeys = <String, GlobalKey>{};
  final _receipts = <String, MessageReceipt>{};
  final _recorder = AudioRecorder();
  late final RecordingSession _recordingSession;
  late final MediaSendQueue _mediaQueue;
  bool _voiceBusy = false;
  bool _uploading = false;
  double _uploadProgress = 0;
  String _uploadLabel = '附件';
  CancelToken? _uploadCancelToken;
  bool _recording = false;
  DateTime? _recordingStartedAt;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  bool _showEmojiPanel = false;
  bool _voiceMode = false;
  WKMsg? _replyingTo;
  String? _highlightedClientMsgNo;
  Timer? _highlightTimer;
  Timer? _receiptTimer;
  Timer? _draftTimer;
  bool _loadingReceipts = false;
  bool _loadingOlder = false;
  bool _hasOlderMessages = true;
  bool _olderLoadFailed = false;
  bool _attemptedOlderLoad = false;
  int _historyRevision = 0;
  late ImConnectionState _connectionState;

  String get _draftUid => WKIM.shared.options.uid ?? 'unknown-user';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _mediaQueue = MediaSendQueue()..addListener(_refreshMediaTasks);
    _recordingSession = RecordingSession(
      startRecorder: () async {
        if (!await _recorder.hasPermission()) {
          throw StateError('未获得麦克风权限');
        }
        if (!mounted) return;
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 64000,
            sampleRate: 24000,
            numChannels: 1,
          ),
          path: '${Directory.systemTemp.path}/voice_${const Uuid().v4()}.m4a',
        );
      },
      stopRecorder: _recorder.stop,
      cancelRecorder: _recorder.cancel,
      disposeRecorder: _recorder.dispose,
      discardFile: (path) async {
        await File(path).delete().catchError((_) => File(path));
      },
    );
    WKIM.shared.messageManager.addOnNewMsgListener(_listenerKey, _onMessages);
    WKIM.shared.messageManager.addOnMsgInsertedListener(_onInserted);
    WKIM.shared.messageManager.addOnRefreshMsgListener(
      _listenerKey,
      _onInserted,
    );
    _loadMessages();
    _historyRevision = widget.imService.historyRevision;
    _connectionState = widget.imService.connectionState;
    widget.imService.addListener(_onHistorySync);
    _loadDraft();
    _composer.addListener(_scheduleDraftSave);
    _scrollController.addListener(_onMessageScroll);
    widget.imService.markRead(widget.channelId, widget.channelType);
    _startReceiptPolling();
  }

  void _startReceiptPolling() {
    _receiptTimer?.cancel();
    _receiptTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshReceipts(),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startReceiptPolling();
      unawaited(_refreshReceipts());
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _receiptTimer?.cancel();
      _receiptTimer = null;
    }
  }

  void _refreshMediaTasks() {
    if (mounted) setState(() {});
  }

  Future<void> _loadDraft() async {
    final draft = await _draftStore.read(
      _draftUid,
      widget.channelId,
      widget.channelType,
    );
    if (mounted && _composer.text.isEmpty && draft.isNotEmpty) {
      _composer.text = draft;
      _composer.selection = TextSelection.collapsed(offset: draft.length);
    }
  }

  void _scheduleDraftSave() {
    if (mounted) setState(() {});
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(milliseconds: 400), () {
      _draftStore.write(
        _draftUid,
        widget.channelId,
        widget.channelType,
        _composer.text,
      );
    });
  }

  void _onHistorySync() {
    final revision = widget.imService.historyRevision;
    if (revision != _historyRevision) {
      _historyRevision = revision;
      _loadMessages();
    }
    final connectionState = widget.imService.connectionState;
    if (mounted && connectionState != _connectionState) {
      setState(() => _connectionState = connectionState);
    }
  }

  void _loadMessages() {
    WKIM.shared.messageManager.getOrSyncHistoryMessages(
      widget.channelId,
      widget.channelType,
      0,
      false,
      0,
      50,
      0,
      (List<WKMsg> messages) {
        _replaceMessages(messages);
        if (mounted) {
          setState(() => _hasOlderMessages = messages.length >= 50);
        }
      },
      () {},
    );
  }

  void _onMessageScroll() {
    if (!_scrollController.hasClients ||
        _scrollController.position.extentAfter > 160) {
      return;
    }
    _loadOlderMessages();
  }

  Future<void> _loadOlderMessages() async {
    if (_loadingOlder || !_hasOlderMessages || _messages.isEmpty || !mounted) {
      return;
    }
    final oldestOrderSeq = _messages
        .map((message) => message.orderSeq)
        .where((orderSeq) => orderSeq > 0)
        .fold<int>(
          0,
          (oldest, value) => oldest == 0 || value < oldest ? value : oldest,
        );
    if (oldestOrderSeq == 0) {
      setState(() {
        _attemptedOlderLoad = true;
        _hasOlderMessages = false;
      });
      return;
    }
    setState(() {
      _loadingOlder = true;
      _olderLoadFailed = false;
      _attemptedOlderLoad = true;
    });
    try {
      await WKIM.shared.messageManager.getOrSyncHistoryMessages(
        widget.channelId,
        widget.channelType,
        oldestOrderSeq,
        false,
        0,
        50,
        0,
        (List<WKMsg> older) {
          if (!mounted) return;
          final merged = mergeOlderMessagePage(_messages, older);
          setState(() {
            _messages
              ..clear()
              ..addAll(merged.messages);
            _hasOlderMessages = older.length >= 50 && merged.addedCount > 0;
            _loadingOlder = false;
          });
        },
        () {},
      );
    } catch (_) {
      if (mounted) {
        setState(() {
          _loadingOlder = false;
          _olderLoadFailed = true;
        });
      }
    }
  }

  void _replaceMessages(List<WKMsg> messages, {bool scrollBottom = true}) {
    if (!mounted) return;
    final revoked = messages
        .map((message) => message.messageContent)
        .whereType<ChatRevokeContent>()
        .map((content) => content.originalClientMsgNo);
    setState(() {
      _revokedClientMsgNos.addAll(revoked);
      _messages
        ..clear()
        ..addAll(
          messages.where(
            (message) => message.messageContent is! ChatRevokeContent,
          ),
        )
        ..sort((a, b) => a.orderSeq.compareTo(b.orderSeq));
    });
    if (scrollBottom) _scrollToBottom();
    final maxSequence = messages.fold<int>(
      0,
      (maximum, message) =>
          message.messageSeq > maximum ? message.messageSeq : maximum,
    );
    widget.imService.markRead(
      widget.channelId,
      widget.channelType,
      messageSeq: maxSequence,
    );
    _refreshReceipts();
  }

  void _onMessages(List<WKMsg> messages) {
    for (final message in messages) {
      if (message.channelID == widget.channelId &&
          message.channelType == widget.channelType) {
        _upsert(message);
        widget.imService.markRead(
          widget.channelId,
          widget.channelType,
          messageSeq: message.messageSeq,
        );
      }
    }
  }

  void _onInserted(WKMsg message) {
    if (message.channelID == widget.channelId &&
        message.channelType == widget.channelType) {
      _upsert(message);
    }
  }

  void _upsert(WKMsg message) {
    if (!mounted) return;
    if (message.messageContent case ChatRevokeContent revoke) {
      setState(() => _revokedClientMsgNos.add(revoke.originalClientMsgNo));
      return;
    }
    setState(() {
      upsertMessageInOrder(_messages, message);
    });
    _scrollToBottom();
    if (message.fromUID == WKIM.shared.options.uid) _refreshReceipts();
  }

  Future<void> _refreshReceipts() async {
    if (_loadingReceipts || !mounted) return;
    final sent = _messages
        .where((message) => message.fromUID == WKIM.shared.options.uid)
        .toList();
    if (sent.isEmpty) return;
    _loadingReceipts = true;
    try {
      final receipts = await widget.imService.loadReceipts(
        channelId: widget.channelId,
        channelType: widget.channelType,
        messages: sent,
      );
      if (mounted) {
        final changed = receipts.any((receipt) {
          final current = _receipts[receipt.messageId];
          return current == null ||
              current.readCount != receipt.readCount ||
              current.unreadCount != receipt.unreadCount;
        });
        if (changed) {
          setState(() {
            for (final receipt in receipts) {
              _receipts[receipt.messageId] = receipt;
            }
          });
        }
      }
    } catch (_) {
      // Receipt refresh is best-effort and should not interrupt messaging.
    } finally {
      _loadingReceipts = false;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        // The list is bottom-anchored: zero stays exact even when lazily built
        // variable-height bubbles change the estimated scroll extent.
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _openSearch() async {
    final message = await Navigator.of(context).push<WKMsg>(
      MaterialPageRoute(
        builder: (_) => _ChatSearchPage(
          channelId: widget.channelId,
          channelType: widget.channelType,
        ),
      ),
    );
    if (message == null || !mounted) return;
    await _focusMessage(message);
  }

  Future<void> _startCall({required bool video}) async {
    await launchOutgoingCall(
      context: context,
      targetUserId: widget.channelId,
      title: widget.title,
      video: video,
      callService: widget.callService,
      imService: widget.imService,
      capabilities: _capabilities,
    );
  }

  Future<void> _confirmCall({required bool video}) async {
    final confirmed = await AppFeedback.confirm(
      context,
      title: video ? '发起视频通话' : '发起语音通话',
      message: '将呼叫“${widget.title}”，是否继续？',
      confirmLabel: '呼叫',
    );
    if (confirmed == true && mounted) await _startCall(video: video);
  }

  Future<void> _focusMessage(WKMsg target) async {
    if (!_messages.any((item) => item.clientMsgNO == target.clientMsgNO)) {
      await WKIM.shared.messageManager.getOrSyncHistoryMessages(
        widget.channelId,
        widget.channelType,
        0,
        false,
        0,
        50,
        target.orderSeq,
        (messages) => _replaceMessages(messages, scrollBottom: false),
        () {},
      );
    }
    if (!mounted) return;
    setState(() => _highlightedClientMsgNo = target.clientMsgNO);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final itemContext = _messageKeys[target.clientMsgNO]?.currentContext;
      if (itemContext != null) {
        Scrollable.ensureVisible(
          itemContext,
          duration: appMotionDuration(
            context,
            const Duration(milliseconds: 320),
          ),
          alignment: 0.35,
        );
      }
    });
    _highlightTimer?.cancel();
    _receiptTimer?.cancel();
    _highlightTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _highlightedClientMsgNo = null);
    });
  }

  void _send() {
    if (!_capabilities.messaging) {
      AppFeedback.show(context, '当前服务器暂停了消息发送');
      return;
    }
    final text = _composer.text.trim();
    if (text.isEmpty) return;
    _composer.clear();
    _draftStore.write(_draftUid, widget.channelId, widget.channelType, '');
    final content = WKTextContent(text);
    _attachReply(content);
    WKIM.shared.messageManager.sendMessage(
      content,
      WKChannel(widget.channelId, widget.channelType),
    );
  }

  void _attachReply(WKMessageContent content) {
    _attachReplyFrom(content, _takeReply());
  }

  WKMsg? _takeReply() {
    final original = _replyingTo;
    if (original != null && mounted) {
      setState(() => _replyingTo = null);
    }
    return original;
  }

  void _attachReplyFrom(WKMessageContent content, WKMsg? original) {
    if (original == null) return;
    final parent = original.messageContent?.reply;
    content.reply = WKReply()
      ..rootMid = parent?.rootMid.isNotEmpty == true
          ? parent!.rootMid
          : original.messageID
      ..messageId = original.messageID
      ..messageSeq = original.messageSeq
      ..fromUID = original.fromUID
      ..fromName = original.fromUID == WKIM.shared.options.uid
          ? '我'
          : widget.channelType == 1
          ? widget.title
          : original.fromUID
      ..payload = original.messageContent;
  }

  void _toggleEmojiPanel() {
    if (_showEmojiPanel) {
      setState(() => _showEmojiPanel = false);
      _composerFocus.requestFocus();
    } else {
      _composerFocus.unfocus();
      setState(() => _showEmojiPanel = true);
    }
  }

  void _toggleComposerMode() {
    if (_recording || _voiceBusy || _uploading) return;
    setState(() {
      _voiceMode = !_voiceMode;
      _showEmojiPanel = false;
    });
    if (_voiceMode) {
      _composerFocus.unfocus();
    } else {
      _composerFocus.requestFocus();
    }
  }

  void _insertEmoji(String emoji) {
    final value = _composer.value;
    final selection = value.selection.isValid
        ? value.selection
        : TextSelection.collapsed(offset: value.text.length);
    final start = selection.start.clamp(0, value.text.length);
    final end = selection.end.clamp(0, value.text.length);
    final text = value.text.replaceRange(start, end, emoji);
    _composer.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  Future<void> _showMessageActions(WKMsg message, bool mine) async {
    final textMessage = message.messageContent is WKTextContent;
    final fileMessage =
        message.messageContent is ChatImageContent ||
        message.messageContent is ChatVideoContent ||
        message.messageContent is ChatFileContent ||
        message.messageContent is ChatAudioContent;
    final hasForwardTarget = widget.forwardTargets.any(
      (target) =>
          (_capabilities.groups || target.channelType != 2) &&
          (target.channelId != widget.channelId ||
              target.channelType != widget.channelType),
    );
    final canForward =
        _capabilities.messaging &&
        isForwardableChatContent(message.messageContent) &&
        hasForwardTarget &&
        (!fileMessage || _capabilities.canSendFiles);
    final canRetry =
        mine &&
        message.status == WKSendMsgResult.sendFail &&
        _capabilities.messaging &&
        isForwardableChatContent(message.messageContent) &&
        (!fileMessage || _capabilities.canSendFiles);
    final canReply =
        _capabilities.messaging &&
        message.messageID.isNotEmpty &&
        isForwardableChatContent(message.messageContent);
    final canRevoke =
        mine &&
        _capabilities.messaging &&
        message.messageID.isNotEmpty &&
        message.timestamp > 0 &&
        DateTime.now().millisecondsSinceEpoch ~/ 1000 - message.timestamp <=
            120;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                '消息操作',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (canReply)
              ListTile(
                leading: const Icon(Icons.reply),
                title: const Text('回复'),
                onTap: () => Navigator.pop(context, 'reply'),
              ),
            if (textMessage)
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: const Text('复制'),
                onTap: () => Navigator.pop(context, 'copy'),
              ),
            if (canForward)
              ListTile(
                leading: const Icon(Icons.forward_outlined),
                title: const Text('转发'),
                onTap: () => Navigator.pop(context, 'forward'),
              ),
            if (canRetry)
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('重新发送'),
                subtitle: const Text('将替换这条发送失败的本机记录'),
                onTap: () => Navigator.pop(context, 'retry'),
              ),
            if (canRevoke)
              ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('撤回'),
                subtitle: const Text('发送后 2 分钟内可撤回'),
                onTap: () => Navigator.pop(context, 'revoke'),
              ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                '从本机删除',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              subtitle: const Text('只删除当前设备上的记录'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    try {
      switch (action) {
        case 'retry':
          await _retryMessage(message);
        case 'forward':
          await _forwardMessage(message);
        case 'reply':
          setState(() {
            _replyingTo = message;
            _showEmojiPanel = false;
          });
          _composerFocus.requestFocus();
        case 'copy':
          await Clipboard.setData(
            ClipboardData(text: message.messageContent!.displayText()),
          );
          if (mounted) {
            AppFeedback.show(context, '已复制', kind: FeedbackKind.success);
          }
        case 'delete':
          final confirmed = await AppFeedback.confirm(
            context,
            title: '删除本机消息',
            message: '只删除当前设备上的这条消息，不影响其他成员的记录。',
            confirmLabel: '删除',
            destructive: true,
          );
          if (!confirmed || !mounted) return;
          await WKIM.shared.messageManager.deleteWithClientMsgNo(
            message.clientMsgNO,
          );
          if (mounted) {
            setState(() {
              _messages.removeWhere(
                (item) => item.clientMsgNO == message.clientMsgNO,
              );
            });
          }
        case 'revoke':
          await widget.imService.revokeMessage(
            channelId: widget.channelId,
            channelType: widget.channelType,
            clientMsgNo: message.clientMsgNO,
          );
          if (mounted) {
            setState(() => _revokedClientMsgNos.add(message.clientMsgNO));
          }
      }
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '操作失败，请稍后重试');
      }
    }
  }

  Future<void> _retryMessage(WKMsg message) async {
    if (!_capabilities.messaging) throw StateError('服务器已暂停消息发送');
    final content = message.messageContent;
    if (content == null) throw StateError('无法重新发送此消息');
    await WKIM.shared.messageManager.deleteWithClientMsgNo(message.clientMsgNO);
    if (mounted) {
      setState(() {
        _messages.removeWhere(
          (item) => item.clientMsgNO == message.clientMsgNO,
        );
      });
    }
    await WKIM.shared.messageManager.sendMessage(
      content,
      WKChannel(widget.channelId, widget.channelType),
    );
  }

  Future<void> _forwardMessage(WKMsg message) async {
    if (!_capabilities.messaging) throw StateError('服务器已暂停消息发送');
    final source = message.messageContent;
    final fileMessage =
        source is ChatImageContent ||
        source is ChatVideoContent ||
        source is ChatFileContent ||
        source is ChatAudioContent;
    if (fileMessage && !_capabilities.canSendFiles) {
      throw StateError('服务器已暂停文件发送');
    }
    final targets = widget.forwardTargets
        .where(
          (target) =>
              (_capabilities.groups || target.channelType != 2) &&
              (target.channelId != widget.channelId ||
                  target.channelType != widget.channelType),
        )
        .toList();
    if (targets.isEmpty) {
      throw StateError('没有其他可转发的会话');
    }
    final target = await showModalBottomSheet<ForwardTarget>(
      context: context,
      builder: (context) => SafeArea(
        child: SizedBox(
          height: 420,
          child: Column(
            children: [
              const ListTile(
                title: Text('选择转发目标'),
                subtitle: Text('文件类消息会在服务器内部复制并重新授权'),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: targets.length,
                  itemBuilder: (context, index) {
                    final item = targets[index];
                    return ListTile(
                      leading: Icon(
                        item.channelType == 2
                            ? Icons.group_outlined
                            : Icons.person_outline,
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.channelType == 2 ? '群聊' : '好友'),
                      onTap: () => Navigator.pop(context, item),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (target == null) return;
    if (source == null) throw StateError('无法转发此消息');
    final WKMessageContent forwarded;
    if (source case WKTextContent text) {
      forwarded = WKTextContent(text.content);
    } else if (source case ChatImageContent image) {
      final forwardedFileId = await widget.fileTransferService.forwardFile(
        fileId: image.fileId,
        channelId: target.channelId,
        channelType: target.channelType,
      );
      var forwardedThumbnailId = '';
      if (image.thumbnailFileId.isNotEmpty) {
        forwardedThumbnailId = await widget.fileTransferService.forwardFile(
          fileId: image.thumbnailFileId,
          channelId: target.channelId,
          channelType: target.channelType,
        );
        await widget.fileTransferService.setThumbnail(
          fileId: forwardedFileId,
          thumbnailFileId: forwardedThumbnailId,
        );
      }
      forwarded = ChatImageContent(
        fileId: forwardedFileId,
        size: image.size,
        mimeType: image.mimeType,
        width: image.width,
        height: image.height,
        thumbnailFileId: forwardedThumbnailId,
        thumbnailSize: image.thumbnailSize,
      );
    } else if (source case ChatVideoContent video) {
      final forwardedFileId = await widget.fileTransferService.forwardFile(
        fileId: video.fileId,
        channelId: target.channelId,
        channelType: target.channelType,
      );
      var forwardedThumbnailId = '';
      if (video.thumbnailFileId.isNotEmpty) {
        forwardedThumbnailId = await widget.fileTransferService.forwardFile(
          fileId: video.thumbnailFileId,
          channelId: target.channelId,
          channelType: target.channelType,
        );
        await widget.fileTransferService.setThumbnail(
          fileId: forwardedFileId,
          thumbnailFileId: forwardedThumbnailId,
        );
      }
      forwarded = ChatVideoContent(
        fileId: forwardedFileId,
        name: video.name,
        size: video.size,
        durationMs: video.durationMs,
        width: video.width,
        height: video.height,
        thumbnailFileId: forwardedThumbnailId,
      );
    } else if (source case ChatFileContent file) {
      forwarded = ChatFileContent(
        fileId: await widget.fileTransferService.forwardFile(
          fileId: file.fileId,
          channelId: target.channelId,
          channelType: target.channelType,
        ),
        name: file.name,
        size: file.size,
        mimeType: file.mimeType,
      );
    } else if (source case ChatAudioContent audio) {
      forwarded = ChatAudioContent(
        fileId: await widget.fileTransferService.forwardFile(
          fileId: audio.fileId,
          channelId: target.channelId,
          channelType: target.channelType,
        ),
        durationMs: audio.durationMs,
        size: audio.size,
        mimeType: audio.mimeType,
      );
    } else {
      throw StateError('暂不支持转发此类型消息');
    }
    WKIM.shared.messageManager.sendMessage(
      forwarded,
      WKChannel(target.channelId, target.channelType),
    );
    if (mounted) {
      AppFeedback.show(
        context,
        '已转发给 ${target.title}',
        kind: FeedbackKind.success,
      );
    }
  }

  Future<void> _pickAndSend({required bool image}) async {
    Navigator.of(context).pop();
    final file = image
        ? await pickPortableChatImage()
        : await FilePicker.pickFile(type: FileType.any);
    if (file == null || !mounted) return;
    final limits = ServerCapabilitiesScope.uploadLimitsOf(context);
    if (!await _validateSelectedFileSize(
      file,
      maxBytes: image ? limits.chatImage : limits.chatFile,
      kindLabel: image ? '图片' : '文件',
    )) {
      return;
    }
    var uploadFile = file;
    Uint8List? imageBytes;
    if (image) {
      try {
        imageBytes = await readPlatformFileBytes(file);
        if (!mounted) return;
        final compress = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => _ImageSendPreview(
            name: file.name,
            bytes: imageBytes!,
            canCompress: canCompressChatImage(file),
          ),
        );
        if (compress == null || !mounted) return;
        setState(() {
          _uploading = true;
          _uploadProgress = 0;
          _uploadLabel = compress
              ? '正在优化图片 · ${file.name}'
              : '正在准备图片 · ${file.name}';
        });
        final prepared = await prepareChatImage(
          file,
          compress: compress,
          sourceBytes: imageBytes,
        );
        uploadFile = prepared.file;
        imageBytes = prepared.previewBytes;
      } catch (error) {
        if (mounted) {
          setState(() => _uploading = false);
          AppFeedback.error(context, error, fallback: '图片处理失败，请重新选择');
        }
        return;
      }
    } else {
      try {
        final confirmed = await _confirmAttachmentSend(
          file: file,
          kindLabel: '文件',
          icon: Icons.description_outlined,
        );
        if (!confirmed || !mounted) return;
      } catch (error) {
        if (mounted) {
          AppFeedback.error(context, error, fallback: '无法读取文件，请重新选择');
        }
        return;
      }
    }
    setState(() {
      _uploading = true;
      _uploadProgress = 0;
      _uploadLabel = image ? '正在上传图片 · ${file.name}' : '正在上传文件 · ${file.name}';
    });
    final cancelToken = CancelToken();
    final reply = _takeReply();
    final task = _mediaQueue.start(_uploadLabel, cancelToken: cancelToken);
    _mediaQueue.upload(task.id);
    _uploadCancelToken = cancelToken;
    try {
      var width = 0;
      var height = 0;
      if (image) {
        final dimensions = await _imageDimensions(imageBytes!);
        width = dimensions.$1;
        height = dimensions.$2;
      }
      final uploaded = await widget.fileTransferService.upload(
        file: uploadFile,
        channelId: widget.channelId,
        channelType: widget.channelType,
        image: image,
        onProgress: (sent, total) {
          _mediaQueue.progress(task.id, sent, total);
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
        cancelToken: cancelToken,
      );
      String thumbnailFileId = '';
      var thumbnailSize = 0;
      if (image) {
        try {
          _mediaQueue.prepare(task.id, label: '正在生成聊天预览…');
          if (mounted) {
            setState(() => _uploadLabel = '正在生成聊天预览…');
          }
          final thumbnail = await prepareChatThumbnail(
            imageBytes!,
            baseName: file.name,
          );
          if (thumbnail != null) {
            _mediaQueue.upload(task.id, label: '正在上传聊天预览…');
            if (mounted) {
              setState(() => _uploadLabel = '正在上传聊天预览…');
            }
            final uploadedThumbnail = await widget.fileTransferService.upload(
              file: thumbnail.file,
              channelId: widget.channelId,
              channelType: widget.channelType,
              image: true,
              onProgress: (sent, total) {
                _mediaQueue.progress(task.id, sent, total);
              },
              cancelToken: cancelToken,
            );
            await widget.fileTransferService.setThumbnail(
              fileId: uploaded.fileId,
              thumbnailFileId: uploadedThumbnail.fileId,
            );
            thumbnailFileId = uploadedThumbnail.fileId;
            thumbnailSize = uploadedThumbnail.size;
          }
        } on DioException catch (error) {
          if (CancelToken.isCancel(error)) rethrow;
          // A thumbnail is an optimization. If its upload or binding fails,
          // keep the original image send reliable and use the legacy fallback.
        } catch (_) {
          // Unsupported/corrupt preview data must not discard an uploaded image.
        }
      }
      final content = image
          ? ChatImageContent(
              fileId: uploaded.fileId,
              size: uploaded.size,
              mimeType: uploaded.mimeType,
              width: width,
              height: height,
              thumbnailFileId: thumbnailFileId,
              thumbnailSize: thumbnailSize,
            )
          : ChatFileContent(
              fileId: uploaded.fileId,
              name: uploaded.name,
              size: uploaded.size,
              mimeType: uploaded.mimeType,
            );
      _attachReplyFrom(content, reply);
      WKIM.shared.messageManager.sendMessage(
        content,
        WKChannel(widget.channelId, widget.channelType),
      );
      _mediaQueue.complete(task.id);
    } on DioException catch (error) {
      if (mounted && CancelToken.isCancel(error)) {
        _mediaQueue.complete(task.id);
        AppFeedback.show(context, '已取消上传，未发送');
      } else if (mounted) {
        _mediaQueue.fail(
          task.id,
          image ? '图片发送失败' : '文件发送失败',
          retry: () => _pickAndSend(image: image),
          retryLabel: '重新选择',
        );
        AppFeedback.error(
          context,
          error,
          fallback: '发送失败，请稍后重试',
          actionLabel: '重新选择',
          onAction: _showAttachments,
        );
      }
    } catch (error) {
      if (mounted) {
        _mediaQueue.fail(
          task.id,
          image ? '图片发送失败' : '文件发送失败',
          retry: () => _pickAndSend(image: image),
          retryLabel: '重新选择',
        );
        AppFeedback.error(
          context,
          error,
          fallback: '发送失败，请稍后重试',
          actionLabel: '重新选择',
          onAction: _showAttachments,
        );
      }
    } finally {
      if (identical(_uploadCancelToken, cancelToken)) {
        _uploadCancelToken = null;
      }
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<(int, int)> _imageDimensions(Uint8List bytes) async {
    final image = await decodeImageFromList(bytes);
    final result = (image.width, image.height);
    image.dispose();
    return result;
  }

  Future<void> _pickAndSendVideo() async {
    Navigator.of(context).pop();
    final file = await pickPortableChatVideo();
    if (file == null || !mounted) return;
    final maxVideoBytes = ServerCapabilitiesScope.uploadLimitsOf(
      context,
    ).chatVideo;
    if (!await _validateSelectedFileSize(
      file,
      maxBytes: maxVideoBytes,
      kindLabel: '视频',
    )) {
      return;
    }
    VideoPlayerController? metadataController;
    PreparedChatVideo? preparedVideo;
    var durationMs = 0;
    var videoWidth = 0;
    var videoHeight = 0;
    var confirmed = false;
    try {
      setState(() {
        _uploading = true;
        _uploadProgress = -1;
        _uploadLabel = '正在转换为兼容视频…';
      });
      preparedVideo = await VideoSendPreparation.prepare(file);
      if (!await _validateSelectedFileSize(
        preparedVideo.file,
        maxBytes: maxVideoBytes,
        kindLabel: '转换后的视频',
      )) {
        await preparedVideo.dispose();
        if (mounted) setState(() => _uploading = false);
        return;
      }
      final path = preparedVideo.file.path!;
      metadataController = VideoPlayerController.file(File(path));
      await metadataController.initialize();
      durationMs = metadataController.value.duration.inMilliseconds;
      videoWidth = metadataController.value.size.width.round();
      videoHeight = metadataController.value.size.height.round();
      if (durationMs <= 0 || videoWidth <= 0 || videoHeight <= 0) {
        throw StateError('无法读取视频时长或画面尺寸');
      }
      if (!mounted) return;
      confirmed = await _confirmAttachmentSend(
        file: preparedVideo.file,
        kindLabel: '视频',
        icon: Icons.video_library_outlined,
        preview: AspectRatio(
          aspectRatio: metadataController.value.aspectRatio > 0
              ? metadataController.value.aspectRatio
              : 16 / 9,
          child: VideoPlayer(metadataController),
        ),
      );
    } catch (error) {
      await metadataController?.dispose();
      await preparedVideo?.dispose();
      if (mounted) setState(() => _uploading = false);
      if (mounted) {
        AppFeedback.error(context, error, fallback: '无法读取视频，请重新选择');
      }
      return;
    }
    if (!confirmed || !mounted) {
      await metadataController.dispose();
      await preparedVideo.dispose();
      if (mounted) setState(() => _uploading = false);
      return;
    }
    final uploadVideo = preparedVideo.file;
    setState(() {
      _uploading = true;
      _uploadProgress = 0;
      _uploadLabel = '视频 · ${uploadVideo.name}';
    });
    final cancelToken = CancelToken();
    final reply = _takeReply();
    final task = _mediaQueue.start(_uploadLabel, cancelToken: cancelToken);
    _mediaQueue.upload(task.id);
    _uploadCancelToken = cancelToken;
    try {
      final uploaded = await widget.fileTransferService.uploadVideo(
        file: uploadVideo,
        channelId: widget.channelId,
        channelType: widget.channelType,
        onProgress: (sent, total) {
          _mediaQueue.progress(task.id, sent, total);
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
        cancelToken: cancelToken,
      );
      var thumbnailFileId = '';
      try {
        _mediaQueue.prepare(task.id, label: '正在生成视频封面…');
        if (mounted) setState(() => _uploadLabel = '正在生成视频封面…');
        final thumbnailBytes = await VideoThumbnailService.create(
          uploadVideo.path!,
        );
        if (thumbnailBytes != null && thumbnailBytes.isNotEmpty) {
          final thumbnail = MemoryPlatformFile(
            name:
                '${uploadVideo.name.replaceFirst(RegExp(r'\.[^.]+$'), '')}_cover.jpg',
            bytes: thumbnailBytes,
          );
          _mediaQueue.upload(task.id, label: '正在上传视频封面…');
          if (mounted) setState(() => _uploadLabel = '正在上传视频封面…');
          final uploadedThumbnail = await widget.fileTransferService.upload(
            file: thumbnail,
            channelId: widget.channelId,
            channelType: widget.channelType,
            image: true,
            onProgress: (sent, total) {
              _mediaQueue.progress(task.id, sent, total);
            },
            cancelToken: cancelToken,
          );
          await widget.fileTransferService.setThumbnail(
            fileId: uploaded.fileId,
            thumbnailFileId: uploadedThumbnail.fileId,
          );
          thumbnailFileId = uploadedThumbnail.fileId;
        }
      } on DioException catch (error) {
        if (CancelToken.isCancel(error)) rethrow;
        // A cover is an optimization; keep a valid uploaded video sendable.
      } catch (_) {
        // Unsupported codecs render the neutral play placeholder instead.
      }
      final content = ChatVideoContent(
        fileId: uploaded.fileId,
        name: uploaded.name,
        size: uploaded.size,
        durationMs: durationMs,
        width: videoWidth,
        height: videoHeight,
        thumbnailFileId: thumbnailFileId,
      );
      _attachReplyFrom(content, reply);
      WKIM.shared.messageManager.sendMessage(
        content,
        WKChannel(widget.channelId, widget.channelType),
      );
      _mediaQueue.complete(task.id);
    } on DioException catch (error) {
      if (mounted && CancelToken.isCancel(error)) {
        _mediaQueue.complete(task.id);
        AppFeedback.show(context, '已取消上传，未发送');
      } else if (mounted) {
        _mediaQueue.fail(
          task.id,
          '视频发送失败',
          retry: _pickAndSendVideo,
          retryLabel: '重新选择',
        );
        AppFeedback.error(
          context,
          error,
          fallback: '视频发送失败，请稍后重试',
          actionLabel: '重新选择',
          onAction: _showAttachments,
        );
      }
    } catch (error) {
      if (mounted) {
        _mediaQueue.fail(
          task.id,
          '视频发送失败',
          retry: _pickAndSendVideo,
          retryLabel: '重新选择',
        );
        AppFeedback.error(
          context,
          error,
          fallback: '视频发送失败，请稍后重试',
          actionLabel: '重新选择',
          onAction: _showAttachments,
        );
      }
    } finally {
      await metadataController.dispose();
      await preparedVideo.dispose();
      if (identical(_uploadCancelToken, cancelToken)) {
        _uploadCancelToken = null;
      }
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<bool> _confirmAttachmentSend({
    required PlatformFile file,
    required String kindLabel,
    required IconData icon,
    Widget? preview,
  }) async {
    final size = await file.length();
    if (!mounted) return false;
    return await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => AttachmentSendConfirmation(
            name: file.name,
            sizeLabel: formatFileSize(size),
            kindLabel: kindLabel,
            icon: icon,
            preview: preview,
          ),
        ) ??
        false;
  }

  Future<bool> _validateSelectedFileSize(
    PlatformFile file, {
    required int maxBytes,
    required String kindLabel,
  }) async {
    try {
      final size = await file.length();
      if (!mounted) return false;
      if (size > maxBytes) {
        AppFeedback.show(
          context,
          '$kindLabel大小为 ${formatFileSize(size)}，服务器上限为 ${formatFileSize(maxBytes)}',
          kind: FeedbackKind.error,
        );
        return false;
      }
      return true;
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '无法读取$kindLabel大小，请重新选择');
      }
      return false;
    }
  }

  void _showAttachments() {
    final canCall =
        widget.channelType == 1 &&
        (_capabilities.canAudioCall || _capabilities.canVideoCall);
    if (!_capabilities.canSendFiles && !canCall) {
      AppFeedback.show(context, '当前服务器未提供更多功能');
      return;
    }
    _composerFocus.unfocus();
    if (_showEmojiPanel) setState(() => _showEmojiPanel = false);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('更多功能', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 18),
              if (_capabilities.canSendFiles)
                Row(
                  children: [
                    Expanded(
                      child: _AttachmentAction(
                        icon: Icons.image_outlined,
                        label: '图片',
                        color: const Color(0xFF45A675),
                        onTap: () => _pickAndSend(image: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AttachmentAction(
                        icon: Icons.video_library_outlined,
                        label: '视频',
                        color: const Color(0xFF7B61D1),
                        onTap: _pickAndSendVideo,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AttachmentAction(
                        icon: Icons.description_outlined,
                        label: '文件',
                        color: const Color(0xFF3978C5),
                        onTap: () => _pickAndSend(image: false),
                      ),
                    ),
                  ],
                ),
              if (_capabilities.canSendFiles && canCall)
                const SizedBox(height: 14),
              if (canCall)
                Row(
                  children: [
                    if (_capabilities.canAudioCall)
                      Expanded(
                        child: _AttachmentAction(
                          icon: Icons.call_outlined,
                          label: '语音通话',
                          color: const Color(0xFF2F9D74),
                          onTap: () {
                            Navigator.pop(context);
                            unawaited(_startCall(video: false));
                          },
                        ),
                      ),
                    if (_capabilities.canAudioCall &&
                        _capabilities.canVideoCall)
                      const SizedBox(width: 12),
                    if (_capabilities.canVideoCall)
                      Expanded(
                        child: _AttachmentAction(
                          icon: Icons.videocam_outlined,
                          label: '视频通话',
                          color: const Color(0xFF6C5BC7),
                          onTap: () {
                            Navigator.pop(context);
                            unawaited(_startCall(video: true));
                          },
                        ),
                      ),
                    if (!(_capabilities.canAudioCall &&
                        _capabilities.canVideoCall))
                      const Spacer(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (_voiceBusy || _uploading || _mediaQueue.hasActive || !mounted) return;
    if (_recording) {
      await _stopAndSendVoice();
      return;
    }
    if (!await ensureAppPermission(
      context,
      AppPermission.microphone,
      title: '允许使用麦克风',
      rationale: '发送语音消息需要麦克风权限。录音只会在你主动录制期间进行。',
    )) {
      return;
    }
    if (!mounted) return;
    setState(() => _voiceBusy = true);
    try {
      if (!await _recordingSession.start() || !mounted) return;
      _recordingStartedAt = DateTime.now();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        final seconds = DateTime.now()
            .difference(_recordingStartedAt!)
            .inSeconds;
        setState(() => _recordingSeconds = seconds);
        if (seconds >= 600) _stopAndSendVoice();
      });
      setState(() {
        _recording = true;
        _recordingSeconds = 0;
      });
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '无法录音，请检查麦克风权限后重试');
      }
    } finally {
      if (mounted) setState(() => _voiceBusy = false);
    }
  }

  Future<void> _stopAndSendVoice() async {
    if (_voiceBusy || !_recording || !mounted) return;
    setState(() => _voiceBusy = true);
    String? path;
    MediaSendTask? mediaTask;
    try {
      path = await _recordingSession.stop();
      _recordingTimer?.cancel();
      final duration = DateTime.now()
          .difference(_recordingStartedAt!)
          .inMilliseconds;
      if (!mounted) return;
      final voiceLimit = ServerCapabilitiesScope.uploadLimitsOf(
        context,
      ).chatVoice;
      final voiceSize = path == null ? 0 : await File(path).length();
      if (!mounted) return;
      if (voiceSize > voiceLimit) {
        setState(() {
          _recording = false;
          _voiceBusy = false;
        });
        AppFeedback.show(
          context,
          '语音大小为 ${formatFileSize(voiceSize)}，服务器上限为 ${formatFileSize(voiceLimit)}',
          kind: FeedbackKind.error,
        );
        return;
      }
      if (mounted) {
        setState(() {
          _recording = false;
          _uploading = true;
          _uploadProgress = 0;
          _uploadLabel = '语音消息';
        });
      }
      if (path == null || duration < 500) {
        if (mounted) {
          setState(() => _uploading = false);
          AppFeedback.show(context, '录音时间太短，请录制至少半秒');
        }
        return;
      }
      final cancelToken = CancelToken();
      mediaTask = _mediaQueue.start('语音消息', cancelToken: cancelToken);
      _mediaQueue.upload(mediaTask.id);
      _uploadCancelToken = cancelToken;
      final uploaded = await widget.fileTransferService.uploadVoice(
        path: path,
        channelId: widget.channelId,
        channelType: widget.channelType,
        onProgress: (sent, total) {
          _mediaQueue.progress(mediaTask!.id, sent, total);
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
        cancelToken: cancelToken,
      );
      if (!mounted) return;
      final content = ChatAudioContent(
        fileId: uploaded.fileId,
        durationMs: duration,
        size: uploaded.size,
        mimeType: uploaded.mimeType,
      );
      _attachReply(content);
      WKIM.shared.messageManager.sendMessage(
        content,
        WKChannel(widget.channelId, widget.channelType),
      );
      _mediaQueue.complete(mediaTask.id);
    } on DioException catch (error) {
      if (mounted && CancelToken.isCancel(error)) {
        if (mediaTask != null) _mediaQueue.complete(mediaTask.id);
        AppFeedback.show(context, '已取消上传，未发送');
      } else if (mounted) {
        if (mediaTask != null) {
          _mediaQueue.fail(
            mediaTask.id,
            '语音发送失败',
            retry: _toggleRecording,
            retryLabel: '重新录制',
          );
        }
        AppFeedback.error(
          context,
          error,
          fallback: '语音发送失败，请稍后重试',
          actionLabel: '重新录制',
          onAction: _toggleRecording,
        );
      }
    } catch (error) {
      if (mounted) {
        if (mediaTask != null) {
          _mediaQueue.fail(
            mediaTask.id,
            '语音发送失败',
            retry: _toggleRecording,
            retryLabel: '重新录制',
          );
        }
        AppFeedback.error(
          context,
          error,
          fallback: '语音发送失败，请稍后重试',
          actionLabel: '重新录制',
          onAction: _toggleRecording,
        );
      }
    } finally {
      if (path != null) {
        await File(path).delete().catchError((_) => File(path!));
      }
      _uploadCancelToken = null;
      if (mounted) {
        setState(() {
          _uploading = false;
          _voiceBusy = false;
        });
      }
    }
  }

  Future<void> _cancelRecording() async {
    if (_voiceBusy || !_recording) return;
    setState(() => _voiceBusy = true);
    try {
      if (await _recordingSession.cancel() && mounted) {
        _recordingTimer?.cancel();
        setState(() => _recording = false);
        AppFeedback.show(context, '已取消录音，未发送');
      }
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '取消录音失败，请重试');
    } finally {
      if (mounted) setState(() => _voiceBusy = false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _receiptTimer?.cancel();
    _mediaQueue
      ..removeListener(_refreshMediaTasks)
      ..cancelAll()
      ..dispose();
    _uploadCancelToken?.cancel('聊天页面已关闭');
    widget.imService.removeListener(_onHistorySync);
    WKIM.shared.messageManager.removeNewMsgListener(_listenerKey);
    WKIM.shared.messageManager.removeOnRefreshMsgListener(_listenerKey);
    _draftTimer?.cancel();
    _draftStore.write(
      _draftUid,
      widget.channelId,
      widget.channelType,
      _composer.text,
    );
    _composer.removeListener(_scheduleDraftSave);
    _composer.dispose();
    _composerFocus.dispose();
    _scrollController.dispose();
    _recordingTimer?.cancel();
    unawaited(_recordingSession.close().catchError((Object _) {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (widget.channelType == 1 &&
              (_capabilities.canAudioCall || _capabilities.canVideoCall))
            PopupMenuButton<bool>(
              tooltip: '发起通话',
              enabled: !_recording && !_voiceBusy,
              icon: const Icon(Icons.call_outlined),
              onSelected: (video) => _startCall(video: video),
              itemBuilder: (_) => [
                if (_capabilities.canAudioCall)
                  const PopupMenuItem(
                    value: false,
                    child: ListTile(
                      leading: Icon(Icons.call_outlined),
                      title: Text('语音通话'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (_capabilities.canVideoCall)
                  const PopupMenuItem(
                    value: true,
                    child: ListTile(
                      leading: Icon(Icons.videocam_outlined),
                      title: Text('视频通话'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          IconButton(
            tooltip: '搜索聊天记录',
            onPressed: _openSearch,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_connectionState != ImConnectionState.connected)
            ImConnectionBanner(
              state: _connectionState,
              onRetry: widget.imService.reconnect,
            ),
          if (!_capabilities.messaging)
            Material(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: const ListTile(
                dense: true,
                leading: Icon(Icons.visibility_outlined),
                title: Text('服务器已暂停消息服务'),
                subtitle: Text('你仍可查看和搜索已有聊天记录'),
              ),
            ),
          if (_messages.isNotEmpty &&
              (_loadingOlder ||
                  _olderLoadFailed ||
                  (_attemptedOlderLoad && !_hasOlderMessages)))
            SizedBox(
              height: 34,
              child: Center(
                child: _loadingOlder
                    ? const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox.square(
                            dimension: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 8),
                          Text('正在加载更早消息'),
                        ],
                      )
                    : _olderLoadFailed
                    ? TextButton(
                        onPressed: _loadOlderMessages,
                        child: const Text('更早消息加载失败，点击重试'),
                      )
                    : Text(
                        '已经是最早的消息',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
            ),
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.forum_outlined,
                            size: 52,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _capabilities.messaging ? '开始聊天' : '只读聊天记录',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _capabilities.canSendFiles
                                ? '发送第一条消息，或分享图片和文件'
                                : '发送第一条消息，开始对话',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, reverseIndex) {
                      final index = _messages.length - 1 - reverseIndex;
                      final message = _messages[index];
                      final mine = message.fromUID == WKIM.shared.options.uid;
                      final groupIncoming = widget.channelType == 2 && !mine;
                      final previous = index > 0 ? _messages[index - 1] : null;
                      final showSender =
                          groupIncoming &&
                          (previous == null ||
                              previous.fromUID != message.fromUID ||
                              message.timestamp - previous.timestamp > 300);
                      final senderName =
                          widget.memberNames[message.fromUID] ??
                          message.fromUID;
                      final showDate =
                          index == 0 ||
                          !_sameDay(
                            _messages[index - 1].timestamp,
                            message.timestamp,
                          );
                      return Column(
                        children: [
                          if (showDate)
                            _DateDivider(timestamp: message.timestamp),
                          if (message.messageContent
                              case ChatSystemContent notice)
                            _SystemNotice(
                              text: notice.displayText(),
                              time: _messageTime(message.timestamp),
                            )
                          else
                            Align(
                              alignment: mine
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (groupIncoming) ...[
                                    showSender
                                        ? _MessageAvatar(
                                            name: senderName,
                                            fileId:
                                                widget
                                                    .memberAvatarFileIds[message
                                                    .fromUID],
                                            fileTransferService:
                                                widget.fileTransferService,
                                          )
                                        : const SizedBox(width: 34),
                                    const SizedBox(width: 8),
                                  ],
                                  Semantics(
                                    onLongPress:
                                        _revokedClientMsgNos.contains(
                                          message.clientMsgNO,
                                        )
                                        ? null
                                        : () => _showMessageActions(
                                            message,
                                            mine,
                                          ),
                                    hint:
                                        _revokedClientMsgNos.contains(
                                          message.clientMsgNO,
                                        )
                                        ? null
                                        : '长按可回复、转发或查看更多操作',
                                    child: GestureDetector(
                                      onTap:
                                          message.messageContent
                                              is ChatCallRecordContent
                                          ? () => _confirmCall(
                                              video:
                                                  (message.messageContent
                                                          as ChatCallRecordContent)
                                                      .video,
                                            )
                                          : null,
                                      onLongPress:
                                          _revokedClientMsgNos.contains(
                                            message.clientMsgNO,
                                          )
                                          ? null
                                          : () => _showMessageActions(
                                              message,
                                              mine,
                                            ),
                                      child: Container(
                                        key: _messageKeys.putIfAbsent(
                                          message.clientMsgNO,
                                          GlobalKey.new,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 4,
                                        ),
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              MediaQuery.sizeOf(context).width *
                                              (groupIncoming ? 0.66 : 0.78),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              _highlightedClientMsgNo ==
                                                  message.clientMsgNO
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.tertiaryContainer
                                              : mine
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primaryContainer
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .surfaceContainerLowest,
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(18),
                                            topRight: const Radius.circular(18),
                                            bottomLeft: Radius.circular(
                                              mine ? 18 : 5,
                                            ),
                                            bottomRight: Radius.circular(
                                              mine ? 5 : 18,
                                            ),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child:
                                                  _revokedClientMsgNos.contains(
                                                    message.clientMsgNO,
                                                  )
                                                  ? const Text(
                                                      '消息已撤回',
                                                      style: TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    )
                                                  : Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        if (showSender) ...[
                                                          Text(
                                                            senderName,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .primary,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                        ],
                                                        if (message
                                                                .messageContent
                                                                ?.reply !=
                                                            null)
                                                          _ReplyQuote(
                                                            reply: message
                                                                .messageContent!
                                                                .reply!,
                                                          ),
                                                        _MessageBody(
                                                          content: message
                                                              .messageContent,
                                                          fileTransferService:
                                                              widget
                                                                  .fileTransferService,
                                                        ),
                                                        MessageMeta(
                                                          time: _messageTime(
                                                            message.timestamp,
                                                          ),
                                                          status: mine
                                                              ? _SendStatus(
                                                                  status: message
                                                                      .status,
                                                                  onRetry:
                                                                      message.status ==
                                                                          WKSendMsgResult
                                                                              .sendFail
                                                                      ? () {
                                                                          _retryMessage(
                                                                            message,
                                                                          );
                                                                        }
                                                                      : null,
                                                                )
                                                              : null,
                                                          receipt:
                                                              mine &&
                                                                  _receipts[message
                                                                          .messageID] !=
                                                                      null
                                                              ? (widget.channelType ==
                                                                        1
                                                                    ? (_receipts[message.messageID]!.readCount >
                                                                              0
                                                                          ? '已读'
                                                                          : '未读')
                                                                    : '${_receipts[message.messageID]!.readCount}人已读')
                                                              : null,
                                                          read:
                                                              (_receipts[message
                                                                          .messageID]
                                                                      ?.readCount ??
                                                                  0) >
                                                              0,
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),
          if (_replyingTo != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              padding: const EdgeInsets.fromLTRB(12, 7, 4, 7),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 34,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _replyingTo!.fromUID == WKIM.shared.options.uid
                              ? '回复 我'
                              : '回复 ${widget.channelType == 1 ? widget.title : widget.memberNames[_replyingTo!.fromUID] ?? '群成员'}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _replyingTo!.messageContent?.displayText() ?? '[消息]',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: '取消回复',
                    onPressed: () => setState(() => _replyingTo = null),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
          SafeArea(
            top: false,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(8, 8, 6, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: '更多功能',
                    onPressed:
                        ((!_capabilities.canSendFiles &&
                                !(widget.channelType == 1 &&
                                    (_capabilities.canAudioCall ||
                                        _capabilities.canVideoCall))) ||
                            _recording ||
                            _voiceBusy)
                        ? null
                        : _showAttachments,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  IconButton(
                    tooltip: _voiceMode ? '切换到文字输入' : '切换到语音消息',
                    onPressed:
                        !_capabilities.messaging ||
                            !_capabilities.canSendFiles ||
                            _uploading ||
                            _mediaQueue.hasActive ||
                            _recording ||
                            _voiceBusy
                        ? null
                        : _toggleComposerMode,
                    icon: Icon(
                      _voiceMode
                          ? Icons.keyboard_alt_outlined
                          : Icons.mic_none_outlined,
                    ),
                  ),
                  Expanded(
                    child: _voiceMode
                        ? SizedBox(
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed:
                                  !_capabilities.canSendFiles ||
                                      _voiceBusy ||
                                      _uploading ||
                                      _mediaQueue.hasActive
                                  ? null
                                  : _toggleRecording,
                              icon: Icon(
                                _recording
                                    ? Icons.graphic_eq
                                    : Icons.mic_none_outlined,
                              ),
                              label: Text(
                                _recording
                                    ? '正在录音 ${_recordingSeconds}s'
                                    : '点击开始录音',
                              ),
                            ),
                          )
                        : ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _composer,
                            builder: (context, value, _) => Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextField(
                                  enabled: _capabilities.messaging,
                                  controller: _composer,
                                  focusNode: _composerFocus,
                                  minLines: 1,
                                  maxLines: 4,
                                  inputFormatters: const [
                                    Utf16LengthLimitingTextInputFormatter(
                                      10000,
                                    ),
                                  ],
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (_) => _send(),
                                  onTap: () {
                                    if (_showEmojiPanel) {
                                      setState(() => _showEmojiPanel = false);
                                    }
                                  },
                                  decoration: ChatStyles.composer(
                                    Theme.of(context).colorScheme,
                                    hintText:
                                        _connectionState ==
                                            ImConnectionState.connected
                                        ? '输入消息'
                                        : '连接恢复后可发送',
                                  ),
                                ),
                                if (value.text.length >= 9000)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2,
                                      right: 4,
                                    ),
                                    child: Text(
                                      '${value.text.length}/10000',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                  ),
                  if (!_voiceMode) ...[
                    IconButton(
                      tooltip: _showEmojiPanel ? '显示键盘' : '表情',
                      onPressed: _capabilities.messaging
                          ? _toggleEmojiPanel
                          : null,
                      icon: Icon(
                        _showEmojiPanel
                            ? Icons.keyboard_alt_outlined
                            : Icons.sentiment_satisfied_alt_outlined,
                      ),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _composer,
                      builder: (context, value, _) => IconButton.filled(
                        tooltip: '发送',
                        onPressed:
                            _capabilities.messaging &&
                                value.text.trim().isNotEmpty
                            ? _send
                            : null,
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_uploading && _mediaQueue.tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TransferProgressPanel(
                label: _uploadLabel,
                progress: _uploadProgress,
                onCancel: _uploadCancelToken == null
                    ? null
                    : () {
                        _uploadCancelToken?.cancel('用户取消上传');
                      },
              ),
            ),
          if (_mediaQueue.tasks.isNotEmpty)
            ListenableBuilder(
              listenable: _mediaQueue,
              builder: (context, _) => Column(
                children: [
                  for (final task in _mediaQueue.tasks)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: TransferProgressPanel(
                        label: task.label,
                        progress: task.progress,
                        error: task.error,
                        onRetry: task.retry == null
                            ? null
                            : () => _mediaQueue.retry(task.id),
                        retryLabel: task.retryLabel ?? '重试',
                        onCancel: () => _mediaQueue.cancel(task.id),
                      ),
                    ),
                ],
              ),
            ),
          if (_recording)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.fiber_manual_record,
                    size: 16,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text('正在录音 ${_recordingSeconds}s')),
                  TextButton(
                    onPressed: _voiceBusy ? null : _cancelRecording,
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: _voiceBusy ? null : _stopAndSendVoice,
                    child: Text(_voiceBusy ? '处理中…' : '发送'),
                  ),
                ],
              ),
            ),
          if (_showEmojiPanel)
            SafeArea(
              top: false,
              child: SizedBox(
                height: 260,
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: _emojis.length,
                  itemBuilder: (context, index) => InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _insertEmoji(_emojis[index]),
                    child: Center(
                      child: Text(
                        _emojis[index],
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _messageTime(int timestamp) {
    if (timestamp <= 0) return '';
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(time.hour)}:${two(time.minute)}';
  }

  bool _sameDay(int first, int second) {
    if (first <= 0 || second <= 0) return true;
    final a = DateTime.fromMillisecondsSinceEpoch(first * 1000);
    final b = DateTime.fromMillisecondsSinceEpoch(second * 1000);
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _ImageSendPreview extends StatefulWidget {
  const _ImageSendPreview({
    required this.name,
    required this.bytes,
    required this.canCompress,
  });

  final String name;
  final Uint8List bytes;
  final bool canCompress;

  @override
  State<_ImageSendPreview> createState() => _ImageSendPreviewState();
}

class _ImageSendPreviewState extends State<_ImageSendPreview> {
  late bool _compress = widget.canCompress;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          0,
          16,
          16 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('发送图片', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ColoredBox(
                  color: colors.surfaceContainerHighest,
                  child: Image.memory(
                    widget.bytes,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const SizedBox(
                      height: 180,
                      child: Center(child: Icon(Icons.broken_image_outlined)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Text(
              formatFileSize(widget.bytes.length),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('压缩发送'),
              subtitle: Text(
                widget.canCompress
                    ? '最长边 2048 像素，节省流量；关闭可发送原图'
                    : '此格式将按原图发送，避免画质或动图损失',
              ),
              value: _compress,
              onChanged: widget.canCompress
                  ? (value) => setState(() => _compress = value)
                  : null,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('取消'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => Navigator.pop(context, _compress),
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text(_compress ? '压缩并发送' : '发送原图'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentAction extends StatelessWidget {
  const _AttachmentAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label.contains('通话') ? '发起$label' : '发送$label',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

class _MessageAvatar extends StatelessWidget {
  const _MessageAvatar({
    required this.name,
    required this.fileId,
    required this.fileTransferService,
  });

  final String name;
  final String? fileId;
  final FileTransferService fileTransferService;

  @override
  Widget build(BuildContext context) => AppAvatar(
    name: name,
    fileId: fileId,
    size: 34,
    resolveUrl: fileTransferService.downloadUrl,
    resolveFile: fileTransferService.downloadAvatar,
  );
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.timestamp});

  final int timestamp;

  @override
  Widget build(BuildContext context) {
    if (timestamp <= 0) return const SizedBox(height: 8);
    final value = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(value.year, value.month, value.day);
    final difference = today.difference(date).inDays;
    final label = difference == 0
        ? '今天'
        : difference == 1
        ? '昨天'
        : value.year == now.year
        ? '${value.month}月${value.day}日'
        : '${value.year}年${value.month}月${value.day}日';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}

class _ChatSearchPage extends StatefulWidget {
  const _ChatSearchPage({required this.channelId, required this.channelType});

  final String channelId;
  final int channelType;

  @override
  State<_ChatSearchPage> createState() => _ChatSearchPageState();
}

class _ChatSearchPageState extends State<_ChatSearchPage> {
  final _query = TextEditingController();
  Timer? _debounce;
  List<WKMsg> _results = const [];
  bool _loading = false;
  Object? _error;
  int _searchGeneration = 0;

  void _scheduleSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _search(value));
  }

  Future<void> _search(String rawQuery) async {
    final keyword = rawQuery.trim();
    final generation = ++_searchGeneration;
    if (keyword.isEmpty) {
      if (mounted) {
        setState(() {
          _results = const [];
          _loading = false;
          _error = null;
        });
      }
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final messages = await WKIM.shared.messageManager.searchWithChannel(
        keyword,
        widget.channelId,
        widget.channelType,
      );
      messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      if (mounted && generation == _searchGeneration) {
        setState(() => _results = messages);
      }
    } catch (error) {
      if (mounted && generation == _searchGeneration) {
        setState(() => _error = error);
      }
    } finally {
      if (mounted && generation == _searchGeneration) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyword = _query.text.trim();
    return Scaffold(
      appBar: AppBar(title: const Text('搜索聊天记录')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _query,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: (value) {
                setState(() {});
                _scheduleSearch(value);
              },
              onSubmitted: _search,
              decoration: InputDecoration(
                hintText: '输入消息内容或文件名',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: keyword.isEmpty
                    ? null
                    : IconButton(
                        tooltip: '清空',
                        onPressed: () {
                          _query.clear();
                          _debounce?.cancel();
                          _searchGeneration++;
                          setState(() {
                            _results = const [];
                            _error = null;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
          if (_loading)
            Semantics(
              liveRegion: true,
              label: '正在搜索聊天记录',
              child: const LinearProgressIndicator(),
            ),
          Expanded(child: _buildResults(keyword)),
        ],
      ),
    );
  }

  Widget _buildResults(String keyword) {
    if (_error != null) {
      return AppStatus(
        icon: Icons.cloud_off_outlined,
        title: '搜索失败',
        message: '无法读取当前设备的聊天记录，请稍后重试',
        onRetry: () => _search(keyword),
      );
    }
    if (keyword.isEmpty) {
      return const AppStatus(
        icon: Icons.manage_search_outlined,
        title: '搜索聊天记录',
        message: '可搜索当前设备已同步的消息内容和文件名',
      );
    }
    if (!_loading && _results.isEmpty) {
      return const AppStatus(
        icon: Icons.search_off_outlined,
        title: '没有找到相关消息',
        message: '请尝试更短的关键词或检查输入内容',
      );
    }
    return ListView.separated(
      itemCount: _results.length,
      separatorBuilder: (_, _) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final message = _results[index];
        final text = message.messageContent?.displayText() ?? '[消息]';
        return ListTile(
          leading: CircleAvatar(
            child: Icon(
              message.fromUID == WKIM.shared.options.uid
                  ? Icons.person
                  : Icons.person_outline,
            ),
          ),
          title: _HighlightedText(text: text, keyword: keyword),
          subtitle: Text(_formatSearchTime(message.timestamp)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.pop(context, message),
        );
      },
    );
  }

  String _formatSearchTime(int seconds) {
    final time = DateTime.fromMillisecondsSinceEpoch(seconds * 1000).toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    return '${time.year}-${two(time.month)}-${two(time.day)} '
        '${two(time.hour)}:${two(time.minute)}';
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({required this.text, required this.keyword});

  final String text;
  final String keyword;

  @override
  Widget build(BuildContext context) {
    final lowerText = text.toLowerCase();
    final lowerKeyword = keyword.toLowerCase();
    final spans = <TextSpan>[];
    var offset = 0;
    while (lowerKeyword.isNotEmpty) {
      final index = lowerText.indexOf(lowerKeyword, offset);
      if (index < 0) break;
      if (index > offset) {
        spans.add(TextSpan(text: text.substring(offset, index)));
      }
      spans.add(
        TextSpan(
          text: text.substring(index, index + keyword.length),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      offset = index + keyword.length;
    }
    if (offset < text.length) spans.add(TextSpan(text: text.substring(offset)));
    return Text.rich(
      TextSpan(children: spans),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.content,
    required this.fileTransferService,
  });

  final dynamic content;
  final FileTransferService fileTransferService;

  static final MessageRendererRegistry<FileTransferService> _renderers =
      MessageRendererRegistry<FileTransferService>(
        renderers: [
          TypedMessageRenderer<ChatImageContent, FileTransferService>(
            (_, image, files) =>
                _ImageMessage(content: image, fileTransferService: files),
          ),
          TypedMessageRenderer<ChatFileContent, FileTransferService>(
            (_, file, files) =>
                _FileMessage(content: file, fileTransferService: files),
          ),
          TypedMessageRenderer<ChatVideoContent, FileTransferService>(
            (_, video, files) =>
                _VideoMessage(content: video, fileTransferService: files),
          ),
          TypedMessageRenderer<ChatAudioContent, FileTransferService>(
            (_, audio, files) =>
                _AudioMessage(content: audio, fileTransferService: files),
          ),
          TypedMessageRenderer<ChatCallRecordContent, FileTransferService>(
            (_, call, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  call.video ? Icons.videocam_outlined : Icons.call_outlined,
                ),
                const SizedBox(width: 8),
                Flexible(child: Text(call.displayText())),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, size: 18),
              ],
            ),
          ),
          TypedMessageRenderer<WKTextContent, FileTransferService>(
            (_, text, _) => MessageText(text: text.content),
          ),
        ],
        fallback: (_, content, _) =>
            Text(content == null ? '[消息]' : _displayMessageContent(content)),
      );

  @override
  Widget build(BuildContext context) =>
      _renderers.build(context, content, fileTransferService);
}

String _displayMessageContent(Object content) {
  try {
    return (content as dynamic).displayText() as String;
  } catch (_) {
    return '[暂不支持的消息]';
  }
}

class _ImageMessage extends StatefulWidget {
  const _ImageMessage({
    required this.content,
    required this.fileTransferService,
  });

  final ChatImageContent content;
  final FileTransferService fileTransferService;

  @override
  State<_ImageMessage> createState() => _ImageMessageState();
}

class _ImageMessageState extends State<_ImageMessage> {
  late Future<File> _displayFile;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final thumbnailFileId = widget.content.thumbnailFileId;
    _displayFile = widget.fileTransferService.download(
      fileId: thumbnailFileId.isEmpty ? widget.content.fileId : thumbnailFileId,
      fileName: thumbnailFileId.isEmpty
          ? 'chat_image_original'
          : 'chat_image_thumbnail.jpg',
      expectedSize: thumbnailFileId.isEmpty
          ? widget.content.size
          : widget.content.thumbnailSize,
      priority: DownloadPriority.background,
    );
  }

  Future<void> _openPreview() async {
    try {
      final displayed = await _displayFile;
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => _ImagePreviewPage(
            file: displayed,
            loadOriginal: widget.content.thumbnailFileId.isEmpty
                ? null
                : () => widget.fileTransferService.download(
                    fileId: widget.content.fileId,
                    fileName: 'chat_image_original',
                    expectedSize: widget.content.size,
                  ),
          ),
        ),
      );
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '图片预览失败，请稍后重试');
    }
  }

  @override
  Widget build(BuildContext context) => ChatMediaFrame(
    width: widget.content.width,
    height: widget.content.height,
    child: FutureBuilder<File>(
      future: _displayFile,
      builder: (context, snapshot) =>
          _buildCachedImage(file: snapshot.data, error: snapshot.hasError),
    ),
  );

  Widget _loadingOrRetry(bool error) => error
      ? SizedBox(
          width: 180,
          height: 110,
          child: TextButton.icon(
            onPressed: () => setState(_load),
            icon: const Icon(Icons.refresh),
            label: const Text('图片加载失败，重试'),
          ),
        )
      : const SizedBox(
          width: 180,
          height: 120,
          child: Center(child: CircularProgressIndicator()),
        );

  Widget _buildCachedImage({required File? file, required bool error}) {
    if (file == null) return _loadingOrRetry(error);
    final decodeWidth = (220 * MediaQuery.devicePixelRatioOf(context))
        .ceil()
        .clamp(220, 960);
    return InkWell(
      onTap: _openPreview,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          file,
          key: ValueKey(
            'message-image-${widget.content.thumbnailFileId.isEmpty ? widget.content.fileId : widget.content.thumbnailFileId}',
          ),
          width: 220,
          height: 180,
          cacheWidth: decodeWidth,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => _loadingOrRetry(true),
        ),
      ),
    );
  }
}

class _ImagePreviewPage extends StatefulWidget {
  const _ImagePreviewPage({this.endpoint, this.file, this.loadOriginal})
    : assert(endpoint != null || file != null);

  final ResolvedUrl? endpoint;
  final File? file;
  final Future<File> Function()? loadOriginal;

  @override
  State<_ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<_ImagePreviewPage> {
  late File? _file = widget.file;
  bool _loadingOriginal = false;
  bool _showingOriginal = false;

  Future<void> _showOriginal() async {
    final load = widget.loadOriginal;
    if (load == null || _loadingOriginal) return;
    setState(() => _loadingOriginal = true);
    try {
      final file = await load();
      if (mounted) {
        setState(() {
          _file = file;
          _showingOriginal = true;
        });
      }
    } catch (error) {
      if (mounted) AppFeedback.error(context, error, fallback: '原图加载失败，请稍后重试');
    } finally {
      if (mounted) setState(() => _loadingOriginal = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      title: const Text('图片预览'),
      actions: [
        if (widget.loadOriginal != null)
          TextButton(
            onPressed: _loadingOriginal || _showingOriginal
                ? null
                : _showOriginal,
            child: _loadingOriginal
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_showingOriginal ? '已显示原图' : '查看原图'),
          ),
      ],
    ),
    body: Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5,
        child: _file != null
            ? Image.file(
                _file!,
                key: ValueKey(_file!.path),
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) =>
                    const Text('图片加载失败', style: TextStyle(color: Colors.white)),
              )
            : Image.network(
                widget.endpoint!.url,
                headers: widget.endpoint!.headers,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                errorBuilder: (_, _, _) =>
                    const Text('图片加载失败', style: TextStyle(color: Colors.white)),
              ),
      ),
    ),
  );
}

class _FileMessage extends StatefulWidget {
  const _FileMessage({
    required this.content,
    required this.fileTransferService,
  });

  final ChatFileContent content;
  final FileTransferService fileTransferService;

  @override
  State<_FileMessage> createState() => _FileMessageState();
}

class _FileMessageState extends State<_FileMessage>
    with AutomaticKeepAliveClientMixin<_FileMessage> {
  bool _downloading = false;
  double _progress = 0;
  CancelToken? _downloadCancelToken;

  Future<void> _downloadAndOpen() async {
    if (_downloading) return;
    setState(() {
      _downloading = true;
      _progress = 0;
    });
    updateKeepAlive();
    final cancelToken = CancelToken();
    _downloadCancelToken = cancelToken;
    try {
      final file = await widget.fileTransferService.download(
        fileId: widget.content.fileId,
        fileName: widget.content.name,
        expectedSize: widget.content.size,
        onProgress: (received, total) {
          if (mounted && total > 0) {
            setState(() => _progress = received / total);
          }
        },
        cancelToken: cancelToken,
      );
      await FileOpenService.open(file.path);
    } on DioException catch (error) {
      if (mounted && CancelToken.isCancel(error)) {
        AppFeedback.show(context, '已取消下载');
      } else if (mounted) {
        AppFeedback.error(context, error, fallback: '文件打开失败，请稍后重试');
      }
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '文件打开失败，请稍后重试');
      }
    } finally {
      if (identical(_downloadCancelToken, cancelToken)) {
        _downloadCancelToken = null;
      }
      if (mounted) {
        setState(() => _downloading = false);
        updateKeepAlive();
      }
    }
  }

  @override
  void dispose() {
    _downloadCancelToken?.cancel('文件消息已离开屏幕');
    super.dispose();
  }

  @override
  bool get wantKeepAlive => _downloading;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FileMessageTile(
      name: widget.content.name,
      sizeLabel: formatFileSize(widget.content.size),
      downloading: _downloading,
      progress: _progress,
      onOpen: _downloadAndOpen,
      onCancel: () => _downloadCancelToken?.cancel('用户取消下载'),
    );
  }
}

class _VideoMessage extends StatefulWidget {
  const _VideoMessage({
    required this.content,
    required this.fileTransferService,
  });

  final ChatVideoContent content;
  final FileTransferService fileTransferService;

  @override
  State<_VideoMessage> createState() => _VideoMessageState();
}

class _VideoMessageState extends State<_VideoMessage> {
  VideoPlayerController? _controller;
  ResolvedUrl? _endpoint;
  Future<File>? _poster;
  Object? _error;
  bool _requested = false;
  bool? _lastPlaying;
  int _lastPositionSecond = -1;

  @override
  void initState() {
    super.initState();
    if (widget.content.thumbnailFileId.isNotEmpty) {
      _poster = widget.fileTransferService.download(
        fileId: widget.content.thumbnailFileId,
        fileName: 'video_cover.jpg',
        priority: DownloadPriority.background,
      );
    }
  }

  Future<void> _initialize() async {
    if (_requested) return;
    setState(() {
      _requested = true;
      _error = null;
    });
    try {
      final endpoint = await widget.fileTransferService.downloadUrl(
        widget.content.fileId,
      );
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(endpoint.url),
        httpHeaders: endpoint.headers,
      );
      await controller.initialize();
      controller.addListener(_refresh);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _endpoint = endpoint;
        _controller = controller;
        _error = null;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error);
    }
  }

  void _refresh() {
    if (!mounted) return;
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying && _isOutsideViewport()) {
      unawaited(controller.pause());
      return;
    }
    final playing = controller.value.isPlaying;
    final second = controller.value.position.inSeconds;
    if (_lastPlaying == playing && _lastPositionSecond == second) return;
    _lastPlaying = playing;
    _lastPositionSecond = second;
    setState(() {});
  }

  bool _isOutsideViewport() {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached) return false;
    final top = renderObject.localToGlobal(Offset.zero).dy;
    final bottom = top + renderObject.size.height;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    return bottom <= 0 || top >= viewportHeight;
  }

  Future<void> _retry() async {
    final old = _controller;
    old?.removeListener(_refresh);
    await old?.dispose();
    setState(() {
      _controller = null;
      _error = null;
      _requested = false;
    });
    await _initialize();
  }

  void _toggle() {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      if (controller.value.position >= controller.value.duration) {
        controller.seekTo(Duration.zero);
      }
      controller.play();
    }
  }

  Future<void> _fullScreen() async {
    final endpoint = _endpoint;
    if (endpoint == null) return;
    await _controller?.pause();
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _FullScreenVideoPage(endpoint: endpoint),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_refresh);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return SizedBox(
        width: 220,
        height: 130,
        child: TextButton.icon(
          onPressed: _retry,
          icon: const Icon(Icons.refresh),
          label: const Text('视频加载失败，重试'),
        ),
      );
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      final aspect = widget.content.width > 0 && widget.content.height > 0
          ? widget.content.width / widget.content.height
          : 16 / 9;
      return SizedBox(
        width: 230,
        child: AspectRatio(
          aspectRatio: aspect.clamp(.55, 2.0),
          child: Material(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: _requested ? null : _initialize,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (_poster != null)
                    FutureBuilder<File>(
                      future: _poster,
                      builder: (context, snapshot) => snapshot.data == null
                          ? const SizedBox.shrink()
                          : Image.file(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              cacheWidth:
                                  (230 * MediaQuery.devicePixelRatioOf(context))
                                      .ceil()
                                      .clamp(230, 960),
                            ),
                    ),
                  Center(
                    child: _requested
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 56,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final aspect = controller.value.aspectRatio > 0
        ? controller.value.aspectRatio
        : 16 / 9;
    return SizedBox(
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: aspect,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoPlayer(controller),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _toggle,
                      child: Center(
                        child: Icon(
                          controller.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                          color: Colors.white,
                          size: 54,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: IconButton.filledTonal(
                      tooltip: '全屏播放',
                      onPressed: _fullScreen,
                      icon: const Icon(Icons.fullscreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
          VideoProgressIndicator(controller, allowScrubbing: true),
          Text(
            '${_formatDuration(controller.value.duration)} · ${formatFileSize(widget.content.size)}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _FullScreenVideoPage extends StatefulWidget {
  const _FullScreenVideoPage({required this.endpoint});

  final ResolvedUrl endpoint;

  @override
  State<_FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<_FullScreenVideoPage> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  bool _initializing = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.endpoint.url),
      httpHeaders: widget.endpoint.headers,
    )..addListener(_refresh);
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    if (_initializing) return;
    setState(() {
      _initializing = true;
      _ready = false;
      _error = null;
    });
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() => _ready = true);
      await _controller.play();
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  void _togglePlayback() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      title: const Text('视频播放'),
    ),
    body: _error != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.videocam_off_outlined,
                    color: Colors.white70,
                    size: 54,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    '视频加载失败',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '请检查网络后重试',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: _initializing ? null : _initialize,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('重试'),
                  ),
                ],
              ),
            ),
          )
        : !_ready
        ? Center(
            child: Semantics(
              liveRegion: true,
              label: '正在加载视频',
              child: const CircularProgressIndicator(),
            ),
          )
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Semantics(
                    button: true,
                    label: _controller.value.isPlaying ? '暂停视频' : '播放视频',
                    onTap: _togglePlayback,
                    child: GestureDetector(
                      onTap: _togglePlayback,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                IconButton.filled(
                  tooltip: _controller.value.isPlaying ? '暂停视频' : '播放视频',
                  onPressed: _togglePlayback,
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),
              ],
            ),
          ),
  );
}

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds.remainder(60);
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

class _SystemNotice extends StatelessWidget {
  const _SystemNotice({required this.text, required this.time});

  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Semantics(
      label: '$text，$time',
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            '$text  $time',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}

class _ReplyQuote extends StatelessWidget {
  const _ReplyQuote({required this.reply});

  final WKReply reply;

  @override
  Widget build(BuildContext context) {
    final summary = reply.revoke == 1
        ? '原消息已撤回'
        : reply.payload?.displayText() ?? '[消息]';
    return Container(
      constraints: const BoxConstraints(maxWidth: 230),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.65),
        border: Border(
          left: BorderSide(
            width: 3,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            reply.fromName.isEmpty ? reply.fromUID : reply.fromName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          Text(
            summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AudioMessage extends StatefulWidget {
  const _AudioMessage({
    required this.content,
    required this.fileTransferService,
  });

  final ChatAudioContent content;
  final FileTransferService fileTransferService;

  @override
  State<_AudioMessage> createState() => _AudioMessageState();
}

class _AudioMessageState extends State<_AudioMessage> {
  final _player = AudioPlayer();
  bool _loading = false;

  Future<void> _toggle() async {
    if (_loading) return;
    try {
      if (_player.playing &&
          _player.processingState != ProcessingState.completed) {
        await _player.pause();
        return;
      }
      setState(() => _loading = true);
      if (_player.audioSource == null) {
        final file = await widget.fileTransferService.download(
          fileId: widget.content.fileId,
          fileName: 'voice_message.m4a',
          expectedSize: widget.content.size,
        );
        if (!mounted) return;
        await _player.setFilePath(file.path);
      } else if (_player.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }
      if (!mounted) return;
      // play() completes only when playback stops, not when it starts.
      // Unlock the control now so the user can pause during playback.
      setState(() => _loading = false);
      await _player.play();
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '播放失败，请稍后重试');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playing =
            (snapshot.data?.playing ?? false) &&
            snapshot.data?.processingState != ProcessingState.completed;
        return Tooltip(
          message: _loading
              ? '加载语音'
              : playing
              ? '暂停语音'
              : '播放语音',
          child: InkWell(
            key: ValueKey('voice-${widget.content.fileId}'),
            onTap: _loading ? null : _toggle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_loading)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(playing ? Icons.pause_circle : Icons.play_circle),
                const SizedBox(width: 8),
                Text('${(widget.content.durationMs / 1000).ceil()}″'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SendStatus extends StatelessWidget {
  const _SendStatus({required this.status, this.onRetry});

  final int status;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final (icon, color, label) = switch (status) {
      WKSendMsgResult.sendSuccess => (Icons.check, Colors.green, '已发送'),
      WKSendMsgResult.sendFail ||
      WKSendMsgResult.noRelation ||
      WKSendMsgResult.blackList ||
      WKSendMsgResult.notOnWhiteList => (
        Icons.error_outline,
        Theme.of(context).colorScheme.error,
        '发送失败',
      ),
      _ => (Icons.schedule, Theme.of(context).colorScheme.outline, '发送中'),
    };
    final failed = label == '发送失败';
    final content = Semantics(
      label: onRetry == null ? label : '$label，双击重试',
      button: onRetry != null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          if (failed) ...[
            const SizedBox(width: 3),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ],
      ),
    );
    if (onRetry == null) return Tooltip(message: label, child: content);
    return Tooltip(
      message: '发送失败，点击重试',
      child: InkWell(
        onTap: onRetry,
        borderRadius: BorderRadius.circular(12),
        child: Padding(padding: const EdgeInsets.all(3), child: content),
      ),
    );
  }
}
