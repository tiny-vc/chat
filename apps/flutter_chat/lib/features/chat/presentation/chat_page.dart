import 'dart:async';
import '../../../core/theme/chat_styles.dart';
import 'message_details.dart';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:open_filex/open_filex.dart';
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
import '../../../core/im/conversation_draft_store.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/calls/call_service.dart';
import '../../../core/im/chat_message_content.dart';
import '../../calls/presentation/call_page.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/im/recording_session.dart';
import 'composer_action_button.dart';

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
  });

  final String channelId;
  final int channelType;
  final String title;
  final ImService imService;
  final FileTransferService fileTransferService;
  final List<ForwardTarget> forwardTargets;
  final CallService callService;
  final Map<String, String> memberNames;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
  bool _voiceBusy = false;
  bool _uploading = false;
  double _uploadProgress = 0;
  bool _recording = false;
  DateTime? _recordingStartedAt;
  Timer? _recordingTimer;
  int _recordingSeconds = 0;
  bool _showEmojiPanel = false;
  WKMsg? _replyingTo;
  String? _highlightedClientMsgNo;
  Timer? _highlightTimer;
  Timer? _receiptTimer;
  Timer? _draftTimer;
  bool _loadingReceipts = false;
  int _historyRevision = 0;

  String get _draftUid => WKIM.shared.options.uid ?? 'unknown-user';

  @override
  void initState() {
    super.initState();
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
    widget.imService.addListener(_onHistorySync);
    _loadDraft();
    _composer.addListener(_scheduleDraftSave);
    widget.imService.markRead(widget.channelId, widget.channelType);
    _receiptTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _refreshReceipts(),
    );
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
    if (revision == _historyRevision) return;
    _historyRevision = revision;
    _loadMessages();
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
      (List<WKMsg> messages) => _replaceMessages(messages),
      () {},
    );
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
      final index = _messages.indexWhere(
        (item) => item.clientMsgNO == message.clientMsgNO,
      );
      if (index == -1) {
        _messages.add(message);
      } else {
        _messages[index] = message;
      }
      _messages.sort((a, b) => a.orderSeq.compareTo(b.orderSeq));
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
        setState(() {
          for (final receipt in receipts) {
            _receipts[receipt.messageId] = receipt;
          }
        });
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
    try {
      final call = await widget.callService.create(
        widget.channelId,
        video: video,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CallPage(
            callId: call.id,
            title: widget.title,
            video: video,
            incoming: false,
            callService: widget.callService,
            imService: widget.imService,
          ),
        ),
      );
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '无法发起通话，请稍后重试');
      }
    }
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
          duration: const Duration(milliseconds: 320),
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
    final original = _replyingTo;
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
    setState(() => _replyingTo = null);
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
    final canRevoke =
        mine &&
        message.messageID.isNotEmpty &&
        message.timestamp > 0 &&
        DateTime.now().millisecondsSinceEpoch ~/ 1000 - message.timestamp <=
            120;
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.forward_outlined),
              title: const Text('转发'),
              onTap: () => Navigator.pop(context, 'forward'),
            ),
            if (message.messageID.isNotEmpty)
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
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('从本机删除'),
              subtitle: const Text('只删除当前设备上的记录'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
            if (canRevoke)
              ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('撤回'),
                subtitle: const Text('发送后 2 分钟内可撤回'),
                onTap: () => Navigator.pop(context, 'revoke'),
              ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    try {
      switch (action) {
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

  Future<void> _forwardMessage(WKMsg message) async {
    final targets = widget.forwardTargets
        .where(
          (target) =>
              target.channelId != widget.channelId ||
              target.channelType != widget.channelType,
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
    final source = message.messageContent;
    if (source == null) throw StateError('无法转发此消息');
    final WKMessageContent forwarded;
    if (source case WKTextContent text) {
      forwarded = WKTextContent(text.content);
    } else if (source case ChatImageContent image) {
      forwarded = ChatImageContent(
        fileId: await widget.fileTransferService.forwardFile(
          fileId: image.fileId,
          channelId: target.channelId,
          channelType: target.channelType,
        ),
        width: image.width,
        height: image.height,
      );
    } else if (source case ChatVideoContent video) {
      forwarded = ChatVideoContent(
        fileId: await widget.fileTransferService.forwardFile(
          fileId: video.fileId,
          channelId: target.channelId,
          channelType: target.channelType,
        ),
        name: video.name,
        size: video.size,
        durationMs: video.durationMs,
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
    final file = await FilePicker.pickFile(
      type: image ? FileType.image : FileType.any,
    );
    if (file == null || !mounted) return;
    setState(() {
      _uploading = true;
      _uploadProgress = 0;
    });
    try {
      var width = 0;
      var height = 0;
      if (image) {
        final dimensions = await _imageDimensions(await file.readAsBytes());
        width = dimensions.$1;
        height = dimensions.$2;
      }
      final uploaded = await widget.fileTransferService.upload(
        file: file,
        channelId: widget.channelId,
        channelType: widget.channelType,
        image: image,
        onProgress: (sent, total) {
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
      );
      final content = image
          ? ChatImageContent(
              fileId: uploaded.fileId,
              width: width,
              height: height,
            )
          : ChatFileContent(
              fileId: uploaded.fileId,
              name: uploaded.name,
              size: uploaded.size,
              mimeType: uploaded.mimeType,
            );
      _attachReply(content);
      WKIM.shared.messageManager.sendMessage(
        content,
        WKChannel(widget.channelId, widget.channelType),
      );
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '发送失败，请稍后重试');
      }
    } finally {
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
    final file = await FilePicker.pickFile(type: FileType.video);
    if (file == null || !mounted) return;
    setState(() {
      _uploading = true;
      _uploadProgress = 0;
    });
    VideoPlayerController? metadataController;
    try {
      var durationMs = 0;
      if (file.path case final path?) {
        metadataController = VideoPlayerController.file(File(path));
        await metadataController.initialize();
        durationMs = metadataController.value.duration.inMilliseconds;
      }
      final uploaded = await widget.fileTransferService.uploadVideo(
        file: file,
        channelId: widget.channelId,
        channelType: widget.channelType,
        onProgress: (sent, total) {
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
      );
      final content = ChatVideoContent(
        fileId: uploaded.fileId,
        name: uploaded.name,
        size: uploaded.size,
        durationMs: durationMs,
      );
      _attachReply(content);
      WKIM.shared.messageManager.sendMessage(
        content,
        WKChannel(widget.channelId, widget.channelType),
      );
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '视频发送失败，请稍后重试');
      }
    } finally {
      await metadataController?.dispose();
      if (mounted) setState(() => _uploading = false);
    }
  }

  void _showAttachments() {
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
              Text('发送内容', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 18),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (_voiceBusy || _uploading || !mounted) return;
    if (_recording) {
      await _stopAndSendVoice();
      return;
    }
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
    try {
      path = await _recordingSession.stop();
      _recordingTimer?.cancel();
      final duration = DateTime.now()
          .difference(_recordingStartedAt!)
          .inMilliseconds;
      if (!mounted) return;
      if (mounted) {
        setState(() {
          _recording = false;
          _uploading = true;
          _uploadProgress = 0;
        });
      }
      if (path == null || duration < 500) {
        if (mounted) {
          setState(() => _uploading = false);
          AppFeedback.show(context, '录音时间太短，请录制至少半秒');
        }
        return;
      }
      final uploaded = await widget.fileTransferService.uploadVoice(
        path: path,
        channelId: widget.channelId,
        channelType: widget.channelType,
        onProgress: (sent, total) {
          if (mounted && total > 0) {
            setState(() => _uploadProgress = sent / total);
          }
        },
      );
      if (!mounted) return;
      final content = ChatAudioContent(
        fileId: uploaded.fileId,
        durationMs: duration,
      );
      _attachReply(content);
      WKIM.shared.messageManager.sendMessage(
        content,
        WKChannel(widget.channelId, widget.channelType),
      );
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '语音发送失败，请稍后重试');
      }
    } finally {
      if (path != null) {
        await File(path).delete().catchError((_) => File(path!));
      }
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
          if (widget.channelType == 1)
            IconButton(
              tooltip: '语音通话',
              onPressed: _recording || _voiceBusy || _uploading
                  ? null
                  : () => _startCall(video: false),
              icon: const Icon(Icons.call_outlined),
            ),
          if (widget.channelType == 1)
            IconButton(
              tooltip: '视频通话',
              onPressed: _recording || _voiceBusy || _uploading
                  ? null
                  : () => _startCall(video: true),
              icon: const Icon(Icons.videocam_outlined),
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
                            '开始聊天',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '发送第一条消息，或分享图片和文件',
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
                                      ? _MessageAvatar(name: senderName)
                                      : const SizedBox(width: 34),
                                  const SizedBox(width: 8),
                                ],
                                GestureDetector(
                                  onLongPress:
                                      _revokedClientMsgNos.contains(
                                        message.clientMsgNO,
                                      )
                                      ? null
                                      : () =>
                                            _showMessageActions(message, mine),
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
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                )
                                              : Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (showSender) ...[
                                                      Text(
                                                        senderName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
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
                                                      fileTransferService: widget
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
                                                            )
                                                          : null,
                                                      receipt:
                                                          mine &&
                                                              _receipts[message
                                                                      .messageID] !=
                                                                  null
                                                          ? (widget.channelType ==
                                                                    1
                                                                ? (_receipts[message.messageID]!
                                                                              .readCount >
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
                              : '回复 ${widget.channelType == 1 ? widget.title : _replyingTo!.fromUID}',
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
                children: [
                  IconButton(
                    tooltip: '发送图片或文件',
                    onPressed: _uploading || _recording || _voiceBusy
                        ? null
                        : _showAttachments,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _composer,
                      focusNode: _composerFocus,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      onTap: () {
                        if (_showEmojiPanel) {
                          setState(() => _showEmojiPanel = false);
                        }
                      },
                      decoration: ChatStyles.composer(
                        Theme.of(context).colorScheme,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: _showEmojiPanel ? '显示键盘' : '表情',
                    onPressed: _toggleEmojiPanel,
                    icon: Icon(
                      _showEmojiPanel
                          ? Icons.keyboard_alt_outlined
                          : Icons.sentiment_satisfied_alt_outlined,
                    ),
                  ),
                  ComposerActionButton(
                    hasText: _composer.text.trim().isNotEmpty,
                    recording: _recording,
                    voiceBusy: _uploading || _voiceBusy,
                    onSend: _send,
                    onVoice: _toggleRecording,
                  ),
                ],
              ),
            ),
          ),
          if (_uploading)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _uploadProgress > 0 ? _uploadProgress : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _uploadProgress > 0
                        ? '${(_uploadProgress * 100).round()}%'
                        : '正在处理…',
                    style: Theme.of(context).textTheme.labelMedium,
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
    label: '发送$label',
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 9),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    ),
  );
}

class _MessageAvatar extends StatelessWidget {
  const _MessageAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 17,
    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    child: Text(
      name.trim().isEmpty ? '?' : name.trim().characters.first,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
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
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          if (_loading) const LinearProgressIndicator(),
          Expanded(child: _buildResults(keyword)),
        ],
      ),
    );
  }

  Widget _buildResults(String keyword) {
    if (_error != null) {
      return Center(child: Text('搜索失败：$_error'));
    }
    if (keyword.isEmpty) {
      return const Center(child: Text('搜索当前设备已同步的聊天记录'));
    }
    if (!_loading && _results.isEmpty) {
      return const Center(child: Text('没有找到相关消息'));
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

  @override
  Widget build(BuildContext context) {
    if (content case ChatImageContent image) {
      return _ImageMessage(
        content: image,
        fileTransferService: fileTransferService,
      );
    }
    if (content case ChatFileContent file) {
      return _FileMessage(
        content: file,
        fileTransferService: fileTransferService,
      );
    }
    if (content case ChatVideoContent video) {
      return _VideoMessage(
        content: video,
        fileTransferService: fileTransferService,
      );
    }
    if (content case ChatAudioContent audio) {
      return _AudioMessage(
        content: audio,
        fileTransferService: fileTransferService,
      );
    }
    return Text(content?.displayText() ?? '[消息]');
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
  late Future<ResolvedUrl> _endpoint;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _endpoint = widget.fileTransferService.downloadUrl(widget.content.fileId);
  }

  @override
  Widget build(BuildContext context) => ChatMediaFrame(
    width: widget.content.width,
    height: widget.content.height,
    child: FutureBuilder<ResolvedUrl>(
      future: _endpoint,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SizedBox(
            width: 180,
            height: 110,
            child: TextButton.icon(
              onPressed: () => setState(_load),
              icon: const Icon(Icons.refresh),
              label: const Text('图片加载失败，重试'),
            ),
          );
        }
        final endpoint = snapshot.data;
        if (endpoint == null) {
          return const SizedBox(
            width: 180,
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => _ImagePreviewPage(endpoint: endpoint),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              endpoint.url,
              key: ValueKey('message-image-${widget.content.fileId}'),
              headers: endpoint.headers,
              width: 220,
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => SizedBox(
                width: 180,
                height: 100,
                child: TextButton.icon(
                  onPressed: () => setState(_load),
                  icon: const Icon(Icons.refresh),
                  label: const Text('图片加载失败，重试'),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class _ImagePreviewPage extends StatelessWidget {
  const _ImagePreviewPage({required this.endpoint});

  final ResolvedUrl endpoint;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
      title: const Text('图片预览'),
    ),
    body: Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5,
        child: Image.network(
          endpoint.url,
          headers: endpoint.headers,
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

class _FileMessageState extends State<_FileMessage> {
  bool _downloading = false;
  double _progress = 0;

  Future<void> _downloadAndOpen() async {
    if (_downloading) return;
    setState(() {
      _downloading = true;
      _progress = 0;
    });
    try {
      final file = await widget.fileTransferService.download(
        fileId: widget.content.fileId,
        fileName: widget.content.name,
        onProgress: (received, total) {
          if (mounted && total > 0) {
            setState(() => _progress = received / total);
          }
        },
      );
      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) throw StateError(result.message);
    } catch (error) {
      if (mounted) {
        AppFeedback.error(context, error, fallback: '文件打开失败，请稍后重试');
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) => FileMessageTile(
    name: widget.content.name,
    sizeLabel: _formatBytes(widget.content.size),
    downloading: _downloading,
    progress: _progress,
    onOpen: _downloadAndOpen,
  );
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
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
  Object? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
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
    if (mounted) setState(() {});
  }

  Future<void> _retry() async {
    final old = _controller;
    old?.removeListener(_refresh);
    await old?.dispose();
    setState(() {
      _controller = null;
      _error = null;
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
      return const SizedBox(
        width: 220,
        height: 130,
        child: Center(child: CircularProgressIndicator()),
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
            '${_formatDuration(controller.value.duration)} · ${_formatBytes(widget.content.size)}',
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
  Object? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.endpoint.url),
      httpHeaders: widget.endpoint.headers,
    )..addListener(_refresh);
    _controller
        .initialize()
        .then((_) {
          if (mounted) {
            setState(() => _ready = true);
            _controller.play();
          }
        })
        .catchError((Object error) {
          if (mounted) setState(() => _error = error);
        });
  }

  void _refresh() {
    if (mounted) setState(() {});
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
        ? const Center(
            child: Text('视频加载失败', style: TextStyle(color: Colors.white)),
          )
        : !_ready
        ? const Center(child: CircularProgressIndicator())
        : Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: GestureDetector(
                    onTap: () => _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play(),
                    child: VideoPlayer(_controller),
                  ),
                ),
                VideoProgressIndicator(
                  _controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                IconButton.filled(
                  onPressed: () => _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play(),
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
        final endpoint = await widget.fileTransferService.downloadUrl(
          widget.content.fileId,
        );
        if (!mounted) return;
        await _player.setUrl(endpoint.url, headers: endpoint.headers);
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
  const _SendStatus({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      WKSendMsgResult.sendSuccess => (Icons.check, Colors.green),
      WKSendMsgResult.sendFail ||
      WKSendMsgResult.noRelation ||
      WKSendMsgResult.blackList ||
      WKSendMsgResult.notOnWhiteList => (Icons.error_outline, Colors.red),
      _ => (Icons.schedule, Theme.of(context).colorScheme.outline),
    };
    return Icon(icon, size: 14, color: color);
  }
}
