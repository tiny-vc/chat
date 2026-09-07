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

class DownloadCacheStats {
  const DownloadCacheStats({required this.fileCount, required this.totalBytes});
  final int fileCount;
  final int totalBytes;
}

class ServerFileUsage {
  const ServerFileUsage({
    required this.usedBytes,
    required this.quotaBytes,
    required this.remainingBytes,
    required this.fileCount,
  });
  final int usedBytes;
  final int quotaBytes;
  final int remainingBytes;
  final int fileCount;

  double get usedRatio =>
      quotaBytes <= 0 ? 1 : (usedBytes / quotaBytes).clamp(0, 1).toDouble();
  bool get isFull => remainingBytes <= 0 || usedBytes >= quotaBytes;
  bool get isNearlyFull => !isFull && usedRatio >= .9;
}

class FileTransferService {
  FileTransferService(this._api, {Dio? storage}) : _storage = storage ?? Dio();

  final ChatApiClient _api;
  final Dio _storage;
  Future<void>? _cachePrune;
  var _activeDownloads = 0;

  Future<UploadedChatFile> upload({
    required PlatformFile file,
    required String channelId,
    required int channelType,
    required bool image,
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
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
      cancelToken: cancelToken,
    );
  }

  Future<UploadedChatFile> uploadVoice({
    required String path,
    required String channelId,
    required int channelType,
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
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
      cancelToken: cancelToken,
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
    CancelToken? cancelToken,
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
      cancelToken: cancelToken,
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
    CancelToken? cancelToken,
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
    try {
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
        cancelToken: cancelToken,
      );
      await _api.getFilesApi().filesComplete(fileId: created.fileId);
    } catch (_) {
      await _discardFailedUpload(created.fileId);
      rethrow;
    }
    return UploadedChatFile(
      fileId: created.fileId,
      name: name,
      size: size,
      mimeType: mimeType,
    );
  }

  Future<void> _discardFailedUpload(String fileId) async {
    try {
      // Use a fresh request instead of the upload CancelToken: cancellation of
      // the object PUT must not cancel cleanup of its server-side record.
      await _api.getFilesApi().filesDeleteFile(fileId: fileId);
    } catch (_) {
      // Completion can be ambiguous after a network loss, and cleanup itself
      // can fail offline. The server's pending-upload TTL is the final fallback.
    }
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
    int? expectedSize,
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
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
    _cachePrune ??= pruneChatDownloadCache(
      directory,
      namespace: serverNamespace(_api.dio.options.baseUrl),
      preservedPaths: {target.path},
    );
    await _cachePrune;
    if (await cachedDownloadIsValid(target, expectedSize: expectedSize)) {
      await markCachedDownloadAccessed(target);
      return target;
    }
    if (await target.exists()) await target.delete();
    final partial = File('${target.path}.part');
    if (await partial.exists()) await partial.delete();
    try {
      _activeDownloads++;
      final endpoint = await downloadUrl(fileId);
      await _storage.download(
        endpoint.url,
        partial.path,
        options: Options(headers: endpoint.headers),
        onReceiveProgress: onProgress,
        cancelToken: cancelToken,
      );
      await partial.rename(target.path);
    } catch (_) {
      if (await partial.exists()) await partial.delete();
      rethrow;
    } finally {
      _activeDownloads--;
    }
    return target;
  }

  Future<DownloadCacheStats> downloadCacheStats() async {
    final files = await chatDownloadCacheFiles(
      await getTemporaryDirectory(),
      namespace: serverNamespace(_api.dio.options.baseUrl),
    );
    var bytes = 0;
    for (final file in files) {
      try {
        bytes += await file.length();
      } on FileSystemException {
        // A concurrent cleanup can remove a cache entry between listing/stat.
      }
    }
    return DownloadCacheStats(fileCount: files.length, totalBytes: bytes);
  }

