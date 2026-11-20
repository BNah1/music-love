import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/widget/app_overlay.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';
import 'package:musiclove/feature/playlist/presentation/view/widget/playlist_name_dialog.dart';

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
  Widget _buildSheetContent(
    BuildContext sheetContext,
    BuildContext originalContext,
    WidgetRef ref,
  ) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.music_note_rounded),
            title: Text(sheetContext.tr(AppString.playlistAddSong)),
            onTap: () {
              Navigator.of(sheetContext).pop();
              originalContext.push(
                AppRoutes.addSongsToPlaylist(playlist.id, multiple: false),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.library_add_rounded),
            title: Text(sheetContext.tr(AppString.playlistAddMultipleSongs)),
            onTap: () {
              Navigator.of(sheetContext).pop();
              originalContext.push(
                AppRoutes.addSongsToPlaylist(playlist.id, multiple: true),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.edit_rounded),
            title: Text(sheetContext.tr(AppString.menuRename)),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _showRenameDialog(originalContext, ref);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
            ),
            title: Text(
              sheetContext.tr(AppString.menuDelete),
              style: const TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _confirmDelete(originalContext, ref);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showActionBottomSheet(
    BuildContext context,
    WidgetRef ref,
  ) async {
    await AppOverlay.showSheet(
      context: context,
      builder: (sheetContext) => _buildSheetContent(sheetContext, context, ref),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, WidgetRef ref) async {
    final playlistNotifier = ref.read(playlistProvider.notifier);

    final result = await showPlaylistNameDialog(
      context: context,
      title: context.tr(AppString.playlistRename),
      initialValue: playlist.name,
    );

    if (result == null || result.trim().isEmpty) return;

    final newName = result.trim();

    await playlistNotifier.renamePlaylist(
      playlistId: playlist.id,
      name: newName,
    );

    if (context.mounted) {
      AppOverlay.showToast(context, context.tr(AppString.playlistRenamed));
      onRenamed?.call();
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final playlistNotifier = ref.read(playlistProvider.notifier);

    final isConfirmed = await AppOverlay.showModal<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.tr(AppString.playlistDelete)),
        content: Text(
          dialogContext.tr(
            AppString.playlistConfirmDelete,
            namedArgs: {'name': playlist.name},
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(dialogContext.tr(AppString.commonCancel)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(dialogContext.tr(AppString.commonDelete)),
          ),
        ],
      ),
    );

    if (isConfirmed != true) return;

    await playlistNotifier.deletePlaylist(playlist.id);

    if (!context.mounted) return;
    AppOverlay.showToast(context, context.tr(AppString.playlistDeleted));
    onDeleted?.call();
  }
}
