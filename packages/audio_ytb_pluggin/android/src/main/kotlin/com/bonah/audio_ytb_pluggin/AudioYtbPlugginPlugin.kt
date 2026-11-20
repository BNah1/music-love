package com.bonah.audio_ytb_pluggin

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.RequestBody.Companion.toRequestBody
import org.schabi.newpipe.extractor.NewPipe
import org.schabi.newpipe.extractor.ServiceList
import org.schabi.newpipe.extractor.downloader.Downloader
import org.schabi.newpipe.extractor.downloader.Request
import org.schabi.newpipe.extractor.downloader.Response
import org.schabi.newpipe.extractor.stream.StreamInfo
import java.util.concurrent.Executors

class AudioYtbPlugginPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val worker = Executors.newSingleThreadExecutor()
    private val http = OkHttpClient()

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "audio_ytb_pluggin")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method != "resolve") { result.notImplemented(); return }
        val url = call.argument<String>("url")
        if (url.isNullOrBlank()) { result.error("invalid_url", "URL is empty", null); return }
        worker.execute {
            try {
                synchronized(NewPipe::class.java) {
                    NewPipe.init(object : Downloader() {
                        override fun execute(request: Request): Response {
                            val builder = okhttp3.Request.Builder().url(request.url())
                            request.headers().forEach { (name, values) -> values.forEach { builder.addHeader(name, it) } }
                            val bytes = request.dataToSend()
                            val body = if (bytes != null) bytes.toRequestBody("application/json".toMediaTypeOrNull()) else null
                            builder.method(request.httpMethod(), body)
                            http.newCall(builder.build()).execute().use { response ->
                                return Response(
                                    response.code, response.message,
                                    response.headers.toMultimap(), response.body?.string() ?: "",
                                    response.request.url.toString()
                                )
                            }
                        }
                    })
                }
                val info = StreamInfo.getInfo(ServiceList.YouTube, url)
                val streams = info.audioStreams
                val chosen = streams.maxByOrNull { it.averageBitrate }
                    ?: throw IllegalStateException("No audio stream available")
                val data = mapOf(
                    "title" to info.name,
                    "artist" to info.uploaderName,
                    "url" to chosen.url,
                    "durationSeconds" to info.duration,
                    "streamCount" to streams.size
                )
                android.os.Handler(android.os.Looper.getMainLooper()).post { result.success(data) }
            } catch (error: Exception) {
                android.os.Handler(android.os.Looper.getMainLooper()).post {
                    result.error("resolve_failed", error.javaClass.simpleName, null)
                }
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        worker.shutdownNow()
    }
}
