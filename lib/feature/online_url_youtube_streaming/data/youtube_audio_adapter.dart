import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
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
    String videoId, {
    bool alternateClient = false,
  }) async {
    if (const bool.fromEnvironment('ONLINE_AUDIO_NATIVE_EXPERIMENT')) {
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
    }
    final client = YoutubeExplode();
    OnlineAudioLog.event(
      'resolve.start',
      'id=$videoId client=${alternateClient ? 'tv' : 'default'}',
    );
    try {
      final video = await client.videos.get(videoId);
      OnlineAudioLog.event(
        'resolve.metadata',
        'id=$videoId duration=${video.duration?.inSeconds}s',
      );
      final manifest = await client.videos.streams.getManifest(
        videoId,
        ytClients: alternateClient ? [YoutubeApiClient.tv] : null,
      );
      OnlineAudioLog.event(
        'resolve.manifest',
        'id=$videoId audioOnly=${manifest.audioOnly.length}',
      );
      if (manifest.audioOnly.isEmpty) {
        throw StateError('Không có luồng audio cho video này');
      }
      final stream = manifest.audioOnly.reduce(
        (current, candidate) => candidate.bitrate.compareTo(current.bitrate) > 0
            ? candidate
            : current,
      );
      OnlineAudioLog.event(
        'resolve.selected',
        'id=$videoId client=${alternateClient ? 'tv' : 'default'} '
            'tag=${stream.tag} bitrate=${stream.bitrate.bitsPerSecond}',
      );
      // A probe may consume a one-use stream token. Enable only for diagnosis.
      if (kDebugMode && const bool.fromEnvironment('ONLINE_AUDIO_PROBE')) {
        await _diagnoseFirstRequest(
          stream.url,
          YoutubeHttpClient.defaultHeaders,
          videoId: videoId,
          tag: stream.tag,
        );
      }
      return ResolvedYoutubeAudio(
        videoId: videoId,
        title: video.title,
        artist: video.author,
        duration: video.duration,
        uri: stream.url,
        headers: YoutubeHttpClient.defaultHeaders,
      );
    } catch (error) {
      OnlineAudioLog.error('resolve.failed id=$videoId', error);
      rethrow;
    } finally {
      client.close();
    }
  }

  Future<void> _diagnoseFirstRequest(
    Uri uri,
    Map<String, String> headers, {
    required String videoId,
    required int tag,
  }) async {
    final started = DateTime.now();
    final expiry = int.tryParse(uri.queryParameters['expire'] ?? '');
    OnlineAudioLog.event(
      'probe.start',
      'id=$videoId tag=$tag type=${uri.queryParameters['mime'] ?? 'unknown'} '
          'expiresInSec=${expiry == null ? 'unknown' : expiry - started.millisecondsSinceEpoch ~/ 1000} '
          'headers=${headers.keys.join(',')}',
    );
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      final request = await client.getUrl(uri);
      headers.forEach(request.headers.set);
      request.headers.set(HttpHeaders.rangeHeader, 'bytes=0-0');
      final response = await request.close();
      OnlineAudioLog.event(
        'probe.response',
        'id=$videoId tag=$tag status=${response.statusCode} '
            'elapsedMs=${DateTime.now().difference(started).inMilliseconds}',
      );
      await response.listen((_) {}).cancel();
    } catch (error) {
      OnlineAudioLog.error('probe.failed id=$videoId tag=$tag', error);
    } finally {
      client.close(force: true);
    }
  }
}
