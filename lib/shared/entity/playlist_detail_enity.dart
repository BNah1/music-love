import 'package:musiclove/shared/entity/mp3_file_entity.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';

class PlaylistDetailEntity {
  final PlaylistEntity playlist;
  final List<Mp3FileEntity> songs;

  const PlaylistDetailEntity({
    required this.playlist,
    required this.songs,
  });
}