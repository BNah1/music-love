import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/feature/playlist/presentation/view/widget/edit_playlist_widget.dart';
import 'package:musiclove/shared/widget/music_column_tile_widget.dart';

class PlaylistDetailView extends ConsumerStatefulWidget {
  final String playlistId;

  const PlaylistDetailView({super.key, required this.playlistId});

  @override
  ConsumerState<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends ConsumerState<PlaylistDetailView> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final notifier = ref.read(playlistProvider.notifier);
    await notifier.getDetailPlaylistById(widget.playlistId);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);
    final state = ref.watch(playlistProvider);
    final detail = state.currentPlaylist;

    if (detail == null) {
      return Container(
        decoration: BoxDecoration(gradient: appTheme.backgroundGradient),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text(
              context.tr(AppString.playlistNotFound),
              style: TextStyle(color: appTheme.subtitleColor),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: appTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            EditPlaylistWidget(
              playlist: detail.playlist,
              onDeleted: () {
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              onRenamed: _load,
            ),
          ],
          backgroundColor: Colors.transparent,
          title: Text(detail.playlist.name),
        ),
        body: detail.songs.isEmpty
            ? Center(
                child: Text(
                  context.tr(AppString.playlistNoSongs),
                  style: TextStyle(color: appTheme.subtitleColor),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 110),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        context.tr(
                          AppString.playlistSongsCount,
                          namedArgs: {'count': '${detail.songs.length}'},
                        ),
                        style: TextStyle(color: appTheme.subtitleColor),
                      ),
                    ),
                    ...detail.songs.map(
                      (song) => MusicColumnTileWidget(
                        song: song,
                        currentPlaylistId: detail.playlist.id,
                        onChanged: _load,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
