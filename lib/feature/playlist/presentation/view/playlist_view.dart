import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/storage/data/model/playlist_model.dart';
import 'package:musiclove/feature/storage/domain/repository/playlist_repository.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({super.key});

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  final _repo = PlaylistRepository();

  List<PlaylistModel> _playlists = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _playlists = _repo.getAllPlaylists();
    setState(() {});
  }

  Future<void> _createPlaylist() async {
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

              await _repo.createPlaylist(name);

              if (toastContext.mounted) {
                Navigator.pop(toastContext);
                _load();
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

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
              onTap: _createPlaylist,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.add, color: appTheme.accentColor),
              ),
            ),
          ],
          title: const Text('Playlist'),
        ),
        body: _playlists.isEmpty
            ? Center(
                child: Text(
                  'Chưa có playlist',
                  style: TextStyle(color: appTheme.subtitleColor),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 110),
                itemCount: _playlists.length,
                itemBuilder: (_, index) {
                  final p = _playlists[index];

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
