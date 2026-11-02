import 'package:musiclove/feature/library/data/datasource/playlist_local_datasource.dart';
import 'package:musiclove/feature/library/domain/repository/playlist_repository.dart';
import 'package:musiclove/feature/library/domain/repository/song_repository.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';
import 'package:musiclove/shared/entity/playlist_detail_enity.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistLocalDataSource localDataSource;
  final SongRepository songRepository;

  PlaylistRepositoryImpl({
    required this.localDataSource,
    required this.songRepository,
  });

  @override
  Future<void> createPlaylist(String name) {
    return localDataSource.createPlaylist(name);
  }

  @override
  PlaylistEntity? getPlaylistById(String playlistId) {
    return localDataSource.getPlaylistById(playlistId);
  }

  @override
  Future<List<PlaylistEntity>> getAllPlaylists() {
    return localDataSource.getAllPlaylists();
  }

  @override
  Future<void> renamePlaylist({
    required String playlistId,
    required String name,
  }) {
    return localDataSource.renamePlaylist(
      playlistId: playlistId,
      name: name,
    );
  }

  @override
  Future<void> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) {
    return localDataSource.addSongToPlaylist(
      playlistId: playlistId,
      songId: songId,
    );
  }

  @override
  Future<void> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) {
    return localDataSource.removeSongFromPlaylist(
      playlistId: playlistId,
      songId: songId,
    );
  }

  @override
  Future<void> moveSongUp({
    required String playlistId,
    required String songId,
  }) {
    return localDataSource.moveSongUp(
      playlistId: playlistId,
      songId: songId,
    );
  }

  @override
  Future<void> moveSongDown({
    required String playlistId,
    required String songId,
  }) {
    return localDataSource.moveSongDown(
      playlistId: playlistId,
      songId: songId,
    );
  }

  @override
  Future<void> moveSongToTop({
    required String playlistId,
    required String songId,
  }) {
    return localDataSource.moveSongToTop(
      playlistId: playlistId,
      songId: songId,
    );
  }

  @override
  Future<void> moveSongToBottom({
    required String playlistId,
    required String songId,
  }) {
    return localDataSource.moveSongToBottom(
      playlistId: playlistId,
      songId: songId,
    );
  }

  @override
  Future<void> clearPlaylist(String playlistId) {
    return localDataSource.clearPlaylist(playlistId);
  }

  @override
  Future<void> deletePlaylist(String playlistId) {
    return localDataSource.deletePlaylist(playlistId);
  }

  @override
  Future<PlaylistDetailEntity?> getPlaylistDetail(String playlistId) async {
    final playlist = localDataSource.getPlaylistById(playlistId);

    if (playlist == null) return null;

    final allSongs = await songRepository.getAllSongs();

    final songs = playlist.songIds
        .map((songId) {
      try {
        return allSongs.firstWhere((song) => song.id == songId);
      } catch (_) {
        return null;
      }
    })
        .whereType<Mp3FileEntity>()
        .toList();

    return PlaylistDetailEntity(
      playlist: playlist,
      songs: songs,
    );
  }
}