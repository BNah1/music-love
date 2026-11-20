import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/play_music_button_widget.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/presentation/controller/online_audio_controller.dart';
import 'package:musiclove/shared/widget/player_display_widgets.dart';

class OnlineAudioView extends ConsumerStatefulWidget {
  const OnlineAudioView({super.key});

  @override
  ConsumerState<OnlineAudioView> createState() => _OnlineAudioViewState();
}

class _OnlineAudioViewState extends ConsumerState<OnlineAudioView>
    with SingleTickerProviderStateMixin {
  final _urlController = TextEditingController();
  late final AnimationController _rotation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  );
  double? _dragPosition;

  @override
  void dispose() {
    _urlController.dispose();
    _rotation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(onlineAudioControllerProvider);
    final theme = AppTheme.extensionOf(context);
    if (online.isPlaying) {
      if (!_rotation.isAnimating) _rotation.repeat();
    } else if (_rotation.isAnimating) {
      _rotation.stop();
    }

    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(title: Text(context.tr(AppString.tabOnline))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 160),
          children: [
            TextField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              onSubmitted: _submit,
              decoration: InputDecoration(
                hintText: context.tr(AppString.onlineUrlHint),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _submit(_urlController.text),
              child: Text(context.tr(AppString.onlineOpen)),
            ),
            const SizedBox(height: 24),
            if (online.status == OnlineAudioStatus.invalidUrl)
              Text(context.tr(AppString.onlineInvalidUrl)),
            if (online.status == OnlineAudioStatus.awaitingSource)
              Text(context.tr(AppString.onlinePending)),
            if (online.status == OnlineAudioStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (online.status == OnlineAudioStatus.error)
              Text(online.error ?? context.tr(AppString.homeError)),
            if (online.status == OnlineAudioStatus.ready) ...[
              PlayerArtwork(rotation: _rotation, isPlaying: online.isPlaying),
              const SizedBox(height: 24),
              PlayerSongInfo(
                title: online.title ?? '',
                artist: online.artist ?? '',
              ),
              const SizedBox(height: 20),
              PlayerProgress(
                position: _dragPosition == null
                    ? online.position
                    : Duration(milliseconds: _dragPosition!.round()),
                duration: online.duration,
                onChangeStart: (value) => setState(() => _dragPosition = value),
                onChanged: (value) => setState(() => _dragPosition = value),
                onChangeEnd: (value) {
                  setState(() => _dragPosition = null);
                  ref
                      .read(onlineAudioControllerProvider.notifier)
                      .seek(Duration(milliseconds: value.round()));
                },
              ),
              const SizedBox(height: 12),
              Center(
                child: PlayMusicButtonWidget(
                  isBigButton: true,
                  enumPlayMusic: online.isPlaying
                      ? EnumPlayMusic.pause
                      : EnumPlayMusic.play,
                  onTap: () => ref
                      .read(onlineAudioControllerProvider.notifier)
                      .togglePlayback(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _submit(String value) {
    FocusScope.of(context).unfocus();
    ref.read(onlineAudioControllerProvider.notifier).submitUrl(value);
  }
}
