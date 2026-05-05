import 'package:hive/hive.dart';
import 'package:musiclove/feature/library/data/model/mp3_file_model.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

abstract class SongLocalDataSource {
  Future<void> upsertSongs(List<Mp3FileEntity> songs);

  Future<List<Mp3FileEntity>> getAllSongs();

  Future<Mp3FileEntity?> getSongById(String id);
}

class SongLocalDataSourceImpl implements SongLocalDataSource {
  final Box box;

  SongLocalDataSourceImpl({
    required this.box,
  });

  @override
  Future<void> upsertSongs(List<Mp3FileEntity> songs) async {
    for (final song in songs) {
      final model = Mp3FileModel.fromEntity(song);
      await box.put(model.id, model.toMap());
    }
  }

  @override
  Future<List<Mp3FileEntity>> getAllSongs() async {
    return box.values
        .map((item) {
      return Mp3FileModel.fromMap(
        Map<String, dynamic>.from(item),
      );
    })
        .toList();
  }

  @override
  Future<Mp3FileEntity?> getSongById(String id) async {
    final data = box.get(id);

    if (data == null) return null;

    return Mp3FileModel.fromMap(
      Map<String, dynamic>.from(data),
    );
  }
}