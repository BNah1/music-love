import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:musiclove/core/audio/music_audio_handler.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/audio/online_audio_handler.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/online_audio_log.dart';

enum PlaybackSource { offline, online }

/// The only handler registered with the OS. Each feature retains its own
/// queue and player; media buttons target whichever source is active.
class CoordinatedAudioHandler extends BaseAudioHandler
    with QueueHandler, SeekHandler {
  CoordinatedAudioHandler() {
    offline = MusicAudioHandler(onBeforePlay: activateOffline);
    online = OnlineAudioHandler(onBeforePlay: activateOnline);
    _subscriptions.addAll([
      offline.mediaItem.listen((item) {
        if (activeSource == PlaybackSource.offline) mediaItem.add(item);
      }),
      offline.queue.listen((items) {
        if (activeSource == PlaybackSource.offline) queue.add(items);
      }),
      offline.playbackState.listen((state) {
        if (activeSource == PlaybackSource.offline) playbackState.add(state);
      }),
      online.mediaItem.listen((item) {
        if (activeSource == PlaybackSource.online) mediaItem.add(item);
      }),
      online.queue.listen((items) {
        if (activeSource == PlaybackSource.online) queue.add(items);
      }),
      online.playbackState.listen((state) {
        if (activeSource == PlaybackSource.online) playbackState.add(state);
      }),
    ]);
  }

  late final MusicAudioHandler offline;
  late final OnlineAudioHandler online;
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  PlaybackSource activeSource = PlaybackSource.offline;

  Future<void> activateOffline() async {
    if (activeSource == PlaybackSource.offline) return;
    OnlineAudioLog.event('source.switch', 'online -> offline');
    await online.pause();
    activeSource = PlaybackSource.offline;
    _publish(offline);
  }

  Future<void> activateOnline() async {
    if (activeSource == PlaybackSource.online) return;
    OnlineAudioLog.event('source.switch', 'offline -> online');
    await offline.pause();
    activeSource = PlaybackSource.online;
    _publish(online);
  }

  void _publish(AudioHandler handler) {
    mediaItem.add(handler.mediaItem.valueOrNull);
    queue.add(handler.queue.value);
    playbackState.add(handler.playbackState.value);
  }

  AudioHandler get _active =>
      activeSource == PlaybackSource.online ? online : offline;

  @override
  Future<void> play() => _active.play();
  @override
  Future<void> pause() => _active.pause();
  @override
  Future<void> seek(Duration position) => _active.seek(position);
  @override
  Future<void> skipToNext() => _active.skipToNext();
  @override
  Future<void> skipToPrevious() => _active.skipToPrevious();
  @override
  Future<void> stop() => _active.stop();
}
