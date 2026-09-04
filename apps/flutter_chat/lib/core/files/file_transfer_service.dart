import 'dart:io';
import 'dart:convert';

import 'package:chat_api_client/chat_api_client.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/app_config.dart';
import '../../config/server_settings.dart';

class UploadedChatFile {
  const UploadedChatFile({
    required this.fileId,
    required this.name,
    required this.size,
    required this.mimeType,
  });

  final String fileId;
  final String name;
  final int size;
  final String mimeType;
}

class FileTransferService {
  FileTransferService(this._api) : _storage = Dio();

  final ChatApiClient _api;
  final Dio _storage;

  Future<UploadedChatFile> upload({
    required PlatformFile file,
    required String channelId,
    required int channelType,
    required bool image,
    ProgressCallback? onProgress,
  }) async {
    final size = await file.length();
    final mimeType = _mimeType(file.extension, image: image);
    return _upload(
      name: file.name,
      size: size,
      mimeType: mimeType,
      purpose: image
          ? CreateUploadDtoPurposeEnum.CHAT_IMAGE
          : CreateUploadDtoPurposeEnum.CHAT_FILE,
      channelId: channelId,
      channelType: channelType,
      stream: file.readAsByteStream(),
      onProgress: onProgress,
    );
  }

  Future<UploadedChatFile> uploadVoice({
    required String path,
    required String channelId,
    required int channelType,
    ProgressCallback? onProgress,
  }) async {
    final source = File(path);
    return _upload(
      name: path.split(Platform.pathSeparator).last,
      size: await source.length(),
      mimeType: 'audio/mp4',
      purpose: CreateUploadDtoPurposeEnum.CHAT_VOICE,
      channelId: channelId,
      channelType: channelType,
      stream: source.openRead(),
      onProgress: onProgress,
    );
  }

  Future<UploadedChatFile> uploadAvatar({
    required PlatformFile file,
    ProgressCallback? onProgress,
  }) async {
    final size = await file.length();
    return _upload(
      name: file.name,
      size: size,
      mimeType: _mimeType(file.extension, image: true),
      purpose: CreateUploadDtoPurposeEnum.AVATAR,
      scope: CreateUploadDtoScopeEnum.PRIVATE,
      stream: file.readAsByteStream(),
      onProgress: onProgress,
    );
  }

  Future<UploadedChatFile> uploadVideo({
    required PlatformFile file,
    required String channelId,
    required int channelType,
    ProgressCallback? onProgress,
  }) async {
    final size = await file.length();
    return _upload(
      name: file.name,
      size: size,
      mimeType: _mimeType(file.extension, image: false),
      purpose: CreateUploadDtoPurposeEnum.CHAT_VIDEO,
      channelId: channelId,
      channelType: channelType,
      stream: file.readAsByteStream(),
      onProgress: onProgress,
    );
  }

  Future<UploadedChatFile> _upload({
    required String name,
    required int size,
    required String mimeType,
    required CreateUploadDtoPurposeEnum purpose,
    String? channelId,
    int? channelType,
    CreateUploadDtoScopeEnum? scope,
    required Stream<List<int>> stream,
    ProgressCallback? onProgress,
  }) async {
    final request = CreateUploadDto(
      (builder) => builder
        ..fileName = name
        ..mimeType = mimeType
        ..size = size
        ..purpose = purpose
        ..scope =
            scope ??
            (channelType == 2
                ? CreateUploadDtoScopeEnum.GROUP
                : CreateUploadDtoScopeEnum.DIRECT)
        ..scopeId = channelId,
    );
    final created = (await _api.getFilesApi().filesCreateUpload(
      createUploadDto: request,
    )).data;
    if (created == null) throw StateError('服务器未返回上传地址');

    final endpoint = AppConfig.resolveSignedUrl(created.uploadUrl);
    await _storage.put<Object>(
      endpoint.url,
      data: stream,
      options: Options(
        headers: {
          ...created.headers.toMap(),
          ...endpoint.headers,
          Headers.contentLengthHeader: size,
        },
      ),
      onSendProgress: onProgress,
    );
    await _api.getFilesApi().filesComplete(fileId: created.fileId);
    return UploadedChatFile(
      fileId: created.fileId,
      name: name,
      size: size,
      mimeType: mimeType,
    );
  }

  Future<ResolvedUrl> downloadUrl(String fileId) async {
    final result = (await _api.getFilesApi().filesDownload(
      fileId: fileId,
    )).data;
    if (result == null) throw StateError('服务器未返回下载地址');
    return AppConfig.resolveSignedUrl(result.downloadUrl);
  }

  Future<File> download({
    required String fileId,
    required String fileName,
    ProgressCallback? onProgress,
  }) async {
    final endpoint = await downloadUrl(fileId);
    final directory = await getTemporaryDirectory();
    final sanitized = fileName
        .replaceAll(RegExp(r'[/\\:*?"<>|]'), '_')
        .replaceAll(RegExp(r'^\.+'), '');
    // Hash prefixes leave a bounded byte budget for a readable label. Keep the
    // extension so native preview can still recognize long/non-ASCII filenames.
    final extension =
        RegExp(r'\.[a-zA-Z0-9]{1,12}$').firstMatch(sanitized)?.group(0) ?? '';
    var safeName = '';
    for (final rune in sanitized.runes) {
      final next = safeName + String.fromCharCode(rune);
      if (utf8.encode(next).length > 80) break;
      safeName = next;
    }
    if (safeName != sanitized && !safeName.endsWith(extension)) {
      safeName += extension;
    }
    final target = File(
      '${directory.path}${Platform.pathSeparator}${scopedFileCacheKey(_api.dio.options.baseUrl, fileId)}_${safeName.isEmpty ? 'file' : safeName}',
    );
    if (await target.exists() && await target.length() > 0) return target;
    await _storage.download(
      endpoint.url,
      target.path,
      options: Options(headers: endpoint.headers),
      onReceiveProgress: onProgress,
    );
    return target;
  }

  Future<String> forwardFile({
    required String fileId,
    required String channelId,
    required int channelType,
  }) async {
    final response = await _api.dio.post<Object>(
      '/api/v1/files/$fileId/forward',
      data: {
        'scope': channelType == 2 ? 'GROUP' : 'DIRECT',
        'scopeId': channelId,
      },
    );
    final data = response.data;
    if (data is! Map || data['id'] is! String) {
      throw StateError('服务器未返回转发文件 ID');
    }
    return data['id'] as String;
  }

  String _mimeType(String? extension, {required bool image}) {
    return switch (extension?.toLowerCase()) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'pdf' => 'application/pdf',
      'txt' => 'text/plain',
      'json' => 'application/json',
      'zip' => 'application/zip',
      'mp4' => 'video/mp4',
      _ => image ? 'image/*' : 'application/octet-stream',
    };
  }

  void dispose() => _storage.close(force: true);
}
