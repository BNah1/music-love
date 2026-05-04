import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/core/model/mp3_file_model.dart';
import 'package:musiclove/feature/storage/data/model/playlist_model.dart';
import 'package:musiclove/feature/storage/domain/repository/playlist_repository.dart';
import 'package:musiclove/shared/widget/music_column_tile_widget.dart';

class PlaylistDetailView extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailView({
    super.key,
    required this.playlistId,
  });

  @override
  State<PlaylistDetailView> createState() => _PlaylistDetailViewState();
}

class _PlaylistDetailViewState extends State<PlaylistDetailView> {
  final _repo = PlaylistRepository();

  PlaylistModel? _playlist;
  List<Mp3FileModel> _songs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final data = _repo.box.get(widget.playlistId);
    if (data == null) return;

    _playlist = PlaylistModel.fromMap(
      Map<String, dynamic>.from(data),
    );

    final songBox = Hive.box('songs');

    _songs = _playlist!.songIds
        .map((id) {
          final s = songBox.get(id);
          if (s == null) return null;
          return Mp3FileModel.fromMap(
            Map<String, dynamic>.from(s),
          );
        })
        .whereType<Mp3FileModel>()
        .toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    if (_playlist == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: appTheme.backgroundGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text(
              'Không tìm thấy playlist',
              style: TextStyle(color: appTheme.subtitleColor),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(_playlist!.name),
        ),
        body: _songs.isEmpty
            ? Center(
                child: Text(
                  'Chưa có bài hát',
                  style: TextStyle(color: appTheme.subtitleColor),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(bottom: 110),
                itemCount: _songs.length,
                itemBuilder: (_, index) {
                  final song = _songs[index];

                  return MusicColumnTileWidget(
                    song: song,
                    currentPlaylistId: _playlist!.id,
                    onChanged: _load,
                  );
                },
              ),
      ),
    );
  }
}
