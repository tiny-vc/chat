import 'package:wukongimfluttersdk/model/wk_message_content.dart';
import 'package:wukongimfluttersdk/model/wk_text_content.dart';

abstract final class ChatMessageType {
  static const image = 2;
  static const video = 5;
  static const file = 8;
  static const audio = 4;
  static const revoke = 9001;
  static const callSignal = 2001;
  static const callRecord = 2002;
  static const system = 9002;
}

bool isForwardableChatContent(WKMessageContent? content) =>
    content is WKTextContent ||
    content is ChatImageContent ||
    content is ChatVideoContent ||
    content is ChatAudioContent ||
    content is ChatFileContent;

class ChatSystemContent extends WKMessageContent {
  ChatSystemContent() {
    contentType = ChatMessageType.system;
  }

  String event = '';
  Map<String, dynamic> data = const {};

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    event = readString(json, 'event');
    final rawData = json['data'];
    data = rawData is Map
        ? rawData.map((key, value) => MapEntry(key.toString(), value))
        : const {};
    return this;
  }

  @override
  Map<String, dynamic> encodeJson() => {'event': event, 'data': data};

  @override
  String displayText() => switch (event) {
    'group.avatar_changed' => '群头像已更新',
    'group.name_changed' => '群名称已更新',
    'group.announcement_changed' =>
      (data['announcement']?.toString().isNotEmpty ?? false)
          ? '群公告已更新'
          : '群公告已清除',
    'group.member_role_changed' => '群成员权限已更新',
    'group.owner_transferred' => '群主已转让',
    'group.member_muted' => '群成员已被禁言',
    'group.member_unmuted' => '群成员已解除禁言',
    'group.join_request_approved' => '新成员已加入群聊',
    _ => '[群通知]',
  };
}

class ChatVideoContent extends WKMessageContent {
  ChatVideoContent({
    this.fileId = '',
    this.name = '',
    this.size = 0,
    this.durationMs = 0,
    this.width = 0,
    this.height = 0,
    this.thumbnailFileId = '',
  }) {
    contentType = ChatMessageType.video;
  }

  String fileId;
  String name;
  int size;
  int durationMs;
  int width;
  int height;
  String thumbnailFileId;

  @override
  Map<String, dynamic> encodeJson() => {
    'fileId': fileId,
    'name': name,
    'size': size,
    'durationMs': durationMs,
    'width': width,
    'height': height,
    if (thumbnailFileId.isNotEmpty) 'thumbnailFileId': thumbnailFileId,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    fileId = readString(json, 'fileId');
    name = readString(json, 'name');
    size = readInt(json, 'size');
    durationMs = readInt(json, 'durationMs');
    width = readInt(json, 'width');
    height = readInt(json, 'height');
    thumbnailFileId = readString(json, 'thumbnailFileId');
    return this;
  }

  @override
  String displayText() => '[视频]';

  @override
  String searchableWord() => '[视频] $name';
}

class ChatCallSignalContent extends WKMessageContent {
  ChatCallSignalContent() {
    contentType = ChatMessageType.callSignal;
  }

  String callId = '';
  String callType = 'audio';
  String action = '';
  String roomName = '';
  String fromUserId = '';

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    callId = readString(json, 'callId');
    callType = readString(json, 'callType');
    action = readString(json, 'action');
    roomName = readString(json, 'roomName');
    return this;
  }

  @override
  String displayText() => callType == 'video' ? '[视频通话]' : '[语音通话]';

  @override
  String searchableWord() => displayText();
}

class ChatCallRecordContent extends WKMessageContent {
  ChatCallRecordContent() {
    contentType = ChatMessageType.callRecord;
  }

  String callId = '';
  String callType = 'audio';
  String status = '';
  String endReason = '';
  int durationSeconds = 0;

