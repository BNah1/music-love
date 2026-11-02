import 'package:musiclove/shared/entity/mp3_file_entity.dart';

abstract class SongRepository {
  Future<void> upsertSongs(List<Mp3FileEntity> songs);

  Future<List<Mp3FileEntity>> getAllSongs();

  Future<Mp3FileEntity?> getSongById(String id);

  Future<List<Mp3FileEntity>> scanLocalSongs();
}