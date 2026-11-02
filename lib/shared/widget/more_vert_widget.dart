import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

enum _MusicAction {
  addToPlaylist,
  moveToTop,
  moveUp,
  moveDown,
  moveToBottom,
  removeFromPlaylist,
}

class MoreVertWidget extends ConsumerWidget {
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
    // Gọi trực tiếp hàm UI đã được nâng cấp
    return _buildMusicActionMenu(context, ref);
  }

  // --- UI COMPONENTS ---

  Widget _buildMusicActionMenu(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme.extensionOf(context);

    return PopupMenuButton<_MusicAction>(
      icon: Icon(
        Icons.more_vert_rounded,
        color: appTheme.accentColor,
      ),
      position: PopupMenuPosition.under,
      offset: const Offset(0, 8),
      elevation: 6,
      shadowColor: appTheme.shadowColor,
      color: appTheme.accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: appTheme.shadowColor.withOpacity(0.05)),
      ),
      onSelected: (action) => _handleMusicAction(context, ref, action),
      itemBuilder: (context) => _buildMenuItems(appTheme),
    );
  }

  List<PopupMenuEntry<_MusicAction>> _buildMenuItems(AppThemeExtension appTheme) {
    return [
      _buildPopupItem(
        value: _MusicAction.addToPlaylist,
        icon: Icons.playlist_add_rounded,
        label: 'Thêm vào playlist',
        appTheme: appTheme,
      ),
      if (currentPlaylistId != null) ...[
        const PopupMenuDivider(height: 1),
        _buildPopupItem(
          value: _MusicAction.moveToTop,
          icon: Icons.vertical_align_top_rounded,
          label: 'Đưa lên đầu',
          appTheme: appTheme,
        ),
        _buildPopupItem(
          value: _MusicAction.moveUp,
          icon: Icons.keyboard_arrow_up_rounded,
          label: 'Đưa lên 1 vị trí',
          appTheme: appTheme,
        ),
        _buildPopupItem(
          value: _MusicAction.moveDown,
          icon: Icons.keyboard_arrow_down_rounded,
          label: 'Đưa xuống 1 vị trí',
          appTheme: appTheme,
        ),
        _buildPopupItem(
          value: _MusicAction.moveToBottom,
          icon: Icons.vertical_align_bottom_rounded,
          label: 'Đưa xuống cuối',
          appTheme: appTheme,
        ),
        const PopupMenuDivider(height: 1),
        _buildPopupItem(
          value: _MusicAction.removeFromPlaylist,
          icon: Icons.delete_outline_rounded,
          label: 'Xóa khỏi playlist',
          appTheme: appTheme,
          isDanger: true,
        ),
      ],
    ];
  }

  PopupMenuItem<_MusicAction> _buildPopupItem({
    required _MusicAction value,
    required IconData icon,
    required String label,
    required AppThemeExtension appTheme,
    bool isDanger = false,
  }) {
    final color = isDanger ? Colors.red : appTheme.selectedIconColor;

    return PopupMenuItem<_MusicAction>(
      value: value,
      height: 45,
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // --- LOGIC HANDLERS ---

  Future<void> _handleMusicAction(
      BuildContext context,
      WidgetRef ref,
      _MusicAction action,
      ) async {
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
  }

  Future<void> _showSelectPlaylistDialog({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final appTheme = AppTheme.extensionOf(context);
    final notifier = ref.read(playlistProvider.notifier);

    await notifier.loadPlaylists();
    final playlists = ref.read(playlistProvider).playlists;

    if (!context.mounted) return;

    if (playlists.isEmpty) {
      _showSnackBar(context, 'Chưa có playlist nào');
      return;
    }

    await showModalBottomSheet(
      context: context,
      backgroundColor: appTheme.navBackground,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Chọn Playlist',
                  style: TextStyle(
                    color: appTheme.selectedIconColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: playlists.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    color: appTheme.shadowColor.withOpacity(0.1),
                  ),
                  itemBuilder: (_, index) {
                    final playlist = playlists[index];
                    return ListTile(
                      leading: Icon(Icons.queue_music_rounded, color: appTheme.selectedIconColor),
                      title: Text(
                        playlist.name,
                        style: TextStyle(color: appTheme.selectedIconColor),
                      ),
                      subtitle: Text(
                        '${playlist.songIds.length} bài hát',
                        style: TextStyle(color: appTheme.selectedIconColor.withOpacity(0.6)),
                      ),
                      onTap: () async {
                        await notifier.addSongToPlaylist(
                          playlistId: playlist.id,
                          songId: song.id,
                        );

                        if (bottomSheetContext.mounted) {
                          Navigator.pop(bottomSheetContext);
                          _showSnackBar(context, 'Đã thêm vào ${playlist.name}');
                        }
                        onChanged?.call();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- HELPER LOGIC METHODS ---

  Future<void> _moveToTop(WidgetRef ref) async {
    if (currentPlaylistId == null) return;
    await ref.read(playlistProvider.notifier).moveSongToTop(
      playlistId: currentPlaylistId!,
      songId: song.id,
    );
    onChanged?.call();
  }

  Future<void> _moveUp(WidgetRef ref) async {
    if (currentPlaylistId == null) return;
    await ref.read(playlistProvider.notifier).moveSongUp(
      playlistId: currentPlaylistId!,
      songId: song.id,
    );
    onChanged?.call();
  }

  Future<void> _moveDown(WidgetRef ref) async {
    if (currentPlaylistId == null) return;
    await ref.read(playlistProvider.notifier).moveSongDown(
      playlistId: currentPlaylistId!,
      songId: song.id,
    );
    onChanged?.call();
  }

  Future<void> _moveToBottom(WidgetRef ref) async {
    if (currentPlaylistId == null) return;
    await ref.read(playlistProvider.notifier).moveSongToBottom(
      playlistId: currentPlaylistId!,
      songId: song.id,
    );
    onChanged?.call();
  }

  Future<void> _removeFromPlaylist({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    if (currentPlaylistId == null) return;

    await ref.read(playlistProvider.notifier).removeSongFromPlaylist(
      playlistId: currentPlaylistId!,
      songId: song.id,
    );

    await onRemoveFromAudioHandler?.call(song.id);

    if (context.mounted) {
      _showSnackBar(context, 'Đã xóa khỏi playlist');
    }
    onChanged?.call();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}