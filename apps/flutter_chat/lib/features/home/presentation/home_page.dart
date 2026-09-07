import 'dart:async';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:flutter/material.dart';
import 'package:wukongimfluttersdk/entity/conversation.dart';
import 'package:wukongimfluttersdk/entity/msg.dart';

import '../../auth/data/auth_repository.dart';
import '../../../core/im/im_service.dart';
import '../../../core/files/file_transfer_service.dart';
import '../../../core/calls/call_service.dart';
import '../../../core/calls/call_coordinator.dart';
import '../../../core/calls/call_recovery.dart';
import '../../../core/im/chat_message_content.dart';
import '../../calls/presentation/call_page.dart';
import '../../calls/presentation/incoming_call_dialog.dart';
import '../../calls/presentation/outgoing_call_launcher.dart';
import '../data/home_repository.dart';
import 'home_controller.dart';
import '../../../core/widgets/app_feedback.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/conversation_list_tile.dart';
import '../../../core/widgets/im_connection_banner.dart';
import '../../../core/permissions/permission_ui.dart';
import 'contact_management_page.dart';
import 'group_settings_page.dart';
import 'group_join_page.dart';
import 'profile_page.dart';
import 'friend_profile_page.dart';
import '../../chat/presentation/chat_page.dart';
import '../../../config/server_settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.controller,
    required this.imService,
    required this.fileTransferService,
    required this.callService,
    required this.authRepository,
    required this.onLoggedOut,
    this.capabilities = ServerCapabilities.all,
  });

  final HomeController controller;
  final ImService imService;
  final FileTransferService fileTransferService;
  final CallService callService;
  final AuthRepository authRepository;
  final VoidCallback onLoggedOut;
  final ServerCapabilities capabilities;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _tab = 0;
  StreamSubscription<ChatCallSignalContent>? _callSignals;
  StreamSubscription<String>? _groupChanges;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.controller.addListener(_refresh);
    widget.imService.addListener(_refresh);
    widget.controller.load();
    unawaited(widget.callService.flushTerminalReports());
    _callSignals = widget.imService.callSignals.listen(_handleCallSignal);
    _groupChanges = widget.imService.groupChanges.listen(
      widget.controller.refreshRemoteGroup,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.removeListener(_refresh);
    widget.imService.removeListener(_refresh);
    _callSignals?.cancel();
    _groupChanges?.cancel();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.controller.load();
      widget.imService.reconcileRemoteState();
      unawaited(widget.callService.flushTerminalReports());
    }
  }

  Future<void> _handleCallSignal(ChatCallSignalContent signal) async {
    if (!mounted) return;
    final coordinator = CallCoordinator.instance;
    if (signal.action != 'invite') {
      coordinator.recordTerminalSignal(signal.callId, signal.action);
      return;
    }
    final supported = signal.callType == 'video'
        ? widget.capabilities.canVideoCall
        : widget.capabilities.canAudioCall;
    if (!supported) {
      await widget.callService.reject(signal.callId).catchError((_) {});
      return;
    }
    if (coordinator.hasActiveCall) {
      if (coordinator.ownsCall(signal.callId)) return;
      await widget.callService.busy(signal.callId).catchError((_) {});
      return;
    }
    final lease = coordinator.beginIncoming(
      callId: signal.callId,
      video: signal.callType == 'video',
    );
    if (lease == null) {
      await widget.callService.busy(signal.callId).catchError((_) {});
      return;
    }
    final caller = _callerName(signal.fromUserId);
    try {
      final result = await showIncomingCallDialog(
        context: context,
        callId: signal.callId,
        caller: caller,
        video: signal.callType == 'video',
        signals: widget.imService.callSignals,
      );
      if (!mounted) return;
      if (result == IncomingCallResult.accept) {
        try {
          // Confirm immediately so the server invitation cannot expire while
          // the user is completing microphone/camera permission prompts.
          await widget.callService.accept(signal.callId);
        } catch (error) {
          if (mounted) {
            AppFeedback.error(context, error, fallback: '接听失败，通话可能已结束');
          }
          return;
        }
        coordinator.update(lease, CoordinatedCallPhase.connecting);
        if (!mounted) {
          unawaited(
            reportCallEnd(
              () => widget.callService.queueTerminal(signal.callId, 'end'),
              widget.callService.flushTerminalReports,
              () {},
            ),
          );
          return;
        }
        final effectiveVideo = await prepareCallPermissions(
          context,
          video: signal.callType == 'video',
        );
        if (effectiveVideo == null || !mounted) {
          unawaited(
            reportCallEnd(
              () => widget.callService.queueTerminal(signal.callId, 'end'),
              widget.callService.flushTerminalReports,
              () {},
            ),
          );
          return;
        }
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CallPage(
              callId: signal.callId,
              title: caller,
              video: effectiveVideo,
              incoming: true,
              callService: widget.callService,
              imService: widget.imService,
              callLease: lease,
              alreadyAccepted: true,
            ),
          ),
        );
        final endedAction = coordinator.terminalAction(lease);
        if (mounted && endedAction != null) {
          AppFeedback.show(context, callTerminalMessage(endedAction));
        }
      } else if (result == IncomingCallResult.reject) {
        await widget.callService.reject(signal.callId).catchError((_) {});
      }
    } finally {
      coordinator.release(lease);
    }
  }

  String _callerName(String userId) {
    for (final friend
        in widget.controller.snapshot?.friends ?? const <FriendResponse>[]) {
      if (friend.user.id == userId) return friend.user.nickname;
    }
    return '好友';
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['会话', '通讯录', '我的'];
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_tab]),
        actions: _tab == 1
            ? [
                IconButton(
                  tooltip: '添加好友',
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ContactManagementPage(
                          controller: widget.controller,
                        ),
                      ),
                    );
                    await widget.controller.load();
                  },
                  icon: const Icon(Icons.person_add_outlined),
                ),
                if (widget.capabilities.groups)
                  IconButton(
                    tooltip: '创建群聊',
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            CreateGroupPage(controller: widget.controller),
                      ),
                    ),
                    icon: const Icon(Icons.group_add_outlined),
                  ),
                if (widget.capabilities.groups)
                  IconButton(
                    tooltip: '刷新',
                    onPressed: widget.controller.loading
                        ? null
                        : widget.controller.load,
                    icon: const Icon(Icons.refresh),
                  ),
                IconButton(
                  tooltip: '入群申请与邀请',
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => GroupJoinPage(
                          controller: widget.controller,
                          actionable: true,
                        ),
                      ),
                    );
                    if (mounted) await widget.controller.refreshPendingJoins();
                  },
                  icon: Badge(
                    isLabelVisible:
                        widget.controller.pendingJoinError != null ||
                        (widget.controller.pendingJoinCount ?? 0) > 0,
                    label: Text(
                      widget.controller.pendingJoinError != null
                          ? '!'
                          : (widget.controller.pendingJoinCount ?? 0) > 99
                          ? '99+'
                          : '${widget.controller.pendingJoinCount}',
                    ),
                    child: const Icon(Icons.mark_email_unread_outlined),
                  ),
                ),
              ]
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: KeyedSubtree(key: ValueKey(_tab), child: _buildBody()),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) {
          setState(() => _tab = index);
          if (index == 1) widget.controller.refreshPendingJoins();
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: '会话',
          ),
          NavigationDestination(
            icon: Icon(Icons.contacts_outlined),
            selectedIcon: Icon(Icons.contacts),
            label: '通讯录',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (widget.controller.loading && widget.controller.snapshot == null) {
      return const AppLoading();
    }
    if (widget.controller.error != null && widget.controller.snapshot == null) {
      return _LoadError(onRetry: widget.controller.load);
    }

    return switch (_tab) {
      0 => ConversationsView(
        imService: widget.imService,
        fileTransferService: widget.fileTransferService,
        callService: widget.callService,
        snapshot: widget.controller.snapshot,
        capabilities: widget.capabilities,
      ),
      1 => ContactsView(
        controller: widget.controller,
        snapshot: widget.controller.snapshot,
        imService: widget.imService,
        fileTransferService: widget.fileTransferService,
        callService: widget.callService,
        capabilities: widget.capabilities,
      ),
      _ => ProfilePage(
        controller: widget.controller,
        fileTransferService: widget.fileTransferService,
        callService: widget.callService,
        authRepository: widget.authRepository,
        onDeactivated: widget.onLoggedOut,
        onRedial: _redial,
        onLogout: () async {
          await widget.authRepository.logout();
          widget.onLoggedOut();
        },
        allowAvatarUpload: widget.capabilities.files,
      ),
    };
  }

  Future<void> _redial(CallHistoryItem item) async {
    await launchOutgoingCall(
      context: context,
      targetUserId: item.peerId,
      title: item.peerName,
      video: item.video,
      callService: widget.callService,
      imService: widget.imService,
      capabilities: widget.capabilities,
    );
  }
}

