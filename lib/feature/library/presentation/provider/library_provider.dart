import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:musiclove/feature/library/data/datasource/music_scanner_datasource.dart';
import 'package:musiclove/feature/library/data/datasource/playlist_local_datasource.dart';
import 'package:musiclove/feature/library/data/datasource/song_local_datasource.dart';
import 'package:musiclove/feature/library/data/repository/playlist_repository_impl.dart';
import 'package:musiclove/feature/library/data/repository/song_repository_impl.dart';
import 'package:musiclove/feature/library/domain/repository/playlist_repository.dart';
import 'package:musiclove/feature/library/domain/repository/song_repository.dart';

final songBoxProvider = Provider<Box>((ref) {
  return Hive.box('songs');
});

final playlistBoxProvider = Provider<Box>((ref) {
  return Hive.box('playlists');
});

final songLocalDataSourceProvider = Provider<SongLocalDataSource>((ref) {
  return SongLocalDataSourceImpl(
    box: ref.read(songBoxProvider),
  );
});

final playlistLocalDataSourceProvider =
Provider<PlaylistLocalDataSource>((ref) {
  return PlaylistLocalDataSourceImpl(
    box: ref.read(playlistBoxProvider),
  );
});

final musicScannerDataSourceProvider = Provider<MusicScannerDataSource>((ref) {
  return MusicScannerDataSourceImpl();
});

final songRepositoryProvider = Provider<SongRepository>((ref) {
  return SongRepositoryImpl(
    localDataSource: ref.read(songLocalDataSourceProvider),
    scannerDataSource: ref.read(musicScannerDataSourceProvider),
  );
});

final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return PlaylistRepositoryImpl(
    localDataSource: ref.read(playlistLocalDataSourceProvider),
    songRepository: ref.read(songRepositoryProvider),
  );
});