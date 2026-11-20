import 'package:flutter/services.dart';

class YtbAudioSource {
  const YtbAudioSource({required this.title, required this.artist, required this.url, required this.durationSeconds, required this.streamCount});
  final String title;
  final String artist;
  final Uri url;
  final int durationSeconds;
  final int streamCount;
}

class AudioYtbPluggin {
  static const _channel = MethodChannel('audio_ytb_pluggin');

  Future<YtbAudioSource> resolve(String videoUrl) async {
    final result = await _channel.invokeMapMethod<String, Object?>('resolve', {'url': videoUrl});
    if (result == null) throw StateError('No audio source returned');
    return YtbAudioSource(
      title: result['title'] as String,
      artist: result['artist'] as String,
      url: Uri.parse(result['url'] as String),
      durationSeconds: (result['durationSeconds'] as num).toInt(),
      streamCount: (result['streamCount'] as num).toInt(),
    );
  }
}
