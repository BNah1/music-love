import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/online_audio_log.dart';

/// Owns only the online one-item queue. The coordinator publishes active media
/// to the system; this handler never initializes a second AudioService.
class OnlineAudioHandler extends BaseAudioHandler with SeekHandler {
  OnlineAudioHandler({required this.onBeforePlay}) {
    _events = _player.playbackEventStream.listen((_) => _publish());
    _errors = _player.errorStream.listen((error) {
      OnlineAudioLog.error('player.streamError', error);
      playbackState.add(
        playbackState.value.copyWith(
          processingState: AudioProcessingState.error,
          errorMessage: error.message,
          playing: false,
        ),
      );
    });
  }

  final Future<void> Function() onBeforePlay;
  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<PlaybackEvent> _events;
  late final StreamSubscription<PlayerException> _errors;
  ProcessingState? _lastProcessingState;
  bool? _lastPlaying;
  bool _resettingCompletion = false;

  Future<void> load({
    required Uri uri,
    required Map<String, String> headers,
    required MediaItem item,
    Duration position = Duration.zero,
  }) async {
    OnlineAudioLog.event(
      'player.load',
      'id=${item.id} positionMs=${position.inMilliseconds}',
    );
    await onBeforePlay();
    queue.add([item]);
    mediaItem.add(item);
    try {
      await _player.setAudioSource(
        AudioSource.uri(uri, headers: headers, tag: item),
        initialPosition: position,
      );
      OnlineAudioLog.event('player.sourceReady', 'id=${item.id}');
      unawaited(play().catchError(_onPlayError));
    } catch (error) {
      OnlineAudioLog.error('player.loadFailed id=${item.id}', error);
      playbackState.add(
        playbackState.value.copyWith(
          playing: false,
          processingState: AudioProcessingState.error,
          errorMessage: error.toString(),
        ),
      );
      mediaItem.add(null);
      queue.add([]);
      rethrow;
    }
  }

  void _publish() {
    final state = _player.processingState;
    final playing = _player.playing && state != ProcessingState.completed;
    if (state != _lastProcessingState || _player.playing != _lastPlaying) {
      OnlineAudioLog.event(
        'player.state',
        'state=$state playing=${_player.playing} positionMs=${_player.position.inMilliseconds}',
      );
      _lastProcessingState = state;
      _lastPlaying = _player.playing;
    }
    playbackState.add(
      PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          playing ? MediaControl.pause : MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        systemActions: const {MediaAction.seek},
        processingState: switch (state) {
          ProcessingState.idle => AudioProcessingState.idle,
          ProcessingState.loading => AudioProcessingState.loading,
          ProcessingState.buffering => AudioProcessingState.buffering,
          ProcessingState.ready => AudioProcessingState.ready,
          ProcessingState.completed => AudioProcessingState.completed,
        },
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: 0,
      ),
    );
    if (state == ProcessingState.completed && !_resettingCompletion) {
      unawaited(_resetCompletedPlayback());
    }
  }

  Future<void> _resetCompletedPlayback() async {
    _resettingCompletion = true;
    try {
      await _player.pause();
      await _player.seek(Duration.zero);
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            MediaControl.play,
            MediaControl.stop,
            MediaControl.skipToNext,
          ],
          playing: false,
          processingState: AudioProcessingState.ready,
          updatePosition: Duration.zero,
        ),
      );
    } finally {
      _resettingCompletion = false;
    }
  }

  void _onPlayError(Object error) {
    OnlineAudioLog.error('player.playFailed', error);
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.error,
        errorMessage: error.toString(),
      ),
    );
  }

  @override
  Future<void> play() async {
    await onBeforePlay();
    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() async {}

  @override
  Future<void> skipToPrevious() => seek(Duration.zero);

  Future<void> disposePlayer() async {
    await _events.cancel();
    await _errors.cancel();
    await _player.dispose();
  }
}
