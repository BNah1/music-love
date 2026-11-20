import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/song_sort_option.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/core/widget/app_overlay.dart';
import 'package:musiclove/feature/home/presentation/view/widget/search_box_widget.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/feature/playlist/presentation/view/widget/edit_playlist_widget.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';
import 'package:musiclove/shared/widget/music_column_tile_widget.dart';
import 'package:musiclove/shared/widget/song_sort_menu.dart';

class PlaylistDetailView extends ConsumerStatefulWidget {
  const PlaylistDetailView({super.key, required this.playlistId});
  final String playlistId;

  @override
  ConsumerState<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends ConsumerState<PlaylistDetailView> {
  String _query = '';
  SongSortOption? _sort;
  final Set<String> _selected = {};

  bool get _isSelecting => _selected.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() => ref
      .read(playlistProvider.notifier)
      .getDetailPlaylistById(widget.playlistId);

  List<Mp3FileEntity> _visible(List<Mp3FileEntity> songs) {
    final keyword = _query.trim().toLowerCase();
    final filtered = keyword.isEmpty
        ? [...songs]
        : songs.where((song) {
            return song.title.toLowerCase().contains(keyword) ||
                (song.artist ?? '').toLowerCase().contains(keyword) ||
                (song.album ?? '').toLowerCase().contains(keyword);
          }).toList();
    return _sort?.sort(filtered) ?? filtered;
  }

  void _toggle(String id) => setState(() {
    _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.extensionOf(context);
    final detail = ref.watch(playlistProvider).currentPlaylist;
    if (detail == null || detail.playlist.id != widget.playlistId) {
      return Scaffold(
        body: Center(child: Text(context.tr(AppString.playlistNotFound))),
      );
    }
    final songs = _visible(detail.songs);
    final canReorder = _query.trim().isEmpty && _sort == null;

    return Container(
      decoration: BoxDecoration(gradient: theme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: _isSelecting
              ? IconButton(
                  onPressed: () => setState(_selected.clear),
                  icon: const Icon(Icons.close_rounded),
                )
              : null,
          title: Text(
            _isSelecting
                ? context.tr(
                    AppString.playlistSelectedCount,
                    namedArgs: {'count': '${_selected.length}'},
                  )
                : detail.playlist.name,
          ),
          actions: _isSelecting
              ? [
                  IconButton(
                    onPressed: _showBatchPicker,
                    icon: const Icon(Icons.playlist_add_rounded),
                  ),
                  IconButton(
                    onPressed: _removeSelected,
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
                ]
              : [
                  SongSortMenu(
                    value: _sort ?? SongSortOption.newest,
                    onChanged: (value) => setState(() => _sort = value),
                  ),
                  EditPlaylistWidget(
                    playlist: detail.playlist,
                    onDeleted: () {
                      if (context.mounted) Navigator.pop(context);
                    },
                    onRenamed: _load,
                  ),
                ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SearchMusicBox(
                query: _query,
                onChanged: (value) => setState(() => _query = value),
                onClear: () => setState(() => _query = ''),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  context.tr(
                    AppString.playlistSongsCount,
                    namedArgs: {'count': '${songs.length}'},
                  ),
                  style: TextStyle(color: theme.subtitleColor),
                ),
              ),
              Expanded(
                child: songs.isEmpty
                    ? Center(child: Text(context.tr(AppString.playlistNoSongs)))
                    : canReorder
                    ? ReorderableListView.builder(
                        padding: const EdgeInsets.only(bottom: 110),
                        itemCount: songs.length,
                        onReorder: (oldIndex, newIndex) => ref
                            .read(playlistProvider.notifier)
                            .reorderSongs(
                              playlistId: widget.playlistId,
                              oldIndex: oldIndex,
                              newIndex: newIndex,
                            ),
                        itemBuilder: (_, index) =>
                            _tile(songs[index], index, showDragHandle: true),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 110),
                        itemCount: songs.length,
                        itemBuilder: (_, index) =>
                            _tile(songs[index], index, showDragHandle: false),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(Mp3FileEntity song, int index, {required bool showDragHandle}) {
    return KeyedSubtree(
      key: ValueKey(song.id),
      child: MusicColumnTileWidget(
        song: song,
        currentPlaylistId: widget.playlistId,
        isSelected: _selected.contains(song.id),
        onLongPress: () => _toggle(song.id),
        onChanged: _load,
        trailing: _isSelecting
            ? Checkbox(
                value: _selected.contains(song.id),
                onChanged: (_) => _toggle(song.id),
              )
            : showDragHandle
            ? ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.drag_handle_rounded),
                ),
              )
            : null,
      ),
    );
  }

  Future<void> _removeSelected() async {
    final notifier = ref.read(playlistProvider.notifier);
    for (final id in [..._selected]) {
      await notifier.removeSongFromPlaylist(
        playlistId: widget.playlistId,
        songId: id,
      );
    }
    await _load();
    if (!mounted) return;
    setState(_selected.clear);
    AppOverlay.showToast(context, context.tr(AppString.playlistRemoved));
  }

  Future<void> _showBatchPicker() async {
    final targets = ref
        .read(playlistProvider)
        .playlists
        .where((playlist) => playlist.id != widget.playlistId)
        .toList();
    final chosen = <String>{};
    var didSave = false;
    await AppOverlay.showSheet<void>(
      context: context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.tr(AppString.playlistAddSelected),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (targets.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(context.tr(AppString.playlistNoPlaylistsYet)),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: targets.length,
                    itemBuilder: (_, index) {
                      final playlist = targets[index];
                      return CheckboxListTile(
                        value: chosen.contains(playlist.id),
                        title: Text(playlist.name),
                        onChanged: (_) => setSheetState(() {
                          chosen.contains(playlist.id)
                              ? chosen.remove(playlist.id)
                              : chosen.add(playlist.id);
                        }),
                      );
                    },
                  ),
                ),
              FilledButton.icon(
                onPressed: chosen.isEmpty
                    ? null
                    : () async {
                        await ref
                            .read(playlistProvider.notifier)
                            .addSongsToPlaylists(
                              playlistIds: chosen.toList(),
                              songIds: _selected.toList(),
                            );
                        didSave = true;
                        if (sheetContext.mounted) Navigator.pop(sheetContext);
                      },
                icon: const Icon(Icons.playlist_add_rounded),
                label: Text(context.tr(AppString.playlistAddSelected)),
              ),
            ],
          ),
        ),
      ),
    );
    if (!mounted || !didSave) return;
    setState(_selected.clear);
    AppOverlay.showToast(context, context.tr(AppString.playlistAddedSelected));
  }
}
