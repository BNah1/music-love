import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/play_music_button_widget.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/presentation/controller/online_audio_controller.dart';
import 'package:musiclove/shared/widget/player_display_widgets.dart';

class OnlinePlayerView extends ConsumerStatefulWidget {
  const OnlinePlayerView({super.key});
  @override
  ConsumerState<OnlinePlayerView> createState() => _OnlinePlayerViewState();
}

class _OnlinePlayerViewState extends ConsumerState<OnlinePlayerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  );
  double? _dragPosition;

  @override
  void dispose() {
    _rotation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(onlineAudioControllerProvider);
    final theme = AppTheme.extensionOf(context);
    if (online.isPlaying && online.status == OnlineAudioStatus.ready) {
      if (!_rotation.isAnimating) _rotation.repeat();
    } else if (_rotation.isAnimating) {
      _rotation.stop();
    }
    return Scaffold(
      backgroundColor: theme.pageBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          '${context.tr(AppString.tabOnline)} · ${context.tr(AppString.playerNowPlaying)}',
          style: TextStyle(
            color: theme.selectedIconColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: theme.navIndicatorGradient),
        child: SafeArea(
          child: online.status != OnlineAudioStatus.ready
              ? Center(
                  child: Text(online.error ?? context.tr(AppString.homeError)),
                )
              : Column(
                  children: [
                    const Spacer(flex: 2),
                    PlayerArtwork(
                      rotation: _rotation,
                      isPlaying: online.isPlaying,
                    ),
                    const SizedBox(height: 32),
                    PlayerSongInfo(
                      title: online.title ?? '',
                      artist: online.artist ?? '',
                    ),
                    const Spacer(),
                    PlayerProgress(
                      position: _dragPosition == null
                          ? online.position
                          : Duration(milliseconds: _dragPosition!.round()),
                      duration: online.duration,
                      onChangeStart: (value) =>
                          setState(() => _dragPosition = value),
                      onChanged: (value) =>
                          setState(() => _dragPosition = value),
                      onChangeEnd: (value) {
                        setState(() => _dragPosition = null);
                        ref
                            .read(onlineAudioControllerProvider.notifier)
                            .seek(Duration(milliseconds: value.round()));
                      },
                    ),
                    const SizedBox(height: 36),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PlayerSeekButton(
                            forward: false,
                            onPressed: () =>
                                _seekRelative(online.position, -15),
                          ),
                          PlayMusicButtonWidget(
                            isBigButton: true,
                            enumPlayMusic: online.isPlaying
                                ? EnumPlayMusic.pause
                                : EnumPlayMusic.play,
                            onTap: () => ref
                                .read(onlineAudioControllerProvider.notifier)
                                .togglePlayback(),
                          ),
                          PlayerSeekButton(
                            forward: true,
                            onPressed: () => _seekRelative(online.position, 15),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
        ),
      ),
    );
  }

  void _seekRelative(Duration position, int seconds) {
    final duration = ref.read(onlineAudioControllerProvider).duration;
    final target = position + Duration(seconds: seconds);
    final bounded = target < Duration.zero
        ? Duration.zero
        : duration > Duration.zero && target > duration
        ? duration
        : target;
    ref.read(onlineAudioControllerProvider.notifier).seek(bounded);
  }
}
