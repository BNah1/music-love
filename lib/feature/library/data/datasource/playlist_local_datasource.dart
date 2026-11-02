import 'package:hive/hive.dart';
import 'package:musiclove/feature/library/data/model/playlist_model.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';

abstract class PlaylistLocalDataSource {
  Future<void> createPlaylist(String name);

  PlaylistEntity? getPlaylistById(String playlistId);

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

class PlaylistLocalDataSourceImpl implements PlaylistLocalDataSource {
  final Box box;

  PlaylistLocalDataSourceImpl({
    required this.box,
  });

  @override
  Future<void> createPlaylist(String name) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = now.toString();

    final playlist = PlaylistModel(
      id: id,
      name: name,
      songIds: const [],
      createdAt: now,
      updatedAt: now,
    );

    await box.put(
      id,
      playlist.toMap(),
    );
  }

  @override
  PlaylistEntity? getPlaylistById(String playlistId) {
    final data = box.get(playlistId);

    if (data == null) return null;

    return PlaylistModel.fromMap(
      Map<String, dynamic>.from(data),
    );
  }

  @override
  Future<List<PlaylistEntity>> getAllPlaylists() async {
    return box.values.map((item) {
      return PlaylistModel.fromMap(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  @override
  Future<void> renamePlaylist({
    required String playlistId,
    required String name,
  }) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    final updated = playlist.copyWith(
      name: name,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    if (playlist.songIds.contains(songId)) return;

    final updated = playlist.copyWith(
      songIds: [
        ...playlist.songIds,
        songId,
      ],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    final updatedSongIds = playlist.songIds.where((id) {
      return id != songId;
    }).toList();

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> moveSongUp({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    final index = playlist.songIds.indexOf(songId);

    if (index <= 0) return;

    final updatedSongIds = [
      ...playlist.songIds,
    ];

    final temp = updatedSongIds[index - 1];
    updatedSongIds[index - 1] = updatedSongIds[index];
    updatedSongIds[index] = temp;

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> moveSongDown({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    final index = playlist.songIds.indexOf(songId);

    if (index < 0 || index >= playlist.songIds.length - 1) return;

    final updatedSongIds = [
      ...playlist.songIds,
    ];

    final temp = updatedSongIds[index + 1];
    updatedSongIds[index + 1] = updatedSongIds[index];
    updatedSongIds[index] = temp;

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> moveSongToTop({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    final updatedSongIds = [
      ...playlist.songIds,
    ];

    final removed = updatedSongIds.remove(songId);

    if (!removed) return;

    updatedSongIds.insert(0, songId);

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> moveSongToBottom({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    final updatedSongIds = [
      ...playlist.songIds,
    ];

    final removed = updatedSongIds.remove(songId);

    if (!removed) return;

    updatedSongIds.add(songId);

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> clearPlaylist(String playlistId) async {
    final playlist = getPlaylistById(playlistId);

    if (playlist == null) return;

    final updated = playlist.copyWith(
      songIds: const [],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  @override
  Future<void> deletePlaylist(String playlistId) async {
    await box.delete(playlistId);
  }

  Future<void> _savePlaylist(PlaylistEntity playlist) async {
    final model = PlaylistModel.fromEntity(playlist);

    await box.put(
      model.id,
      model.toMap(),
    );
  }
}