  Future<ServerFileUsage> serverFileUsage() async {
    final usage = (await _api.getFilesApi().filesUsage()).data;
    if (usage == null) throw StateError('服务器未返回存储用量');
    final used = int.tryParse(usage.usedBytes);
    final quota = int.tryParse(usage.quotaBytes);
    final remaining = int.tryParse(usage.remainingBytes);
    if (used == null ||
        quota == null ||
        remaining == null ||
        used < 0 ||
        quota <= 0 ||
        remaining < 0 ||
        usage.fileCount < 0) {
      throw StateError('服务器返回的存储用量无效');
    }
    return ServerFileUsage(
      usedBytes: used,
      quotaBytes: quota,
      remainingBytes: remaining,
      fileCount: usage.fileCount,
    );
  }

  Future<void> clearDownloadCache() async {
    if (_activeDownloads > 0) throw StateError('有文件正在下载，请稍后再清理');
    final files = await chatDownloadCacheFiles(
      await getTemporaryDirectory(),
      namespace: serverNamespace(_api.dio.options.baseUrl),
    );
    for (final file in files) {
      try {
        await file.delete();
      } on FileSystemException {
        // Best effort: another operation may already have removed the entry.
      }
    }
  }

  Future<String> forwardFile({
    required String fileId,
    required String channelId,
    required int channelType,
  }) async {
    final response = await _api.getFilesApi().filesForward(
      fileId: fileId,
      forwardFileDto: ForwardFileDto(
        (builder) => builder
          ..scope = channelType == 2
              ? ForwardFileDtoScopeEnum.GROUP
              : ForwardFileDtoScopeEnum.DIRECT
          ..scopeId = channelId,
      ),
    );
    final forwarded = response.data;
    if (forwarded == null || forwarded.id.isEmpty) {
      throw StateError('服务器未返回转发文件 ID');
    }
    return forwarded.id;
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

Future<bool> cachedDownloadIsValid(File file, {int? expectedSize}) async {
  if (!await file.exists()) return false;
  final actualSize = await file.length();
  if (actualSize <= 0) return false;
  return expectedSize == null ||
      expectedSize <= 0 ||
      actualSize == expectedSize;
}

Future<void> markCachedDownloadAccessed(File file, {DateTime? now}) async {
  try {
    await file.setLastModified(now ?? DateTime.now());
  } on FileSystemException {
    // Cache metadata is optional; a readable cached file should still open.
  }
}

Future<List<File>> chatDownloadCacheFiles(
  Directory directory, {
  required String namespace,
}) async {
  if (!await directory.exists()) return [];
  final prefix = '${namespace}_';
  final files = <File>[];
  await for (final entity in directory.list(followLinks: false)) {
    if (entity is File &&
        entity.path.split(Platform.pathSeparator).last.startsWith(prefix)) {
      files.add(entity);
    }
  }
  return files;
}

Future<int> pruneChatDownloadCache(
  Directory directory, {
  required String namespace,
  Set<String> preservedPaths = const {},
  int maxBytes = 256 * 1024 * 1024,
  Duration maxAge = const Duration(days: 30),
  DateTime? now,
}) async {
  if (!await directory.exists()) return 0;
  final cutoff = (now ?? DateTime.now()).subtract(maxAge);
  final prefix = '${namespace}_';
  final candidates = <({File file, int size, DateTime modified})>[];
  var deleted = 0;

  await for (final entity in directory.list(followLinks: false)) {
    if (entity is! File ||
        !entity.path.split(Platform.pathSeparator).last.startsWith(prefix) ||
        preservedPaths.contains(entity.path)) {
      continue;
    }
    try {
      final stat = await entity.stat();
      if (entity.path.endsWith('.part') || stat.modified.isBefore(cutoff)) {
        await entity.delete();
        deleted++;
      } else {
        candidates.add((
          file: entity,
          size: stat.size,
          modified: stat.modified,
        ));
      }
    } on FileSystemException {
      // Cache cleanup is best effort and must never block opening a file.
    }
  }

  candidates.sort((a, b) => b.modified.compareTo(a.modified));
  var retainedBytes = 0;
  for (final candidate in candidates) {
    retainedBytes += candidate.size;
    if (retainedBytes <= maxBytes) continue;
    try {
      await candidate.file.delete();
      deleted++;
    } on FileSystemException {
      // A file may be opened or removed concurrently; leave it for next pass.
    }
  }
  return deleted;
}