class ConversationsView extends StatelessWidget {
  const ConversationsView({
    super.key,
    required this.imService,
    required this.fileTransferService,
    required this.callService,
    required this.snapshot,
    this.capabilities = ServerCapabilities.all,
    this.archived = false,
  });

  final ImService imService;
  final FileTransferService fileTransferService;
  final CallService callService;
  final HomeSnapshot? snapshot;
  final ServerCapabilities capabilities;
  final bool archived;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: imService,
    builder: (context, _) => _buildList(context),
  );

  Widget _buildList(BuildContext context) {
    final conversations = imService.conversationsFor(archived: archived);
    final archivedCount = imService.conversationsFor(archived: true).length;
    if (conversations.isEmpty && (archived || archivedCount == 0)) {
      return Column(
        children: [
          if (imService.connectionState != ImConnectionState.connected)
            ImConnectionBanner(
              state: imService.connectionState,
              onRetry: imService.reconnect,
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.62,
                    child: _EmptyState(
                      icon: archived
                          ? Icons.archive_outlined
                          : Icons.forum_outlined,
                      title: archived ? '暂无归档会话' : '开始第一次对话',
                      description: archived
                          ? '长按会话可归档，聊天记录仍会保留'
                          : _statusText(imService.connectionState),
                      action:
                          imService.connectionState ==
                                  ImConnectionState.disconnected ||
                              imService.connectionState ==
                                  ImConnectionState.noNetwork
                          ? OutlinedButton.icon(
                              onPressed: imService.reconnect,
                              icon: const Icon(Icons.refresh),
                              label: const Text('重新连接'),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (!archived && archivedCount > 0)
          ListTile(
            leading: const Icon(Icons.archive_outlined),
            title: const Text('已归档会话'),
            subtitle: Text('$archivedCount 个会话 · 新消息仍保留在归档中'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => Scaffold(
                  appBar: AppBar(
                    title: const Text('已归档会话'),
                    actions: [
                      IconButton(
                        tooltip: '刷新归档',
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          try {
                            await imService.refreshConversationSettings();
                          } catch (error) {
                            if (context.mounted) {
                              AppFeedback.error(context, error);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  body: ConversationsView(
                    imService: imService,
                    fileTransferService: fileTransferService,
                    callService: callService,
                    snapshot: snapshot,
                    archived: true,
                  ),
                ),
              ),
            ),
          ),
        if (imService.connectionState != ImConnectionState.connected)
          ImConnectionBanner(
            state: imService.connectionState,
            onRetry: imService.reconnect,
          ),
        if (imService.lastReconciledAt case final synchronizedAt?)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                imService.isReconciling
                    ? '正在刷新…'
                    : '最近同步 ${_formatSyncTime(synchronizedAt)}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: conversations.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, indent: 82, endIndent: 20),
              itemBuilder: (context, index) {
                final conversation = conversations[index];
                final working = imService.isUpdatingSetting(
                  conversation.channelID,
                  conversation.channelType,
                );
                final setting = imService.settingFor(
                  conversation.channelID,
                  conversation.channelType,
                );
                final title = _channelTitle(
                  conversation.channelID,
                  conversation.channelType,
                );
                return Dismissible(
                  key: ValueKey(
                    '${conversation.channelType}:${conversation.channelID}',
                  ),
                  direction: working
                      ? DismissDirection.none
                      : DismissDirection.endToStart,
                  confirmDismiss: (_) => _confirmDelete(context, title),
                  onDismissed: (_) =>
                      _deleteConversation(context, conversation),
                  background: Container(
                    color: Theme.of(context).colorScheme.errorContainer,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 24),
                    child: Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                  child: Material(
                    color: setting.pinned
                        ? Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: 0.22)
                        : Colors.transparent,
                    child: ConversationListTile(
                      leading: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          AppAvatar(
                            name: title,
                            fileId: conversation.channelType == 2
                                ? snapshot?.groups
                                      .where(
                                        (g) => g.id == conversation.channelID,
                                      )
                                      .firstOrNull
                                      ?.avatarFileId
                                : snapshot?.friends
                                      .where(
                                        (f) =>
                                            f.user.id == conversation.channelID,
                                      )
                                      .firstOrNull
                                      ?.user
                                      .avatarFileId,
                            group: conversation.channelType == 2,
                            resolveUrl: fileTransferService.downloadUrl,
                          ),
                          if (setting.pinned)
                            Positioned(
                              right: -3,
                              top: -3,
                              child: Icon(
                                Icons.push_pin,
                                size: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                        ],
                      ),
                      title: Text(title),
                      subtitle: _ConversationSubtitle(
                        conversation: conversation,
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (working)
                            const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          Text(
                            _formatConversationTime(
                              conversation.lastMsgTimestamp,
                            ),
                            style: Theme.of(context).textTheme.labelSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (conversation.unreadCount > 0) ...[
                            const SizedBox(height: 4),
                            Badge(
                              backgroundColor: setting.muted
                                  ? Theme.of(context).colorScheme.outline
                                  : Theme.of(context).colorScheme.error,
                              label: Text(
                                conversation.unreadCount > 99
                                    ? '99+'
                                    : '${conversation.unreadCount}',
                              ),
                            ),
                          ],
                          if (setting.muted && conversation.unreadCount == 0)
                            const Icon(
                              Icons.notifications_off_outlined,
                              size: 16,
                            ),
                        ],
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => ChatPage(
                            channelId: conversation.channelID,
                            channelType: conversation.channelType,
                            title: title,
                            imService: imService,
                            fileTransferService: fileTransferService,
                            forwardTargets: _forwardTargets(snapshot),
                            callService: callService,
                            capabilities: capabilities,
                            memberNames: _memberNamesFor(
                              snapshot,
                              conversation.channelID,
                            ),
                          ),
                        ),
                      ),
                      onLongPress: () => _showConversationActions(
                        context,
                        conversation,
                        title,
                        setting,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _refresh(BuildContext context) async {
    if (imService.connectionState == ImConnectionState.disconnected ||
        imService.connectionState == ImConnectionState.noNetwork) {
      await imService.reconnect();
    }
    final refreshed = await imService.reconcileRemoteState();
    if (!refreshed && context.mounted && !imService.isReconciling) {
      AppFeedback.show(context, '刷新失败，请检查网络后重试', kind: FeedbackKind.error);
    }
  }

  String _formatSyncTime(DateTime value) {
    final local = value.toLocal();
    final elapsed = DateTime.now().difference(local);
    if (elapsed.inSeconds < 10) return '刚刚';
    if (elapsed.inMinutes < 1) return '${elapsed.inSeconds} 秒前';
    if (elapsed.inHours < 1) return '${elapsed.inMinutes} 分钟前';
    return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  Future<bool> _confirmDelete(BuildContext context, String title) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除会话'),
            content: Text('确定从会话列表删除“$title”吗？\n已同步的聊天记录不会被删除。'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('删除'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _deleteConversation(
    BuildContext context,
    WKUIConversationMsg conversation,
  ) async {
    try {
      await imService.deleteConversation(
        conversation.channelID,
        conversation.channelType,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('会话已从列表移除')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('删除失败：$error')));
      }
    }
  }

  Future<void> _showConversationActions(
    BuildContext context,
    WKUIConversationMsg conversation,
    String title,
    ConversationSetting setting,
  ) async {
    if (imService.isUpdatingSetting(
      conversation.channelID,
      conversation.channelType,
    )) {
      return;
    }
    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  setting.archived
                      ? Icons.unarchive_outlined
                      : Icons.archive_outlined,
                ),
                title: Text(setting.archived ? '恢复到会话列表' : '归档会话'),
                subtitle: Text(
                  setting.archived ? '保留原有置顶和免打扰设置' : '不删除记录，不改变消息提醒设置',
                ),
                onTap: () => Navigator.pop(context, 'archive'),
              ),
              ListTile(
                leading: Icon(
                  setting.pinned ? Icons.push_pin_outlined : Icons.push_pin,
                ),
                title: Text(setting.pinned ? '取消置顶' : '置顶会话'),
                onTap: () => Navigator.pop(context, 'pin'),
              ),
              ListTile(
                leading: Icon(
                  setting.muted
                      ? Icons.notifications_outlined
                      : Icons.notifications_off_outlined,
                ),
                title: Text(setting.muted ? '开启消息提醒' : '消息免打扰'),
                onTap: () => Navigator.pop(context, 'mute'),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  '删除会话',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                subtitle: const Text('不会删除已同步的聊天记录'),
                onTap: () => Navigator.pop(context, 'delete'),
              ),
            ],
          ),
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    try {
      if (action == 'archive') {
        await imService.updateConversationSetting(
          channelId: conversation.channelID,
          channelType: conversation.channelType,
          archived: !setting.archived,
        );
      } else if (action == 'pin') {
        await imService.updateConversationSetting(
          channelId: conversation.channelID,
          channelType: conversation.channelType,
          pinned: !setting.pinned,
        );
      } else if (action == 'mute') {
        await imService.updateConversationSetting(
          channelId: conversation.channelID,
          channelType: conversation.channelType,
          muted: !setting.muted,
        );
      } else {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('删除会话'),
            content: Text('确定从会话列表删除“$title”吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('删除'),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          await imService.deleteConversation(
            conversation.channelID,
            conversation.channelType,
          );
        }
      }
    } catch (error) {
      if (context.mounted) {
        AppFeedback.error(context, error);
      }
    }
  }

  String _channelTitle(String channelId, int channelType) {
    if (channelType == 2) {
      for (final group in snapshot?.groups ?? const <GroupResponse>[]) {
        if (group.id == channelId) return group.name;
      }
    } else {
      for (final friend in snapshot?.friends ?? const <FriendResponse>[]) {
        if (friend.user.id == channelId) return friend.user.nickname;
      }
    }
    return channelId;
  }

  String _statusText(ImConnectionState state) => switch (state) {
    ImConnectionState.connecting => '正在连接消息服务器…',
    ImConnectionState.syncing => '正在同步新消息…',
    ImConnectionState.connected => '已连接，选择好友即可开始聊天',
    ImConnectionState.noNetwork => '当前网络不可用',
    ImConnectionState.kicked => '账号已在其他设备登录',
    ImConnectionState.disconnected => '消息服务器未连接',
  };

  String _formatConversationTime(int seconds) {
    if (seconds <= 0) return '';
    final time = DateTime.fromMillisecondsSinceEpoch(seconds * 1000).toLocal();
    final now = DateTime.now();
    if (time.year == now.year &&
        time.month == now.month &&
        time.day == now.day) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.month}/${time.day}';
  }
}

class _ConversationSubtitle extends StatelessWidget {
  const _ConversationSubtitle({required this.conversation});

  final WKUIConversationMsg conversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WKMsg?>(
      future: conversation.getWkMsg(),
      builder: (context, snapshot) => Text(
        snapshot.data?.messageContent?.displayText() ?? '暂无消息摘要',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ContactsView extends StatefulWidget {
  const ContactsView({
    super.key,
    required this.controller,
    required this.snapshot,
    required this.imService,
    required this.fileTransferService,
    required this.callService,
    this.capabilities = ServerCapabilities.all,
  });

  final HomeController controller;
  final HomeSnapshot? snapshot;
  final ImService imService;
  final FileTransferService fileTransferService;
  final CallService callService;
  final ServerCapabilities capabilities;

  @override
  State<ContactsView> createState() => _ContactsState();
}

class _ContactsState extends State<ContactsView> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final snapshot = widget.snapshot;
    final imService = widget.imService;
    final fileTransferService = widget.fileTransferService;
    final callService = widget.callService;
    final capabilities = widget.capabilities;
    final allFriends = snapshot?.friends ?? const <FriendResponse>[];
    final allGroups = capabilities.groups
        ? snapshot?.groups ?? const <GroupResponse>[]
        : const <GroupResponse>[];
    final query = _query.trim().toLowerCase();
    final friends = query.isEmpty
        ? allFriends
        : allFriends
              .where(
                (item) =>
                    item.user.nickname.toLowerCase().contains(query) ||
                    item.user.username.toLowerCase().contains(query),
              )
              .toList();
    final groups = query.isEmpty
        ? allGroups
        : allGroups
              .where((item) => item.name.toLowerCase().contains(query))
              .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: SearchBar(
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            controller: _search,
            hintText: '搜索好友、用户名或群聊',
            leading: const Icon(Icons.search),
            trailing: [
              if (_query.isNotEmpty)
                IconButton(
                  tooltip: '清除搜索',
                  onPressed: () {
                    _search.clear();
                    setState(() => _query = '');
                  },
                  icon: const Icon(Icons.close),
                ),
            ],
            onChanged: (value) => setState(() => _query = value),
          ),
        ),
        Expanded(
          child: ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              if (friends.isEmpty && groups.isEmpty)
                AppStatus(
                  icon: query.isEmpty ? Icons.people_outline : Icons.search_off,
                  title: query.isEmpty ? '通讯录还是空的' : '没有找到联系人',
                  message: query.isEmpty
                      ? '点击右上角添加好友或创建群聊'
                      : '请在上方修改名称或用户名继续搜索',
                ),
              if (query.isEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                  child: Text(
                    '${allFriends.length} 位好友 · ${allGroups.length} 个群聊',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              if (groups.isNotEmpty) ...[
                _SectionTitle('群聊 · ${groups.length}'),
                for (final group in groups)
                  ListTile(
                    leading: AppAvatar(
                      name: group.name,
                      fileId: group.avatarFileId,
                      group: true,
                      resolveUrl: fileTransferService.downloadUrl,
                    ),
                    title: Text(group.name),
                    subtitle: Text(
                      group.members == null
                          ? '群聊'
                          : '${group.members!.length} 位成员',
                    ),
                    trailing: IconButton(
                      tooltip: '群聊资料',
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => GroupSettingsPage(
                              groupId: group.id,
                              controller: controller,
                              fileTransferService: fileTransferService,
                              allowAvatarUpload: capabilities.files,
                            ),
                          ),
                        );
                        await controller.load();
                      },
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ChatPage(
                          channelId: group.id,
                          channelType: 2,
                          title: group.name,
                          imService: imService,
                          fileTransferService: fileTransferService,
                          forwardTargets: _forwardTargets(snapshot),
                          callService: callService,
                          capabilities: capabilities,
                          memberNames: {
                            for (final member
                                in group.members ??
                                    const <GroupMemberResponse>[])
                              member.userId:
                                  member.user?.nickname ?? member.userId,
                          },
                        ),
                      ),
                    ),
                  ),
              ],
              if (friends.isNotEmpty) ...[
                _SectionTitle('好友 · ${friends.length}'),
                for (final friend in friends)
                  ListTile(
                    leading: AppAvatar(
                      name: friend.user.nickname,
                      fileId: friend.user.avatarFileId,
                      resolveUrl: fileTransferService.downloadUrl,
                    ),
                    title: Text(friend.user.nickname),
                    subtitle: Text('@${friend.user.username}'),
                    trailing: IconButton(
                      tooltip: '好友资料',
                      icon: const Icon(Icons.info_outline),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => FriendProfilePage(
                              friend: friend,
                              controller: controller,
                              imService: imService,
                              fileTransferService: fileTransferService,
                              callService: callService,
                              forwardTargets: _forwardTargets(snapshot),
                              capabilities: capabilities,
                            ),
                          ),
                        );
                        await controller.load();
                      },
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ChatPage(
                          channelId: friend.user.id,
                          channelType: 1,
                          title: friend.user.nickname,
                          imService: imService,
                          fileTransferService: fileTransferService,
                          forwardTargets: _forwardTargets(snapshot),
                          callService: callService,
                          capabilities: capabilities,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

List<ForwardTarget> _forwardTargets(HomeSnapshot? snapshot) => [
  for (final group in snapshot?.groups ?? const <GroupResponse>[])
    ForwardTarget(channelId: group.id, channelType: 2, title: group.name),
  for (final friend in snapshot?.friends ?? const <FriendResponse>[])
    ForwardTarget(
      channelId: friend.user.id,
      channelType: 1,
      title: friend.user.nickname,
    ),
];

Map<String, String> _memberNamesFor(HomeSnapshot? snapshot, String groupId) {
  if (snapshot == null) return const {};
  for (final group in snapshot.groups) {
    if (group.id != groupId) continue;
    return {
      for (final member in group.members ?? const <GroupMemberResponse>[])
        member.userId: member.user?.nickname ?? member.userId,
    };
  }
  return const {};
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => AppStatus(
    title: '数据加载失败',
    message: '请检查网络后重试',
    icon: Icons.cloud_off_outlined,
    onRetry: onRetry,
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(
              icon,
              size: 44,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (action != null) ...[const SizedBox(height: 18), action!],
        ],
      ),
    ),
  );
}