  bool get video => callType == 'video';

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    callId = readString(json, 'callId');
    callType = readString(json, 'callType');
    status = readString(json, 'status');
    endReason = readString(json, 'endReason');
    durationSeconds = readInt(json, 'durationSeconds');
    return this;
  }

  @override
  String displayText() {
    final kind = video ? '视频通话' : '语音通话';
    if (durationSeconds > 0) {
      final minutes = durationSeconds ~/ 60;
      final seconds = durationSeconds % 60;
      return '$kind  ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return switch (endReason) {
      'NO_ANSWER' => '$kind  未接听',
      'REJECTED' => '$kind  已拒绝',
      'BUSY' => '$kind  对方忙',
      'CANCELLED' => '$kind  已取消',
      _ => '$kind  未接通',
    };
  }

  @override
  String searchableWord() => displayText();
}

class ChatRevokeContent extends WKMessageContent {
  ChatRevokeContent({this.originalClientMsgNo = ''}) {
    contentType = ChatMessageType.revoke;
  }

  String originalClientMsgNo;

  @override
  Map<String, dynamic> encodeJson() => {
    'originalClientMsgNo': originalClientMsgNo,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    originalClientMsgNo = readString(json, 'originalClientMsgNo');
    return this;
  }

  @override
  String displayText() => '[消息已撤回]';

  @override
  String searchableWord() => '';
}

class ChatAudioContent extends WKMessageContent {
  ChatAudioContent({
    this.fileId = '',
    this.durationMs = 0,
    this.size = 0,
    this.mimeType = 'audio/mp4',
  }) {
    contentType = ChatMessageType.audio;
  }

  String fileId;
  int durationMs;
  int size;
  String mimeType;

  @override
  Map<String, dynamic> encodeJson() => {
    'fileId': fileId,
    'durationMs': durationMs,
    'size': size,
    'mimeType': mimeType,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    fileId = readString(json, 'fileId');
    durationMs = readInt(json, 'durationMs');
    size = readInt(json, 'size');
    mimeType = readString(json, 'mimeType');
    if (mimeType.isEmpty) mimeType = 'audio/mp4';
    return this;
  }

  @override
  String displayText() => '[语音]';

  @override
  String searchableWord() => '[语音]';
}

class ChatImageContent extends WKMessageContent {
  ChatImageContent({
    this.fileId = '',
    this.size = 0,
    this.mimeType = 'image/jpeg',
    this.width = 0,
    this.height = 0,
    this.thumbnailFileId = '',
    this.thumbnailSize = 0,
  }) {
    contentType = ChatMessageType.image;
  }

  String fileId;
  int size;
  String mimeType;
  int width;
  int height;
  String thumbnailFileId;
  int thumbnailSize;

  @override
  Map<String, dynamic> encodeJson() => {
    'fileId': fileId,
    'size': size,
    'mimeType': mimeType,
    'width': width,
    'height': height,
    if (thumbnailFileId.isNotEmpty) 'thumbnailFileId': thumbnailFileId,
    if (thumbnailSize > 0) 'thumbnailSize': thumbnailSize,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    fileId = readString(json, 'fileId');
    size = readInt(json, 'size');
    mimeType = readString(json, 'mimeType');
    if (mimeType.isEmpty) mimeType = 'image/jpeg';
    width = readInt(json, 'width');
    height = readInt(json, 'height');
    thumbnailFileId = readString(json, 'thumbnailFileId');
    thumbnailSize = readInt(json, 'thumbnailSize');
    return this;
  }

  @override
  String displayText() => '[图片]';

  @override
  String searchableWord() => '[图片]';
}

class ChatFileContent extends WKMessageContent {
  ChatFileContent({
    this.fileId = '',
    this.name = '',
    this.size = 0,
    this.mimeType = 'application/octet-stream',
  }) {
    contentType = ChatMessageType.file;
  }

  String fileId;
  String name;
  int size;
  String mimeType;

  @override
  Map<String, dynamic> encodeJson() => {
    'fileId': fileId,
    'name': name,
    'size': size,
    'mimeType': mimeType,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    fileId = readString(json, 'fileId');
    name = readString(json, 'name');
    size = readInt(json, 'size');
    mimeType = readString(json, 'mimeType');
    return this;
  }

  @override
  String displayText() => name.isEmpty ? '[文件]' : '[文件] $name';

  @override
  String searchableWord() => name;
}
