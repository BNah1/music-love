import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/online_url_youtube_streaming/presentation/controller/online_audio_controller.dart';
import 'package:musiclove/shared/widget/scrolling_song_title.dart';

class OnlineAudioView extends ConsumerStatefulWidget {
  const OnlineAudioView({super.key});
  @override
  ConsumerState<OnlineAudioView> createState() => _OnlineAudioViewState();
}

class _OnlineAudioViewState extends ConsumerState<OnlineAudioView> {
  final _url = TextEditingController();
  bool _opening = false;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _open(Future<void> Function() action) async {
    if (_opening) return;
    FocusScope.of(context).unfocus();
    setState(() => _opening = true);
    try {
      await action();
      if (mounted &&
          ref.read(onlineAudioControllerProvider).status ==
              OnlineAudioStatus.ready) {
        context.push(AppRoutes.onlinePlayer);
      }
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(onlineAudioControllerProvider);
    final theme = AppTheme.extensionOf(context);
    return Scaffold(
      backgroundColor: theme.pageBackground,
      appBar: AppBar(title: Text(context.tr(AppString.tabOnline))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _url,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.go,
                      onSubmitted: _opening
                          ? null
                          : (value) => _open(
                              () => ref
                                  .read(onlineAudioControllerProvider.notifier)
                                  .submitUrl(value),
                            ),
                      decoration: InputDecoration(
                        hintText: context.tr(AppString.onlineUrlHint),
                        prefixIcon: const Icon(Icons.link_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: context.tr(AppString.onlineOpen),
                    onPressed: _opening
                        ? null
                        : () => _open(
                            () => ref
                                .read(onlineAudioControllerProvider.notifier)
                                .submitUrl(_url.text),
                          ),
                    icon: const Icon(Icons.play_arrow_rounded),
                  ),
                ],
              ),
              if (_opening || online.status == OnlineAudioStatus.loading)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: LinearProgressIndicator(),
                ),
              if (online.status == OnlineAudioStatus.invalidUrl ||
                  online.status == OnlineAudioStatus.error)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    online.status == OnlineAudioStatus.invalidUrl
                        ? context.tr(AppString.onlineInvalidUrl)
                        : (online.error ?? context.tr(AppString.homeError)),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              if (online.title != null && online.videoId != null) ...[
                const SizedBox(height: 24),
                _SongCard(
                  item: OnlineHistoryItem(
                    videoId: online.videoId!,
                    title: online.title!,
                    artist: online.artist ?? '',
                    duration: online.duration,
                  ),
                  prominent: true,
                  onTap: () => context.push(AppRoutes.onlinePlayer),
                ),
              ],
              const SizedBox(height: 28),
              Text(
                context.tr(AppString.onlineRecent),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.textColor,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 160),
                  itemCount: online.history.length,
                  itemBuilder: (context, index) {
                    final item = online.history[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _SongCard(
                        item: item,
                        onTap: () => _open(
                          () => ref
                              .read(onlineAudioControllerProvider.notifier)
                              .playHistory(item),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SongCard extends StatelessWidget {
  const _SongCard({
    required this.item,
    required this.onTap,
    this.prominent = false,
  });
  final OnlineHistoryItem item;
  final VoidCallback onTap;
  final bool prominent;
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.extensionOf(context);
    return Material(
      color: theme.cardBackground,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(prominent ? 18 : 12),
          child: Row(
            children: [
              Container(
                width: prominent ? 64 : 48,
                height: prominent ? 64 : 48,
                decoration: BoxDecoration(
                  color: theme.softAccentColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.music_note_rounded, color: theme.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScrollingSongTitle(
                      title: item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: prominent ? 16 : 14,
                        color: theme.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: theme.subtitleColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                prominent
                    ? Icons.play_circle_fill_rounded
                    : Icons.play_arrow_rounded,
                color: theme.accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
