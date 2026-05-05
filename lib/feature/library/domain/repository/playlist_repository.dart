import 'package:musiclove/shared/entity/playlist_detail_enity.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';

abstract class PlaylistRepository {
  Future<void> createPlaylist(String name);

  PlaylistEntity? getPlaylistById(String playlistId);

  Future<PlaylistDetailEntity?> getPlaylistDetail(String playlistId);

  Future<List<PlaylistEntity>> getAllPlaylists();

  Future<void> renamePlaylist({
    required String playlistId,
    required String name,
  });

  Future<void> addSongToPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<void> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  });

  Future<void> moveSongUp({
    required String playlistId,
    required String songId,
  });

  Future<void> moveSongDown({
    required String playlistId,
    required String songId,
  });

  Future<void> moveSongToTop({
    required String playlistId,
    required String songId,
  });

  Future<void> moveSongToBottom({
    required String playlistId,
    required String songId,
  });

  Future<void> clearPlaylist(String playlistId);

  Future<void> deletePlaylist(String playlistId);
}