import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/audio/coordinated_audio_handler.dart';
import 'package:musiclove/core/provider/audio_handler_provider.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/data/youtube_audio_adapter.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/data/youtube_video_url.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/online_audio_log.dart';

enum OnlineAudioStatus {
  empty,
  invalidUrl,
  awaitingSource,
  loading,
  ready,
  error,
}

class OnlineAudioState {
  const OnlineAudioState({
    this.status = OnlineAudioStatus.empty,
    this.videoId,
    this.title,
    this.artist,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.error,
  });

  final OnlineAudioStatus status;
  final String? videoId;
  final String? title;
  final String? artist;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final String? error;
}

final onlineAudioControllerProvider =
    StateNotifierProvider<OnlineAudioController, OnlineAudioState>(
      (ref) => OnlineAudioController(
        handler: ref.read(coordinatedAudioHandlerProvider),
        adapter: YoutubeAudioAdapter(),
      ),
    );

class OnlineAudioController extends StateNotifier<OnlineAudioState> {
  OnlineAudioController({required this.handler, required this.adapter})
    : super(const OnlineAudioState()) {
    _subscription = handler.online.playbackState.listen(_onPlaybackState);
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.status == OnlineAudioStatus.ready) {
        state = _copy(position: handler.online.playbackState.value.position);
      }
    });
  }

  final CoordinatedAudioHandler handler;
  final YoutubeAudioAdapter adapter;
  late final StreamSubscription<PlaybackState> _subscription;
  late final Timer _positionTimer;
  int _request = 0;
  bool _refreshing = false;
  bool _retriedCurrentSource = false;

  Future<void> submitUrl(String url) async {
    final parsed = YoutubeVideoUrl.parse(url);
    if (parsed == null) {
      OnlineAudioLog.event('input.invalid');
      state = const OnlineAudioState(status: OnlineAudioStatus.invalidUrl);
      return;
    }
    _retriedCurrentSource = false;
    OnlineAudioLog.event('input.accepted', 'id=${parsed.videoId}');
    await _load(parsed.videoId);
  }

  Future<void> _load(
    String videoId, {
    Duration position = Duration.zero,
    bool alternateClient = false,
  }) async {
    final request = ++_request;
    OnlineAudioLog.event(
      'load.start',
      'id=$videoId request=$request positionMs=${position.inMilliseconds} '
          'client=${alternateClient ? 'tv' : 'default'}',
    );
    state = OnlineAudioState(
      status: OnlineAudioStatus.loading,
      videoId: videoId,
      position: position,
    );
    try {
      final result = await adapter.resolve(
        videoId,
        alternateClient: alternateClient,
      );
      if (!mounted || request != _request) {
        OnlineAudioLog.event('load.stale', 'request=$request');
        return;
      }
      final item = MediaItem(
        id: videoId,
        title: result.title,
        artist: result.artist,
        duration: result.duration,
        extras: const {'source': 'online'},
      );
      await handler.online.load(
        uri: result.uri,
        headers: result.headers,
        item: item,
        position: position,
      );
      OnlineAudioLog.event('load.playerReady', 'id=$videoId request=$request');
      if (!mounted || request != _request) return;
      state = OnlineAudioState(
        status: OnlineAudioStatus.ready,
        videoId: videoId,
        title: result.title,
        artist: result.artist,
        duration: result.duration ?? Duration.zero,
        position: position,
        isPlaying: true,
      );
    } catch (error) {
      OnlineAudioLog.error('load.failed id=$videoId request=$request', error);
      if (!mounted || request != _request) return;
      if (!alternateClient && !_retriedCurrentSource) {
        _retriedCurrentSource = true;
        OnlineAudioLog.event('load.retry', 'id=$videoId client=tv');
        await _load(videoId, position: position, alternateClient: true);
        return;
      }
      state = OnlineAudioState(
        status: OnlineAudioStatus.error,
        videoId: videoId,
        error: error.toString(),
      );
    }
  }

  void _onPlaybackState(PlaybackState playback) {
    if (!mounted || state.status != OnlineAudioStatus.ready) return;
    if (playback.processingState == AudioProcessingState.error) {
      OnlineAudioLog.event(
        'playback.error',
        'id=${state.videoId} retried=$_retriedCurrentSource',
      );
      if (!_refreshing && !_retriedCurrentSource && state.videoId != null) {
        _refreshing = true;
        _retriedCurrentSource = true;
        final id = state.videoId!;
        final position = playback.position;
        OnlineAudioLog.event(
          'resolve.retry',
          'id=$id positionMs=${position.inMilliseconds}',
        );
        unawaited(
          _load(id, position: position, alternateClient: true).whenComplete(() {
            _refreshing = false;
          }),
        );
      } else if (!_refreshing) {
        state = _copy(
          status: OnlineAudioStatus.error,
          error: playback.errorMessage ?? 'Không phát được audio',
        );
      }
      return;
    }
    state = _copy(isPlaying: playback.playing, position: playback.position);
  }

  Future<void> togglePlayback() async {
    if (state.status != OnlineAudioStatus.ready) return;
    if (state.isPlaying) {
      OnlineAudioLog.event('control.pause', 'id=${state.videoId}');
      await handler.online.pause();
    } else {
      OnlineAudioLog.event('control.play', 'id=${state.videoId}');
      unawaited(
        handler.online.play().catchError((Object error) {
          if (mounted) {
            state = _copy(
              status: OnlineAudioStatus.error,
              error: error.toString(),
              isPlaying: false,
            );
          }
        }),
      );
    }
  }

  Future<void> seek(Duration position) {
    OnlineAudioLog.event(
      'control.seek',
      'id=${state.videoId} positionMs=${position.inMilliseconds}',
    );
    return handler.online.seek(position);
  }

  OnlineAudioState _copy({
    OnlineAudioStatus? status,
    Duration? position,
    bool? isPlaying,
    String? error,
  }) => OnlineAudioState(
    status: status ?? state.status,
    videoId: state.videoId,
    title: state.title,
    artist: state.artist,
    duration: state.duration,
    position: position ?? state.position,
    isPlaying: isPlaying ?? state.isPlaying,
    error: error ?? state.error,
  );

  @override
  void dispose() {
    _request++;
    _subscription.cancel();
    _positionTimer.cancel();
    super.dispose();
  }
}
