import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/library/data/model/mp3_file_model.dart';
import 'package:musiclove/core/provider/audio_handler_provider.dart';
import 'package:musiclove/core/audio/coordinated_audio_handler.dart';
import 'package:musiclove/shared/widget/player_display_widgets.dart';

import '../../../../core/audio/music_audio_handler.dart';

class PlayMusicView extends ConsumerStatefulWidget {
  /// Dùng cho route: /playMusic/:songId
  final String? songId;

  /// Có giá trị khi mở bài từ PlaylistDetailView.
  /// Khi có playlistId, màn này sẽ phát toàn bộ playlist và bắt đầu từ đúng songId.
  final String? playlistId;

  /// Giữ lại để không vỡ route cũ đang truyền extra Mp3FileModel.
  final Mp3FileModel? song;

  const PlayMusicView({super.key, this.songId, this.playlistId, this.song})
    : assert(
        songId != null || song != null,
        'PlayMusicView cần songId hoặc song',
      );

  @override
  ConsumerState<PlayMusicView> createState() => _PlayMusicViewState();
}

class _PlayMusicViewState extends ConsumerState<PlayMusicView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  Mp3FileModel? _song;
  bool _isLoading = true;
  String? _errorMessage;

  bool _isDragging = false;
  double _dragValue = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSongAndPreparePlayer();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSongAndPreparePlayer() async {
    try {
      final song = widget.song ?? _findSongById(widget.songId);

      if (song == null) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _errorMessage = 'Không tìm thấy bài hát';
        });

        return;
      }

      if (!File(song.path).existsSync()) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _errorMessage = 'File nhạc không tồn tại:\n${song.path}';
        });

        return;
      }

      _song = song;

      final audioHandler = ref.read(audioHandlerProvider);
      final currentItem = audioHandler.mediaItem.valueOrNull;

      final queueSongs = _getQueueSongs(startSong: song);
      final startIndex = _findStartIndex(queueSongs, song.id);
      final targetItems = queueSongs.map(_songToMediaItem).toList();

      final currentQueueIds = audioHandler.queue.value
          .map((e) => e.id)
          .toList();
      final targetQueueIds = targetItems.map((e) => e.id).toList();

      final isCurrentSong = currentItem?.id == song.id;
      final isSameQueue = listEquals(currentQueueIds, targetQueueIds);

      final coordinator = ref.read(coordinatedAudioHandlerProvider);

      // Nếu chỉ mở màn hình bài đang phát thì không prepare lại player.
      // Prepare lại queue sẽ làm just_audio setAudioSources() và vị trí phát quay về đầu bài.
      if (!isCurrentSong) {
        if (audioHandler is MusicAudioHandler) {
          if (isSameQueue) {
            // Đang cùng playlist/queue, chỉ nhảy sang index bài được chọn.
            audioHandler.playQueueIndex(index: startIndex);
          } else {
            // Queue khác thật sự thì mới tạo lại queue và phát từ bài được chọn.
            audioHandler.setQueueAndPlay(
              items: targetItems,
              startIndex: startIndex,
            );
          }
        } else {
          audioHandler.playMediaItem(targetItems[startIndex]);
        }
      } else if (coordinator.activeSource == PlaybackSource.online) {
        // Chọn lại bài offline đang giữ trong queue cũng phải chuyển nguồn.
        audioHandler.play();
      }

      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });

      if (!mounted) return;
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = AppString.errorOpenSong.tr(
          namedArgs: {'error': e.toString()},
        );
      });

      if (!mounted) return;
    }
  }

  List<Mp3FileModel> _getQueueSongs({required Mp3FileModel startSong}) {
    final playlistId = widget.playlistId;

    if (playlistId == null || playlistId.isEmpty) {
      return [startSong];
    }

    final playlistSongs = _findSongsByPlaylistId(playlistId);

    if (playlistSongs.isEmpty) {
      return [startSong];
    }

    final hasStartSong = playlistSongs.any((song) => song.id == startSong.id);

    if (!hasStartSong) {
      return [startSong, ...playlistSongs];
    }

    return playlistSongs;
  }

  int _findStartIndex(List<Mp3FileModel> songs, String songId) {
    final index = songs.indexWhere((song) => song.id == songId);

    return index < 0 ? 0 : index;
  }

  List<Mp3FileModel> _findSongsByPlaylistId(String playlistId) {
    try {
      final playlistBox = Hive.box('playlists');
      final songBox = Hive.box('songs');

      final playlistData = playlistBox.get(playlistId);
      if (playlistData == null) return [];
      if (playlistData is! Map) return [];

      final playlistMap = Map<String, dynamic>.from(playlistData);
      final songIds = List<String>.from(playlistMap['songIds'] ?? []);

      return songIds
          .map((id) {
            final data = songBox.get(id);

            if (data == null) return null;
            if (data is! Map) return null;

            return Mp3FileModel.fromMap(Map<String, dynamic>.from(data));
          })
          .whereType<Mp3FileModel>()
          .where((song) => File(song.path).existsSync())
          .toList();
    } catch (_) {
      return [];
    }
  }

  Mp3FileModel? _findSongById(String? songId) {
    if (songId == null || songId.isEmpty) return null;

    try {
      final box = Hive.box('songs');
      final data = box.get(songId);

      if (data == null) return null;

      if (data is Mp3FileModel) {
        return data;
      }

      if (data is Map) {
        return Mp3FileModel.fromMap(Map<String, dynamic>.from(data));
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  MediaItem _songToMediaItem(Mp3FileModel song) {
    return MediaItem(
      id: song.id,
      title: song.title,
      artist: song.artist ?? 'Unknown Artist',
      album: song.album,
      duration: Duration(milliseconds: song.duration),
      artUri: song.artworkPath != null && song.artworkPath!.isNotEmpty
          ? Uri.file(song.artworkPath!)
          : null,
      extras: {
        'path': song.path,
        'album': song.album,
        'artworkPath': song.artworkPath,
        'size': song.size,
        'dateAdded': song.dateAdded,
        'isFavorite': song.isFavorite,
        'playlistId': widget.playlistId,
      },
    );
  }

  Future<void> _togglePlayPause(bool isPlaying) async {
    final audioHandler = ref.read(audioHandlerProvider);

    if (isPlaying) {
      await audioHandler.pause();
    } else {
      await audioHandler.play();
    }
  }

  Future<void> _seekTo(Duration position) async {
    final audioHandler = ref.read(audioHandlerProvider);
    await audioHandler.seek(position);
  }

  Future<void> _skipToPrevious() async {
    final audioHandler = ref.read(audioHandlerProvider);
    await audioHandler.skipToPrevious();
  }

  Future<void> _skipToNext() async {
    final audioHandler = ref.read(audioHandlerProvider);
    await audioHandler.skipToNext();
  }

  Future<void> _toggleShuffle(AudioServiceShuffleMode currentMode) async {
    final audioHandler = ref.read(audioHandlerProvider);

    final nextMode = currentMode == AudioServiceShuffleMode.none
        ? AudioServiceShuffleMode.all
        : AudioServiceShuffleMode.none;

    await audioHandler.setShuffleMode(nextMode);
  }

  Future<void> _toggleRepeat(AudioServiceRepeatMode currentMode) async {
    final audioHandler = ref.read(audioHandlerProvider);

    AudioServiceRepeatMode nextMode;

    switch (currentMode) {
      case AudioServiceRepeatMode.none:
        nextMode = AudioServiceRepeatMode.all;
        break;

      case AudioServiceRepeatMode.all:
        nextMode = AudioServiceRepeatMode.one;
        break;

      case AudioServiceRepeatMode.one:
        nextMode = AudioServiceRepeatMode.none;
        break;

      case AudioServiceRepeatMode.group:
        nextMode = AudioServiceRepeatMode.none;
        break;
    }

    await audioHandler.setRepeatMode(nextMode);
  }

  void _syncRotationAnimation(bool isPlaying) {
    if (isPlaying) {
      if (!_animationController.isAnimating) {
        _animationController.repeat();
      }
    } else {
      if (_animationController.isAnimating) {
        _animationController.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioHandler = ref.watch(audioHandlerProvider);

    final appTheme = AppTheme.extensionOf(context);

    return Scaffold(
      backgroundColor: appTheme.pageBackground,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(widget.songId ?? widget.song?.id ?? '0'),
      body: Container(
        width: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: appTheme.selectedIconColor,
                ),
              )
            : _errorMessage != null
            ? _buildErrorView()
            : StreamBuilder<MediaItem?>(
                stream: audioHandler.mediaItem,
                builder: (context, mediaSnapshot) {
                  final mediaItem = mediaSnapshot.data;
                  final displaySong = _song;

                  return StreamBuilder<PlaybackState>(
                    stream: audioHandler.playbackState,
                    builder: (context, stateSnapshot) {
                      final playbackState = stateSnapshot.data;
                      final isPlaying = playbackState?.playing == true;

                      _syncRotationAnimation(isPlaying);

                      return SafeArea(
                        child: Column(
                          children: [
                            const Spacer(flex: 2),
                            PlayerArtwork(
                              rotation: _animationController,
                              isPlaying: isPlaying,
                              artworkPath:
                                  mediaItem?.artUri?.toFilePath() ??
                                  displaySong?.artworkPath,
                            ),
                            const SizedBox(height: 32),
                            PlayerSongInfo(
                              title:
                                  mediaItem?.title ?? displaySong?.title ?? '',
                              artist:
                                  mediaItem?.artist ??
                                  displaySong?.artist ??
                                  '',
                            ),
                            const Spacer(),
                            _buildProgressBar(
                              duration:
                                  mediaItem?.duration ??
                                  Duration(
                                    milliseconds: displaySong?.duration ?? 0,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            _buildControlPanel(playbackState),
                            const Spacer(),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String songId) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppTheme.extensionOf(context).selectedIconColor,
          size: 35,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text(
        context.tr(AppString.playerNowPlaying),
        style: TextStyle(
          color: AppTheme.extensionOf(context).selectedIconColor,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      actions: [_buildRemove(songId)],
    );
  }

  Widget _buildRemove(String songId) {
    return InkWell(
      onTap: () async {
        final audioHandler = ref.read(audioHandlerProvider);

        if (audioHandler is MusicAudioHandler) {
          await audioHandler.removeSongFromQueue(songId);
        }
      },
      child: Icon(
        Icons.remove_circle_outline,
        color: AppTheme.extensionOf(context).selectedIconColor,
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    final appTheme = AppTheme.extensionOf(context);

    return BoxDecoration(gradient: appTheme.navIndicatorGradient);
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppTheme.extensionOf(context).selectedIconColor,
              size: 56,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? context.tr(AppString.homeError),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.extensionOf(context).selectedIconColor,
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.tr(AppString.playerBack)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar({required Duration duration}) {
    return StreamBuilder<Duration>(
      stream: AudioService.position,
      builder: (context, positionSnapshot) {
        final position = positionSnapshot.data ?? Duration.zero;

        final safeDuration = duration.inMilliseconds > 0
            ? duration
            : const Duration(milliseconds: 1);
        final safePosition = position > safeDuration ? safeDuration : position;
        final displayPosition = _isDragging
            ? Duration(milliseconds: _dragValue.toInt())
            : safePosition;
        return PlayerProgress(
          position: displayPosition,
          duration: duration,
          onChangeStart: (value) => setState(() {
            _isDragging = true;
            _dragValue = value;
          }),
          onChanged: (value) => setState(() => _dragValue = value),
          onChangeEnd: (value) {
            setState(() {
              _isDragging = false;
              _dragValue = value;
            });
            _seekTo(Duration(milliseconds: value.toInt()));
          },
        );
      },
    );
  }

  Widget _buildControlPanel(PlaybackState? playbackState) {
    final isPlaying = playbackState?.playing == true;

    final shuffleMode =
        playbackState?.shuffleMode ?? AudioServiceShuffleMode.none;

    final repeatMode = playbackState?.repeatMode ?? AudioServiceRepeatMode.none;

    final isShuffleEnabled = shuffleMode != AudioServiceShuffleMode.none;
    final isRepeatEnabled = repeatMode != AudioServiceRepeatMode.none;

    return PlayerControls(
      isPlaying: isPlaying,
      shuffleEnabled: isShuffleEnabled,
      repeatEnabled: isRepeatEnabled,
      repeatOne: repeatMode == AudioServiceRepeatMode.one,
      onShuffle: () => _toggleShuffle(shuffleMode),
      onPrevious: _skipToPrevious,
      onPlayPause: () => _togglePlayPause(isPlaying),
      onNext: _skipToNext,
      onRepeat: () => _toggleRepeat(repeatMode),
      onRewind: () {
        final position = playbackState?.position ?? Duration.zero;
        _seekTo(
          position > const Duration(seconds: 15)
              ? position - const Duration(seconds: 15)
              : Duration.zero,
        );
      },
      onForward: () => _seekTo(
        (playbackState?.position ?? Duration.zero) +
            const Duration(seconds: 15),
      ),
    );
  }
}
