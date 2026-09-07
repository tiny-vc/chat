package com.chatapp.flutter_chat

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
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
    }
}
