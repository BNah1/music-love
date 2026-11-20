import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/song_sort_option.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/core/widget/app_overlay.dart';
import 'package:musiclove/feature/home/presentation/provider/home_provider.dart';
import 'package:musiclove/feature/home/presentation/view/widget/search_box_widget.dart';
import 'package:musiclove/shared/widget/song_artwork_widget.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';
import 'package:musiclove/shared/widget/song_sort_menu.dart';

class PlaylistSongPickerView extends ConsumerStatefulWidget {
  const PlaylistSongPickerView({
    super.key,
    required this.playlistId,
    required this.isMultiple,
  });

  final String playlistId;
  final bool isMultiple;

  @override
  ConsumerState<PlaylistSongPickerView> createState() =>
      _PlaylistSongPickerViewState();
}

class _PlaylistSongPickerViewState
    extends ConsumerState<PlaylistSongPickerView> {
  String _query = '';
  SongSortOption _sort = SongSortOption.newest;
  final Set<String> _selected = {};

  List<Mp3FileEntity> _visibleSongs(List<Mp3FileEntity> songs) {
    final keyword = _query.trim().toLowerCase();
    final filtered = keyword.isEmpty
        ? songs
        : songs.where((song) {
            return song.title.toLowerCase().contains(keyword) ||
                (song.artist ?? '').toLowerCase().contains(keyword) ||
                (song.album ?? '').toLowerCase().contains(keyword);
          }).toList();
    return _sort.sort(filtered);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.extensionOf(context);
    final playlists = ref.watch(playlistProvider).playlists;
    final playlist = playlists
        .where((item) => item.id == widget.playlistId)
        .firstOrNull;
    final songs = _visibleSongs(ref.watch(homeProvider).songs);
    final existingIds = playlist?.songIds.toSet() ?? <String>{};

    return Container(
      decoration: BoxDecoration(gradient: theme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            context.tr(
              AppString.playlistChooseSongs,
              namedArgs: {'name': playlist?.name ?? ''},
            ),
          ),
          actions: [
            SongSortMenu(
              value: _sort,
              onChanged: (value) => setState(() => _sort = value),
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
              Expanded(
                child: songs.isEmpty
                    ? Center(
                        child: Text(context.tr(AppString.homeNoMatchingSongs)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120),
                        itemCount: songs.length,
                        itemBuilder: (_, index) {
                          final song = songs[index];
                          final alreadyAdded = existingIds.contains(song.id);
                          final selected = _selected.contains(song.id);
                          return ListTile(
                            enabled: !alreadyAdded,
                            onTap: () => _onSongTap(song),
                            leading: SizedBox(
                              width: 44,
                              height: 44,
                              child: SongArtworkWidget(
                                artworkPath: song.artworkPath,
                                borderRadius: BorderRadius.circular(10),
                                fallback: Icon(
                                  alreadyAdded
                                      ? Icons.check_circle_rounded
                                      : Icons.music_note_rounded,
                                  color: alreadyAdded
                                      ? theme.subtitleColor
                                      : theme.accentColor,
                                ),
                              ),
                            ),
                            title: Text(song.title),
                            subtitle: Text(
                              alreadyAdded
                                  ? context.tr(AppString.playlistAlreadyAdded)
                                  : song.artist ?? '',
                            ),
                            trailing: widget.isMultiple && !alreadyAdded
                                ? Checkbox(
                                    value: selected,
                                    onChanged: (_) => _toggle(song.id),
                                  )
                                : null,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.isMultiple
            ? SafeArea(
                minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: FilledButton.icon(
                  onPressed: _selected.isEmpty ? null : _addSelected,
                  icon: const Icon(Icons.playlist_add_rounded),
                  label: Text(
                    context.tr(
                      AppString.playlistAddCount,
                      namedArgs: {'count': '${_selected.length}'},
                    ),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  void _toggle(String songId) => setState(() {
    _selected.contains(songId)
        ? _selected.remove(songId)
        : _selected.add(songId);
  });

  Future<void> _onSongTap(Mp3FileEntity song) async {
    if (widget.isMultiple) {
      _toggle(song.id);
      return;
    }
    await ref
        .read(playlistProvider.notifier)
        .addSongToPlaylist(playlistId: widget.playlistId, songId: song.id);
    await ref
        .read(playlistProvider.notifier)
        .getDetailPlaylistById(widget.playlistId);
    if (!mounted) return;
    AppOverlay.showToast(context, context.tr(AppString.playlistAddedSelected));
    Navigator.pop(context);
  }

  Future<void> _addSelected() async {
    await ref
        .read(playlistProvider.notifier)
        .addSongsToPlaylists(
          playlistIds: [widget.playlistId],
          songIds: _selected.toList(),
        );
    await ref
        .read(playlistProvider.notifier)
        .getDetailPlaylistById(widget.playlistId);
    if (!mounted) return;
    AppOverlay.showToast(context, context.tr(AppString.playlistAddedSelected));
    Navigator.pop(context);
  }
}
