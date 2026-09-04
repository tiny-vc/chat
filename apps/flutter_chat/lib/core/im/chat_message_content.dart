import 'package:wukongimfluttersdk/model/wk_message_content.dart';

abstract final class ChatMessageType {
  static const image = 2;
  static const video = 3;
  static const file = 8;
  static const audio = 4;
  static const revoke = 9001;
  static const callSignal = 2001;
  static const system = 9002;
}

class ChatSystemContent extends WKMessageContent {
  ChatSystemContent() {
    contentType = ChatMessageType.system;
  }

  String event = '';

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    event = readString(json, 'event');
    return this;
  }

  @override
  Map<String, dynamic> encodeJson() => {'event': event};

  @override
  String displayText() => event == 'group.avatar_changed' ? '群头像已更新' : '[群通知]';
}

class ChatVideoContent extends WKMessageContent {
  ChatVideoContent({
    this.fileId = '',
    this.name = '',
    this.size = 0,
    this.durationMs = 0,
  }) {
    contentType = ChatMessageType.video;
  }

  String fileId;
  String name;
  int size;
  int durationMs;

  @override
  Map<String, dynamic> encodeJson() => {
    'fileId': fileId,
    'name': name,
    'size': size,
    'durationMs': durationMs,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    fileId = readString(json, 'fileId');
    name = readString(json, 'name');
    size = readInt(json, 'size');
    durationMs = readInt(json, 'durationMs');
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
  ChatAudioContent({this.fileId = '', this.durationMs = 0}) {
    contentType = ChatMessageType.audio;
  }

  String fileId;
  int durationMs;

  @override
  Map<String, dynamic> encodeJson() => {
    'fileId': fileId,
    'durationMs': durationMs,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    fileId = readString(json, 'fileId');
    durationMs = readInt(json, 'durationMs');
    return this;
  }

  @override
  String displayText() => '[语音]';

  @override
  String searchableWord() => '[语音]';
}

class ChatImageContent extends WKMessageContent {
  ChatImageContent({this.fileId = '', this.width = 0, this.height = 0}) {
    contentType = ChatMessageType.image;
  }

  String fileId;
  int width;
  int height;

  @override
  Map<String, dynamic> encodeJson() => {
    'fileId': fileId,
    'width': width,
    'height': height,
  };

  @override
  WKMessageContent decodeJson(Map<String, dynamic> json) {
    fileId = readString(json, 'fileId');
    width = readInt(json, 'width');
    height = readInt(json, 'height');
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
