import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

class MoreVertWidget extends ConsumerWidget  {
  const MoreVertWidget({
    super.key,
    required this.song,
    this.currentPlaylistId,
    this.onChanged,
    this.onRemoveFromAudioHandler,
  });

  final Mp3FileEntity song;

  /// Có giá trị khi đang ở PlaylistDetailView.
  final String? currentPlaylistId;

  /// Reload UI sau khi thêm/xóa/đổi vị trí.
  final VoidCallback? onChanged;

  /// Callback để PlaylistDetailView xử lý xóa bài khỏi audioHandlerProvider.
  final Future<void> Function(String songId)? onRemoveFromAudioHandler;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return PopupMenuButton<_MusicAction>(
      icon: const Icon(Icons.more_vert_rounded),
      onSelected: (action) async {
        switch (action) {
          case _MusicAction.addToPlaylist:
            await _showSelectPlaylistDialog(context: context, ref: ref);
            break;

          case _MusicAction.moveToTop:
            await _moveToTop(ref);
            break;

          case _MusicAction.moveUp:
            await _moveUp(ref);
            break;

          case _MusicAction.moveDown:
            await _moveDown(ref);
            break;

          case _MusicAction.moveToBottom:
            await _moveToBottom(ref);
            break;

          case _MusicAction.removeFromPlaylist:
            await _removeFromPlaylist(context: context, ref: ref);
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

  Future<void> _showSelectPlaylistDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final notifier = ref.read(playlistProvider.notifier);
    await notifier.loadPlaylists();
    final playlists = ref.watch(playlistProvider).playlists;

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
                  await notifier.addSongToPlaylist(
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

  Future<void> _moveToTop(WidgetRef ref) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await ref.read(playlistProvider.notifier).moveSongToTop(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _moveUp(WidgetRef ref) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await ref.read(playlistProvider.notifier).moveSongUp(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _moveDown(WidgetRef ref) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await ref.read(playlistProvider.notifier).moveSongDown(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _moveToBottom(WidgetRef ref) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await ref.read(playlistProvider.notifier).moveSongToBottom(
      playlistId: playlistId,
      songId: song.id,
    );

    onChanged?.call();
  }

  Future<void> _removeFromPlaylist({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final playlistId = currentPlaylistId;
    if (playlistId == null) return;

    await ref.read(playlistProvider.notifier).removeSongFromPlaylist(
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