import 'dart:io';
import 'package:audio_ytb_pluggin/audio_ytb_pluggin.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/online_audio_log.dart';

class ResolvedYoutubeAudio {
  const ResolvedYoutubeAudio({
    required this.videoId,
    required this.title,
    required this.artist,
    required this.duration,
    required this.uri,
    required this.headers,
  });

  final String videoId;
  final String title;
  final String artist;
  final Duration? duration;
  final Uri uri;
  final Map<String, String> headers;
}

/// Keeps all source-specific parsing in one place. Returned URIs are ephemeral.
class YoutubeAudioAdapter {
  Future<ResolvedYoutubeAudio> resolve(
    String videoId,
  ) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('YouTube audio hiện chỉ hỗ trợ Android');
    }
    OnlineAudioLog.event('resolve.native.start', 'id=$videoId');
    try {
      final source = await AudioYtbPluggin().resolve(
        'https://www.youtube.com/watch?v=$videoId',
      );
      OnlineAudioLog.event(
        'resolve.native',
        'id=$videoId audioOnly=${source.streamCount}',
      );
      return ResolvedYoutubeAudio(
        videoId: videoId,
        title: source.title,
        artist: source.artist,
        duration: Duration(seconds: source.durationSeconds),
        uri: source.url,
        headers: const {},
      );
    } catch (error) {
      OnlineAudioLog.error('resolve.native.failed id=$videoId', error);
      rethrow;
    }
  }
}
