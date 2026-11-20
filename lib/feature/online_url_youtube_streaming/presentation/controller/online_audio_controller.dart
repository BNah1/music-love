import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:musiclove/core/constant/app_config.dart';
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

class OnlineHistoryItem {
  const OnlineHistoryItem({
    required this.videoId,
    required this.title,
    required this.artist,
    required this.duration,
  });
  final String videoId, title, artist;
  final Duration duration;
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
    this.history = const [],
  });

  final OnlineAudioStatus status;
  final String? videoId;
  final String? title;
  final String? artist;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final String? error;
  final List<OnlineHistoryItem> history;
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
    : super(OnlineAudioState(history: _readHistory())) {
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

  static List<OnlineHistoryItem> _readHistory() {
    final box = Hive.box(AppConfig.boxOnlineHistory);
    return box.values
        .whereType<Map>()
        .map(
          (entry) => OnlineHistoryItem(
            videoId: entry['videoId'] as String,
            title: entry['title'] as String,
            artist: entry['artist'] as String,
            duration: Duration(seconds: entry['duration'] as int),
          ),
        )
        .toList()
        .reversed
        .toList();
  }

  Future<void> playHistory(OnlineHistoryItem item) => _load(item.videoId);

  Future<void> submitUrl(String url) async {
    final parsed = YoutubeVideoUrl.parse(url);
    if (parsed == null) {
      OnlineAudioLog.event('input.invalid');
      state = OnlineAudioState(
        status: OnlineAudioStatus.invalidUrl,
        history: state.history,
      );
      return;
    }
    _retriedCurrentSource = false;
    OnlineAudioLog.event('input.accepted', 'id=${parsed.videoId}');
    await _load(parsed.videoId);
  }

  Future<void> _load(
    String videoId, {
    Duration position = Duration.zero,
  }) async {
    final request = ++_request;
    OnlineAudioLog.event(
      'load.start',
      'id=$videoId request=$request positionMs=${position.inMilliseconds}',
    );
    state = OnlineAudioState(
      status: OnlineAudioStatus.loading,
      videoId: videoId,
      position: position,
      history: state.history,
    );
    try {
      final result = await adapter.resolve(videoId);
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
        history: state.history,
      );
      try {
        final box = Hive.box(AppConfig.boxOnlineHistory);
        await box.delete(videoId);
        await box.put(videoId, {
          'videoId': videoId,
          'title': result.title,
          'artist': result.artist,
          'duration': (result.duration ?? Duration.zero).inSeconds,
        });
        if (mounted && request == _request) {
          state = _copy(history: _readHistory());
        }
      } catch (error) {
        OnlineAudioLog.error('history.saveFailed id=$videoId', error);
      }
    } catch (error) {
      OnlineAudioLog.error('load.failed id=$videoId request=$request', error);
      if (!mounted || request != _request) return;
      state = OnlineAudioState(
        status: OnlineAudioStatus.error,
        videoId: videoId,
        error: error.toString(),
        history: state.history,
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
          _load(id, position: position).whenComplete(() {
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
    List<OnlineHistoryItem>? history,
  }) => OnlineAudioState(
    status: status ?? state.status,
    videoId: state.videoId,
    title: state.title,
    artist: state.artist,
    duration: state.duration,
    position: position ?? state.position,
    isPlaying: isPlaying ?? state.isPlaying,
    error: error ?? state.error,
    history: history ?? state.history,
  );

  @override
  void dispose() {
    _request++;
    _subscription.cancel();
    _positionTimer.cancel();
    super.dispose();
  }
}
