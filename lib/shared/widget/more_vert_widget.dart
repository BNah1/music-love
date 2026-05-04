import 'package:flutter/material.dart';
import 'package:musiclove/core/model/mp3_file_model.dart';
import 'package:musiclove/feature/storage/domain/repository/playlist_repository.dart';

class MoreVertWidget extends StatelessWidget {
  const MoreVertWidget({
    super.key,
    required this.song,
    this.currentPlaylistId,
    this.onChanged,
    this.onRemoveFromAudioHandler,
  });

  final Mp3FileModel song;

  /// Có giá trị khi đang ở PlaylistDetailView.
  final String? currentPlaylistId;

  /// Reload UI sau khi thêm/xóa/đổi vị trí.
  final VoidCallback? onChanged;

  /// Callback để PlaylistDetailView xử lý xóa bài khỏi audioHandlerProvider.
  final Future<void> Function(String songId)? onRemoveFromAudioHandler;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MusicAction>(
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) async {
        switch (action) {
          case _MusicAction.addToPlaylist:
            await _showSelectPlaylistDialog(context);
            break;

          case _MusicAction.moveToTop:
            await _moveToTop(context);
            break;

          case _MusicAction.moveUp:
            await _moveUp(context);
            break;

          case _MusicAction.moveDown:
            await _moveDown(context);
            break;

          case _MusicAction.moveToBottom:
            await _moveToBottom(context);
            break;

          case _MusicAction.removeFromPlaylist:
            await _removeFromPlaylist(context);
            break;
        }
      },
      itemBuilder: (context) {
        return [
          /// Nằm trên cùng.
          const PopupMenuItem(
            value: _MusicAction.addToPlaylist,
            child: Row(
              children: [
                Icon(Icons.playlist_add_rounded),
                SizedBox(width: 10),
                Text('Thêm vào playlist'),
              ],
            ),
          ),

          if (currentPlaylistId != null) ...[
            const PopupMenuDivider(),

            const PopupMenuItem(
              value: _MusicAction.moveToTop,
              child: Row(
                children: [
                  Icon(Icons.vertical_align_top_rounded),
                  SizedBox(width: 10),
                  Text('Đưa lên đầu'),
                ],
              ),
            ),

            const PopupMenuItem(
              value: _MusicAction.moveUp,
              child: Row(
                children: [
                  Icon(Icons.keyboard_arrow_up_rounded),
                  SizedBox(width: 10),
                  Text('Đưa lên 1 vị trí'),
                ],
              ),
            ),

            const PopupMenuItem(
              value: _MusicAction.moveDown,
              child: Row(
                children: [
                  Icon(Icons.keyboard_arrow_down_rounded),
                  SizedBox(width: 10),
                  Text('Đưa xuống 1 vị trí'),
                ],
              ),
            ),

            const PopupMenuItem(
              value: _MusicAction.moveToBottom,
              child: Row(
                children: [
                  Icon(Icons.vertical_align_bottom_rounded),
                  SizedBox(width: 10),
                  Text('Đưa xuống cuối'),
                ],
              ),
            ),

            const PopupMenuDivider(),

            const PopupMenuItem(
              value: _MusicAction.removeFromPlaylist,
              child: Row(
                children: [
                  Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Xóa khỏi playlist',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            ),
          ],
        ];
      },
    );
  }

  Future<void> _showSelectPlaylistDialog(BuildContext context) async {
    final repo = PlaylistRepository();
    final playlists = repo.getAllPlaylists();

    if (playlists.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Chưa có playlist nào'),
        ),
      );
      return;
    }

    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (toastContext) {
        return SafeArea(
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: playlists.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              final playlist = playlists[index];

              return ListTile(
                leading: const Icon(Icons.queue_music_rounded),
                title: Text(playlist.name),
                subtitle: Text('${playlist.songIds.length} bài hát'),
                onTap: () async {
                  await repo.addSongToPlaylist(
                    playlistId: playlist.id,
                    songId: song.id,
                  );

                  if (toastContext.mounted) {
                    Navigator.pop(toastContext);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm vào ${playlist.name}'),
                      ),
                    );
                  }

                  onChanged?.call();
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _moveToTop(BuildContext context) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await PlaylistRepository().moveSongToTop(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _moveUp(BuildContext context) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await PlaylistRepository().moveSongUp(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _moveDown(BuildContext context) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await PlaylistRepository().moveSongDown(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _moveToBottom(BuildContext context) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await PlaylistRepository().moveSongToBottom(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _removeFromPlaylist(BuildContext context) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await PlaylistRepository().removeSongFromPlaylist(
      playlistId: playlistId,
      songId: song.id,
    );

    await onRemoveFromAudioHandler?.call(song.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa khỏi playlist'),
        ),
      );
    }

    onChanged?.call();
  }
}

enum _MusicAction {
  addToPlaylist,
  moveToTop,
  moveUp,
  moveDown,
  moveToBottom,
  removeFromPlaylist,
}