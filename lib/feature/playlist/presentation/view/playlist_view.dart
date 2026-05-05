import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
          title: const Text('Tạo playlist'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Tên playlist',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(toastContext),
              child: const Text('Hủy'),
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
              child: const Text('Tạo'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.backgroundGradient,
      ),
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
          title: const Text('Playlist'),
        ),
        body: playlists.isEmpty
            ? Center(
                child: Text(
                  'Chưa có playlist',
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
                      '${p.songIds.length} bài hát',
                      style: TextStyle(color: appTheme.subtitleColor),
                    ),
                    trailing: EditPlaylistWidget(
                      playlist: p,
                    ),
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
