import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/library/data/model/mp3_file_model.dart';
import 'package:musiclove/core/provider/audio_handler_provider.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/play_music_button_widget.dart';

import '../../../../core/audio/music_audio_handler.dart';

class PlayMusicView extends ConsumerStatefulWidget {
  /// Dùng cho route: /playMusic/:songId
  final String? songId;

  /// Có giá trị khi mở bài từ PlaylistDetailView.
  /// Khi có playlistId, màn này sẽ phát toàn bộ playlist và bắt đầu từ đúng songId.
  final String? playlistId;

  /// Giữ lại để không vỡ route cũ đang truyền extra Mp3FileModel.
  final Mp3FileModel? song;

  const PlayMusicView({
    super.key,
    this.songId,
    this.playlistId,
    this.song,
  }) : assert(
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

  Size get size => MediaQuery.sizeOf(context);

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

      final currentQueueIds = audioHandler.queue.value.map((e) => e.id).toList();
      final targetQueueIds = targetItems.map((e) => e.id).toList();

      final isCurrentSong = currentItem?.id == song.id;
      final isSameQueue = listEquals(
        currentQueueIds,
        targetQueueIds,
      );

      // Nếu chỉ mở màn hình bài đang phát thì không prepare lại player.
      // Prepare lại queue sẽ làm just_audio setAudioSources() và vị trí phát quay về đầu bài.
      if (!isCurrentSong) {
        if (audioHandler is MusicAudioHandler) {
          if (isSameQueue) {
            // Đang cùng playlist/queue, chỉ nhảy sang index bài được chọn.
             audioHandler.playQueueIndex(
              index: startIndex,
            );
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
      }


      setState(() {
        _isLoading = false;
        _errorMessage = null;
      });

      if (!mounted) return;

    } catch (e) {

      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi mở bài hát: $e';
      });

      if (!mounted) return;
    }
  }

  List<Mp3FileModel> _getQueueSongs({
    required Mp3FileModel startSong,
  }) {
    final playlistId = widget.playlistId;

    if (playlistId == null || playlistId.isEmpty) {
      return [startSong];
    }

    final playlistSongs = _findSongsByPlaylistId(playlistId);

    if (playlistSongs.isEmpty) {
      return [startSong];
    }

    final hasStartSong = playlistSongs.any(
          (song) => song.id == startSong.id,
    );

    if (!hasStartSong) {
      return [startSong, ...playlistSongs];
    }

    return playlistSongs;
  }

  int _findStartIndex(
      List<Mp3FileModel> songs,
      String songId,
      ) {
    final index = songs.indexWhere(
          (song) => song.id == songId,
    );

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

        return Mp3FileModel.fromMap(
          Map<String, dynamic>.from(data),
        );
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
        return Mp3FileModel.fromMap(
          Map<String, dynamic>.from(data),
        );
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
          child: CircularProgressIndicator(color: appTheme.selectedIconColor),
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

                return Column(
                  children: [
                    const Spacer(),
                    _buildAlbumArt(isPlaying),
                    const SizedBox(height: 40),
                    _buildSongInfo(
                      mediaItem: mediaItem,
                      song: displaySong,
                    ),
                    const SizedBox(height: 30),
                    _buildProgressBar(
                      duration: mediaItem?.duration ??
                          Duration(
                            milliseconds:
                            displaySong?.duration ?? 0,
                          ),
                    ),
                    const SizedBox(height: 20),
                    _buildControlPanel(playbackState),
                    const Spacer(flex: 2),
                  ],
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
        'ĐANG PHÁT',
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

    return BoxDecoration(
      gradient: appTheme.navIndicatorGradient,
    );
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
              _errorMessage ?? 'Có lỗi xảy ra',
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
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumArt(bool isPlaying) {
    final appTheme = AppTheme.extensionOf(context);

    return RotationTransition(
      turns: _animationController,
      child: Container(
        width: size.width * 0.75,
        height: size.width * 0.75,
        decoration: BoxDecoration(
          color: appTheme.selectedIconColor.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: appTheme.selectedIconColor.withOpacity(0.3),
            width: 8,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(size.width),
            child: Container(
              color: appTheme.cardBackground,
              child: Icon(
                Icons.music_note_rounded,
                size: 100,
                color: isPlaying
                    ? appTheme.accentColor
                    : appTheme.unselectedIconColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo({
    required MediaItem? mediaItem,
    required Mp3FileModel? song,
  }) {
    final title = mediaItem?.title ?? song?.title ?? '';
    final artist = mediaItem?.artist ?? song?.artist ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.extensionOf(context).selectedIconColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            artist,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.extensionOf(context)
                  .selectedIconColor
                  .withOpacity(0.72),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({
    required Duration duration,
  }) {
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

        final maxValue = safeDuration.inMilliseconds.toDouble();

        final sliderValue = displayPosition.inMilliseconds
            .toDouble()
            .clamp(0.0, maxValue);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  activeTrackColor: AppTheme.extensionOf(context).selectedIconColor,
                  inactiveTrackColor: AppTheme.extensionOf(context)
                      .selectedIconColor
                      .withOpacity(0.3),
                  thumbColor: AppTheme.extensionOf(context).selectedIconColor,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 6,
                  ),
                ),
                child: Slider(
                  value: sliderValue,
                  max: maxValue,
                  onChangeStart: (value) {
                    setState(() {
                      _isDragging = true;
                      _dragValue = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _dragValue = value;
                    });
                  },
                  onChangeEnd: (value) {
                    setState(() {
                      _isDragging = false;
                      _dragValue = value;
                    });

                    _seekTo(
                      Duration(milliseconds: value.toInt()),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(displayPosition),
                      style: TextStyle(
                        color: AppTheme.extensionOf(context)
                  .selectedIconColor
                  .withOpacity(0.72),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _formatDuration(safeDuration),
                      style: TextStyle(
                        color: AppTheme.extensionOf(context)
                  .selectedIconColor
                  .withOpacity(0.72),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlPanel(PlaybackState? playbackState) {
    final isPlaying = playbackState?.playing == true;

    final shuffleMode =
        playbackState?.shuffleMode ?? AudioServiceShuffleMode.none;

    final repeatMode =
        playbackState?.repeatMode ?? AudioServiceRepeatMode.none;

    final isShuffleEnabled = shuffleMode != AudioServiceShuffleMode.none;
    final isRepeatEnabled = repeatMode != AudioServiceRepeatMode.none;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _toggleShuffle(shuffleMode),
            child: Icon(
              Icons.shuffle_rounded,
              color: isShuffleEnabled
                  ? AppTheme.extensionOf(context).accentColor
                  : AppTheme.extensionOf(context).selectedIconColor.withOpacity(0.54),
              size: 24,
            ),
          ),
          const Spacer(),
          PlayMusicButtonWidget(
            enumPlayMusic: EnumPlayMusic.back,
            onTap: _skipToPrevious,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: PlayMusicButtonWidget(
              onTap: () => _togglePlayPause(isPlaying),
              enumPlayMusic:
              isPlaying ? EnumPlayMusic.pause : EnumPlayMusic.play,
              isBigButton: true,
            ),
          ),
          PlayMusicButtonWidget(
            enumPlayMusic: EnumPlayMusic.next,
            onTap: _skipToNext,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _toggleRepeat(repeatMode),
            child: Icon(
              repeatMode == AudioServiceRepeatMode.one
                  ? Icons.repeat_one_rounded
                  : Icons.repeat_rounded,
              color: isRepeatEnabled
                  ? AppTheme.extensionOf(context).accentColor
                  : AppTheme.extensionOf(context).selectedIconColor.withOpacity(0.54),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }

    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}