import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';

class EditPlaylistWidget extends ConsumerWidget {
  const EditPlaylistWidget({
    super.key,
    required this.playlist,
    this.onDeleted,
    this.onRenamed,
  });

  final PlaylistEntity playlist;

  final VoidCallback? onDeleted;

  final VoidCallback? onRenamed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.more_vert_rounded),
      onPressed: () {
        _showActionBottomSheet(
          context: context,
          ref: ref,
        );
      },
    );
  }

  Future<void> _showActionBottomSheet({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_rounded),
                title: const Text('Đổi tên'),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);

                  await _showRenameDialog(
                    context: context,
                    ref: ref,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Xóa',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);

                  await _confirmDelete(
                    context: context,
                    ref: ref,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showRenameDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final controller = TextEditingController(
      text: playlist.name,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Đổi tên playlist'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Tên playlist',
            ),
            onSubmitted: (_) async {
              await _renamePlaylist(
                context: context,
                dialogContext: dialogContext,
                ref: ref,
                name: controller.text,
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _renamePlaylist(
                  context: context,
                  dialogContext: dialogContext,
                  ref: ref,
                  name: controller.text,
                );
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

  Future<void> _renamePlaylist({
    required BuildContext context,
    required BuildContext dialogContext,
    required WidgetRef ref,
    required String name,
  }) async {
    final newName = name.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên playlist không được để trống'),
        ),
      );
      return;
    }

    await ref.read(playlistProvider.notifier).renamePlaylist(
      playlistId: playlist.id,
      name: newName,
    );

    if (dialogContext.mounted) {
      Navigator.pop(dialogContext);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã đổi tên playlist'),
        ),
      );
    }

    onRenamed?.call();
  }

  Future<void> _confirmDelete({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Xóa playlist'),
          content: Text(
            'Bạn có chắc muốn xóa playlist "${playlist.name}" không?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    await ref.read(playlistProvider.notifier).deletePlaylist(playlist.id);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa playlist'),
        ),
      );
    }

    onDeleted?.call();
  }
}