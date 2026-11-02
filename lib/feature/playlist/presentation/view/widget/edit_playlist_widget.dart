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
      onPressed: () => _showActionBottomSheet(context, ref),
    );
  }

  // Tách logic build UI cho BottomSheet
  Widget _buildSheetContent(BuildContext sheetContext, BuildContext originalContext, WidgetRef ref) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: const Text('Đổi tên'),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _showRenameDialog(originalContext, ref);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            title: const Text('Xóa', style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _confirmDelete(originalContext, ref);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showActionBottomSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: false,
      builder: (sheetContext) => _buildSheetContent(sheetContext, context, ref),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: playlist.name);
    final playlistNotifier = ref.read(playlistProvider.notifier);

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đổi tên playlist'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tên playlist'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.pop(dialogContext, controller.text);
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );

    //  Kiểm tra kết quả trước
    if (result == null || result.trim().isEmpty) {
      controller.dispose(); // Dispose sớm nếu người dùng hủy
      return;
    }

    final newName = result.trim();

    try {
      // Thực hiện logic cập nhật
      await playlistNotifier.renamePlaylist(
        playlistId: playlist.id,
        name: newName,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã đổi tên playlist')),
        );
        onRenamed?.call();
      }
    } finally {
      // Đảm bảo dispose controller CUỐI CÙNG sau khi mọi tác vụ async và rebuild đã xong
      controller.dispose();
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final playlistNotifier = ref.read(playlistProvider.notifier);

    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa playlist'),
        content: Text('Bạn có chắc muốn xóa playlist "${playlist.name}" không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Hủy')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (isConfirmed != true) return;

    await playlistNotifier.deletePlaylist(playlist.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa playlist')));
    onDeleted?.call();
  }
}