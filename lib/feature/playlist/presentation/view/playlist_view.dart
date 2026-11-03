import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/feature/playlist/presentation/view/widget/edit_playlist_widget.dart';

class PlaylistView extends ConsumerWidget {
  const PlaylistView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme.extensionOf(context);
    final state = ref.watch(playlistProvider);
    final notifier = ref.read(playlistProvider.notifier);
    final playlists = state.playlists;

    Future<void> createPlaylist() async {
      final controller = TextEditingController();

      await showDialog(
        context: context,
        builder: (toastContext) => AlertDialog(
          title: Text(toastContext.tr(AppString.playlistCreate)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: toastContext.tr(AppString.playlistNameHint),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(toastContext),
              child: Text(toastContext.tr(AppString.commonCancel)),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = controller.text.trim();
                if (name.isEmpty) return;

                await notifier.createPlaylist(name);

                if (toastContext.mounted) {
                  Navigator.pop(toastContext);
                }
              },
              child: Text(toastContext.tr(AppString.commonCreate)),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: appTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            InkWell(
              onTap: createPlaylist,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.add, color: appTheme.accentColor),
              ),
            ),
          ],
          title: Text(context.tr(AppString.playlistTitle)),
        ),
        body: playlists.isEmpty
            ? Center(
                child: Text(
                  context.tr(AppString.playlistEmpty),
                  style: TextStyle(color: appTheme.subtitleColor),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 110),
                itemCount: playlists.length,
                itemBuilder: (_, index) {
                  final p = playlists[index];

                  return ListTile(
                    leading: Icon(
                      Icons.queue_music_rounded,
                      color: appTheme.accentColor,
                    ),
                    title: Text(
                      p.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: appTheme.textColor,
                      ),
                    ),
                    subtitle: Text(
                      context.tr(
                        AppString.playlistSongsCount,
                        namedArgs: {'count': '${p.songIds.length}'},
                      ),
                      style: TextStyle(color: appTheme.subtitleColor),
                    ),
                    trailing: EditPlaylistWidget(playlist: p),
                    onTap: () {
                      context.push(AppRoutes.playlistDetail(p.id));
                    },
                  );
                },
              ),
      ),
    );
  }
}
