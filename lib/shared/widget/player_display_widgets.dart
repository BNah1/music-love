import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/play_music_button_widget.dart';
import 'package:musiclove/shared/widget/song_artwork_widget.dart';
import 'package:musiclove/shared/widget/scrolling_song_title.dart';

class PlayerArtwork extends StatelessWidget {
  const PlayerArtwork({
    super.key,
    required this.rotation,
    required this.isPlaying,
    this.artworkPath,
  });
  final Animation<double> rotation;
  final bool isPlaying;
  final String? artworkPath;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.extensionOf(context);
    final width = MediaQuery.sizeOf(context).width;
    return RotationTransition(
      turns: rotation,
      child: Container(
        width: width * .75,
        height: width * .75,
        decoration: BoxDecoration(
          color: theme.selectedIconColor.withOpacity(.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.selectedIconColor.withOpacity(.3),
            width: 8,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(width),
            child: SongArtworkWidget(
              artworkPath: artworkPath,
              borderRadius: BorderRadius.circular(width),
              fallback: Container(
                color: theme.cardBackground,
                child: Icon(
                  Icons.music_note_rounded,
                  size: 100,
                  color: isPlaying
                      ? theme.accentColor
                      : theme.unselectedIconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlayerSongInfo extends StatelessWidget {
  const PlayerSongInfo({super.key, required this.title, required this.artist});
  final String title;
  final String artist;
  @override
  Widget build(BuildContext context) {
    final color = AppTheme.extensionOf(context).selectedIconColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          ScrollingSongTitle(
            title: title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
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
              color: color.withOpacity(.72),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerProgress extends StatelessWidget {
  const PlayerProgress({
    super.key,
    required this.position,
    required this.duration,
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
  });
  final Duration position;
  final Duration duration;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;
  @override
  Widget build(BuildContext context) {
    final safeDuration = duration.inMilliseconds > 0
        ? duration
        : const Duration(milliseconds: 1);
    final displayPosition = position > safeDuration ? safeDuration : position;
    final maxValue = safeDuration.inMilliseconds.toDouble();
    final color = AppTheme.extensionOf(context).selectedIconColor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: color,
              inactiveTrackColor: color.withOpacity(.3),
              thumbColor: color,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(
              value: displayPosition.inMilliseconds.toDouble().clamp(
                0.0,
                maxValue,
              ),
              max: maxValue,
              onChangeStart: onChangeStart,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(displayPosition),
                  style: TextStyle(color: color.withOpacity(.72), fontSize: 12),
                ),
                Text(
                  _format(safeDuration),
                  style: TextStyle(color: color.withOpacity(.72), fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _format(Duration value) {
    String two(int n) => n.toString().padLeft(2, '0');
    final m = value.inMinutes.remainder(60), s = value.inSeconds.remainder(60);
    return value.inHours > 0
        ? '${two(value.inHours)}:${two(m)}:${two(s)}'
        : '${two(m)}:${two(s)}';
  }
}

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.isPlaying,
    required this.shuffleEnabled,
    required this.repeatEnabled,
    required this.repeatOne,
    required this.onShuffle,
    required this.onPrevious,
    required this.onPlayPause,
    required this.onNext,
    required this.onRepeat,
    required this.onRewind,
    required this.onForward,
  });
  final bool isPlaying, shuffleEnabled, repeatEnabled, repeatOne;
  final VoidCallback onShuffle, onPrevious, onPlayPause, onNext, onRepeat;
  final VoidCallback onRewind, onForward;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.extensionOf(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                tooltip: 'Phát ngẫu nhiên',
                onPressed: onShuffle,
                icon: Icon(
                  Icons.shuffle_rounded,
                  color: shuffleEnabled
                      ? theme.accentColor
                      : theme.selectedIconColor,
                ),
              ),
              IconButton(
                tooltip: 'Lặp lại',
                onPressed: onRepeat,
                icon: Icon(
                  repeatOne ? Icons.repeat_one_rounded : Icons.repeat_rounded,
                  color: repeatEnabled
                      ? theme.accentColor
                      : theme.selectedIconColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlayerSeekButton(forward: false, onPressed: onRewind),
              PlayMusicButtonWidget(
                enumPlayMusic: EnumPlayMusic.back,
                onTap: onPrevious,
              ),
              PlayMusicButtonWidget(
                onTap: onPlayPause,
                enumPlayMusic: isPlaying
                    ? EnumPlayMusic.pause
                    : EnumPlayMusic.play,
                isBigButton: true,
              ),
              PlayMusicButtonWidget(
                enumPlayMusic: EnumPlayMusic.next,
                onTap: onNext,
              ),
              PlayerSeekButton(forward: true, onPressed: onForward),
            ],
          ),
        ),
      ],
    );
  }
}

class PlayerSeekButton extends StatelessWidget {
  const PlayerSeekButton({
    super.key,
    required this.forward,
    required this.onPressed,
  });

  final bool forward;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.extensionOf(context).selectedIconColor;
    return IconButton(
      tooltip: forward ? 'Tiến 15 giây' : 'Lùi 15 giây',
      onPressed: onPressed,
      icon: SizedBox.square(
        dimension: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              forward ? Icons.undo : Icons.redo,
              size: 36,
              color: color,
            ),
            Positioned(
              bottom: 0,
              right: forward ? 8 : null,
              left: forward ? null : 8,
              child: Text(
                '15',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MiniPlayerDisplay extends StatelessWidget {
  const MiniPlayerDisplay({
    super.key,
    required this.title,
    required this.artist,
    required this.isPlaying,
    required this.onOpen,
    required this.onPlayPause,
    this.artworkPath,
  });
  final String title, artist;
  final bool isPlaying;
  final String? artworkPath;
  final VoidCallback onOpen, onPlayPause;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.extensionOf(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: GestureDetector(
        onTap: onOpen,
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.cardBackground,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: SongArtworkWidget(
                  artworkPath: artworkPath,
                  borderRadius: BorderRadius.circular(20),
                  fallback: CircleAvatar(
                    backgroundColor: theme.softAccentColor.withOpacity(.35),
                    child: Icon(
                      Icons.music_note_rounded,
                      color: theme.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollingSongTitle(
                      title: title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.textColor,
                      ),
                    ),
                    Text(
                      artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.subtitleColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onPlayPause,
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_fill_rounded,
                  size: 36,
                  color: theme.accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
