import 'package:hive/hive.dart';
import 'package:musiclove/core/model/mp3_file_model.dart';

class SongRepository {
  final Box box = Hive.box('songs');

  Future<void> upsertSongs(List<Mp3FileModel> songs) async {
    for (final song in songs) {
      await box.put(song.id, song.toMap());
    }
  }

  List<Mp3FileModel> getAllSongs() {
    return box.values
        .map((e) => Mp3FileModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Mp3FileModel? getSongById(String id) {
    final data = box.get(id);
    if (data == null) return null;

    return Mp3FileModel.fromMap(Map<String, dynamic>.from(data));
  }
}