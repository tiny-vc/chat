package com.chatapp.flutter_chat

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.webkit.MimeTypeMap
import android.media.MediaMetadataRetriever
import java.io.ByteArrayOutputStream
import androidx.core.content.FileProvider
import androidx.media3.common.MediaItem
import androidx.media3.common.MimeTypes
import androidx.media3.transformer.Composition
import androidx.media3.transformer.EditedMediaItem
import androidx.media3.transformer.ExportException
import androidx.media3.transformer.ExportResult
import androidx.media3.transformer.Transformer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "chat/call_lifecycle")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "start" -> {
                        val intent = Intent(this, CallForegroundService::class.java)
                        intent.putExtra("video", call.argument<Boolean>("video") == true)
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(intent)
                        } else {
                            startService(intent)
                        }
                        result.success(null)
                    }
                    "stop" -> {
                        stopService(Intent(this, CallForegroundService::class.java))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "chat/file_opener")
            .setMethodCallHandler { call, result ->
                if (call.method != "open") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val path = call.argument<String>("path")
                if (path.isNullOrBlank()) {
                    result.error("invalid_path", "文件路径为空", null)
                    return@setMethodCallHandler
                }
                try {
                    val file = File(path).canonicalFile
                    val allowedRoots = listOfNotNull(
                        cacheDir,
                        filesDir,
                        externalCacheDir,
                        getExternalFilesDir(null),
                    ).map { it.canonicalFile }
                    if (!file.isFile || allowedRoots.none { file.toPath().startsWith(it.toPath()) }) {
                        result.error("invalid_path", "文件不存在或不在应用目录中", null)
                        return@setMethodCallHandler
                    }
                    val uri: Uri = FileProvider.getUriForFile(
                        this,
                        "$packageName.fileprovider",
                        file,
                    )
                    val extension = file.extension.lowercase()
                    val mime = MimeTypeMap.getSingleton()
                        .getMimeTypeFromExtension(extension) ?: "application/octet-stream"
                    val intent = Intent(Intent.ACTION_VIEW).apply {
                        setDataAndType(uri, mime)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                    startActivity(Intent.createChooser(intent, "打开文件"))
                    result.success(null)
                } catch (error: Exception) {
                    result.error("open_failed", "没有可打开此文件的应用", error.message)
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "chat/video_thumbnail")
            .setMethodCallHandler { call, result ->
                if (call.method != "create") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val path = call.argument<String>("path")
                if (path.isNullOrBlank()) {
                    result.error("invalid_path", "视频路径为空", null)
                    return@setMethodCallHandler
                }
                Thread {
                    val retriever = MediaMetadataRetriever()
                    try {
                        retriever.setDataSource(path)
                        val frame = retriever.getFrameAtTime(0, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)
                            ?: throw IllegalStateException("No video frame")
                        val output = ByteArrayOutputStream()
                        frame.compress(android.graphics.Bitmap.CompressFormat.JPEG, 72, output)
                        frame.recycle()
                        runOnUiThread { result.success(output.toByteArray()) }
                    } catch (error: Exception) {
                        runOnUiThread {
                            result.error("thumbnail_failed", "无法生成视频封面", error.message)
                        }
                    } finally {
                        retriever.release()
                    }
                }.start()
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "chat/video_transcoder")
            .setMethodCallHandler { call, result ->
                if (call.method != "transcode") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val path = call.argument<String>("path")
                if (path.isNullOrBlank() || !File(path).isFile) {
                    result.error("invalid_path", "视频文件不存在", null)
                    return@setMethodCallHandler
                }
                val output = File(cacheDir, "chat_video_${System.nanoTime()}.mp4")
                val transformer = Transformer.Builder(this)
                    .setVideoMimeType(MimeTypes.VIDEO_H264)
                    .setAudioMimeType(MimeTypes.AUDIO_AAC)
                    .addListener(object : Transformer.Listener {
                        override fun onCompleted(composition: Composition, exportResult: ExportResult) {
                            result.success(output.absolutePath)
                        }

                        override fun onError(
                            composition: Composition,
                            exportResult: ExportResult,
                            exportException: ExportException,
                        ) {
                            output.delete()
                            result.error("transcode_failed", "无法转换视频", exportException.message)
                        }
                    })
                    .build()
                transformer.start(
                    EditedMediaItem.Builder(MediaItem.fromUri(Uri.fromFile(File(path)))).build(),
                    output.absolutePath,
                )
            }
    }
}
