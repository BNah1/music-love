import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';

class MusicAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  AudioServiceShuffleMode _shuffleMode = AudioServiceShuffleMode.none;
  AudioServiceRepeatMode _repeatMode = AudioServiceRepeatMode.none;

  Timer? _cacheTimer;

  MusicAudioHandler() {
    _listenPlaybackState();
    _listenCurrentIndex();
    _listenPositionCache();
  }

  void _listenPlaybackState() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        PlaybackState(
          controls: [
            MediaControl.skipToPrevious,
            _player.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },
          androidCompactActionIndices: const [0, 1, 2],
          processingState: _mapProcessingState(_player.processingState),
          playing: _player.playing,
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
          speed: _player.speed,
          queueIndex: _player.currentIndex,
          shuffleMode: _shuffleMode,
          repeatMode: _repeatMode,
        ),
      );
    });
  }

  void _listenCurrentIndex() {
    _player.currentIndexStream.listen((index) {
      final currentQueue = queue.value;

      if (index == null) return;
      if (index < 0) return;
      if (index >= currentQueue.length) return;

      mediaItem.add(currentQueue[index]);
      _saveLastSession();
    });
  }

  void _listenPositionCache() {
    _cacheTimer?.cancel();

    _cacheTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) {
        _saveLastSession();
      },
    );
  }

  AudioProcessingState _mapProcessingState(ProcessingState state) {
    switch (state) {
      case ProcessingState.idle:
        return AudioProcessingState.idle;

      case ProcessingState.loading:
        return AudioProcessingState.loading;

      case ProcessingState.buffering:
        return AudioProcessingState.buffering;

      case ProcessingState.ready:
        return AudioProcessingState.ready;

      case ProcessingState.completed:
        return AudioProcessingState.completed;
    }
  }

  Future<void> removeSongFromQueue(String songId) async {
    final currentQueue = [...queue.value];

    final removeIndex = currentQueue.indexWhere((item) => item.id == songId);
    if (removeIndex < 0) return;

    final currentIndex = _player.currentIndex ?? 0;
    final isRemovingCurrentSong = currentIndex == removeIndex;

    currentQueue.removeAt(removeIndex);

    queue.add(currentQueue);

    if (currentQueue.isEmpty) {
      await stop();
      mediaItem.add(null);
      return;
    }

    final sources = currentQueue.map((item) {
      final path = item.extras?['path'] as String;

      return AudioSource.uri(
        Uri.file(path),
        tag: item,
      );
    }).toList();

    int nextIndex = currentIndex;

    if (removeIndex < currentIndex) {
      nextIndex = currentIndex - 1;
    }

    if (nextIndex >= currentQueue.length) {
      nextIndex = currentQueue.length - 1;
    }

    final currentPosition = isRemovingCurrentSong ? Duration.zero : _player.position;

    await _player.setAudioSources(
      sources,
      initialIndex: nextIndex,
      initialPosition: currentPosition,
    );

    mediaItem.add(currentQueue[nextIndex]);

    if (playbackState.value.playing) {
      await play();
    }

    await _saveLastSession();
  }

  Future<void> setQueueAndPlay({
    required List<MediaItem> items,
    required int startIndex,
    Duration position = Duration.zero,
  }) async {
    if (items.isEmpty) return;

    final safeStartIndex = startIndex < 0 || startIndex >= items.length
        ? 0
        : startIndex;

    queue.add(items);

    final sources = items.map((item) {
      final path = item.extras?['path'] as String;

      return AudioSource.uri(
        Uri.file(path),
        tag: item,
      );
    }).toList();

    mediaItem.add(items[safeStartIndex]);

    unawaited(
      _player
          .setAudioSources(
        sources,
        initialIndex: safeStartIndex,
        initialPosition: position,
      )
          .then((_) {
            play();
      }).catchError((error) {
        playbackState.add(
          playbackState.value.copyWith(
            processingState: AudioProcessingState.error,
            errorMessage: error.toString(),
          ),
        );
      }),
    );
  }

  @override
  Future<void> play() async {
    await _player.play();
    await _saveLastSession();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    await _saveLastSession();
  }

  @override
  Future<void> stop() async {
    await _saveLastSession();

    await _player.stop();

    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );

    return super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    await _saveLastSession();
  }

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext) {
      await _player.seekToNext();
    } else {
      if (_repeatMode == AudioServiceRepeatMode.all && queue.value.isNotEmpty) {
        await _player.seek(Duration.zero, index: 0);
      }
    }

    await _saveLastSession();
  }

  @override
  Future<void> skipToPrevious() async {
    final currentPosition = _player.position;

    // Nếu đang nghe quá 3 giây, bấm previous thì quay về đầu bài hiện tại.
    if (currentPosition.inSeconds > 3) {
      await _player.seek(Duration.zero);
      await _saveLastSession();
      return;
    }

    if (_player.hasPrevious) {
      await _player.seekToPrevious();
    } else {
      if (_repeatMode == AudioServiceRepeatMode.all && queue.value.isNotEmpty) {
        await _player.seek(Duration.zero, index: queue.value.length - 1);
      } else {
        await _player.seek(Duration.zero);
      }
    }

    await _saveLastSession();
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    _shuffleMode = shuffleMode;

    final enabled = shuffleMode != AudioServiceShuffleMode.none;

    await _player.setShuffleModeEnabled(enabled);

    if (enabled) {
      await _player.shuffle();
    }

    playbackState.add(
      playbackState.value.copyWith(
        shuffleMode: _shuffleMode,
      ),
    );

    await _saveLastSession();
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    _repeatMode = repeatMode;

    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        await _player.setLoopMode(LoopMode.off);
        break;

      case AudioServiceRepeatMode.one:
        await _player.setLoopMode(LoopMode.one);
        break;

      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        await _player.setLoopMode(LoopMode.all);
        break;
    }

    playbackState.add(
      playbackState.value.copyWith(
        repeatMode: _repeatMode,
      ),
    );

    await _saveLastSession();
  }

  Future<void> _saveLastSession() async {
    final current = mediaItem.valueOrNull;
    if (current == null) return;

    final box = Hive.box('player_cache');

    await box.put(
      'last_session',
      {
        'songId': current.id,
        'queueIds': queue.value.map((e) => e.id).toList(),
        'currentIndex': _player.currentIndex ?? 0,
        'positionMs': _player.position.inMilliseconds,
        'isPlaying': _player.playing,
        'shuffleMode': _shuffleMode.name,
        'repeatMode': _repeatMode.name,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<Map?> getLastSession() async {
    final box = Hive.box('player_cache');
    return box.get('last_session') as Map?;
  }
}