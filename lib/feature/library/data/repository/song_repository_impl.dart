import 'package:musiclove/feature/library/data/datasource/music_scanner_datasource.dart';
import 'package:musiclove/feature/library/data/datasource/song_local_datasource.dart';
import 'package:musiclove/feature/library/domain/repository/song_repository.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

class SongRepositoryImpl implements SongRepository {
  final SongLocalDataSource localDataSource;
  final MusicScannerDataSource scannerDataSource;

  SongRepositoryImpl({
    required this.localDataSource,
    required this.scannerDataSource,
  });

  @override
  Future<void> upsertSongs(List<Mp3FileEntity> songs) {
    return localDataSource.upsertSongs(songs);
  }

  @override
  Future<List<Mp3FileEntity>> getAllSongs() {
    return localDataSource.getAllSongs();
  }

  @override
  Future<Mp3FileEntity?> getSongById(String id) {
    return localDataSource.getSongById(id);
  }

  @override
  Future<List<Mp3FileEntity>> scanLocalSongs() async {
    final scannedSongs = await scannerDataSource.scanLocalSongs();

    if (scannedSongs.isNotEmpty) {
      await localDataSource.upsertSongs(scannedSongs);
    }

    return localDataSource.getAllSongs();
  }
}