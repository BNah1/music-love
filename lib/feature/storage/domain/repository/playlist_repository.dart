import 'package:hive/hive.dart';
import 'package:musiclove/feature/storage/data/model/playlist_model.dart';

class PlaylistRepository {
  final Box box = Hive.box('playlists');

  Future<void> createPlaylist(String name) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final id = now.toString();

    final playlist = PlaylistModel(
      id: id,
      name: name,
      songIds: [],
      createdAt: now,
      updatedAt: now,
    );

    await box.put(id, playlist.toMap());
  }

  PlaylistModel? getPlaylistById(String playlistId) {
    final data = box.get(playlistId);
    if (data == null) return null;

    return PlaylistModel.fromMap(
      Map<String, dynamic>.from(data),
    );
  }

  List<PlaylistModel> getAllPlaylists() {
    return box.values
        .map((e) => PlaylistModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> addSongToPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);
    if (playlist == null) return;

    if (playlist.songIds.contains(songId)) return;

    final updated = playlist.copyWith(
      songIds: [...playlist.songIds, songId],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  Future<void> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);
    if (playlist == null) return;

    final updatedSongIds = playlist.songIds
        .where((id) => id != songId)
        .toList();

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  Future<void> moveSongUp({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);
    if (playlist == null) return;

    final index = playlist.songIds.indexOf(songId);

    if (index <= 0) return;

    final updatedSongIds = [...playlist.songIds];

    final temp = updatedSongIds[index - 1];
    updatedSongIds[index - 1] = updatedSongIds[index];
    updatedSongIds[index] = temp;

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  Future<void> moveSongDown({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);
    if (playlist == null) return;

    final index = playlist.songIds.indexOf(songId);

    if (index < 0 || index >= playlist.songIds.length - 1) return;

    final updatedSongIds = [...playlist.songIds];

    final temp = updatedSongIds[index + 1];
    updatedSongIds[index + 1] = updatedSongIds[index];
    updatedSongIds[index] = temp;

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  Future<void> moveSongToTop({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);
    if (playlist == null) return;

    final updatedSongIds = [...playlist.songIds];

    final removed = updatedSongIds.remove(songId);
    if (!removed) return;

    updatedSongIds.insert(0, songId);

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  Future<void> moveSongToBottom({
    required String playlistId,
    required String songId,
  }) async {
    final playlist = getPlaylistById(playlistId);
    if (playlist == null) return;

    final updatedSongIds = [...playlist.songIds];

    final removed = updatedSongIds.remove(songId);
    if (!removed) return;

    updatedSongIds.add(songId);

    final updated = playlist.copyWith(
      songIds: updatedSongIds,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  Future<void> clearPlaylist(String playlistId) async {
    final playlist = getPlaylistById(playlistId);
    if (playlist == null) return;

    final updated = playlist.copyWith(
      songIds: [],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _savePlaylist(updated);
  }

  Future<void> deletePlaylist(String playlistId) async {
    await box.delete(playlistId);
  }

  Future<void> _savePlaylist(PlaylistModel playlist) async {
    await box.put(playlist.id, playlist.toMap());
  }
}