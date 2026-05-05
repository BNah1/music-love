import 'dart:io';
import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/foundation.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class MusicScannerDataSource {
  Future<List<Mp3FileEntity>> scanLocalSongs();
}

class MusicScannerDataSourceImpl implements MusicScannerDataSource {
  @override
  Future<List<Mp3FileEntity>> scanLocalSongs() async {
    final hasPermission = await _requestStoragePermission();

    if (!hasPermission) return [];

    final rootDir = Directory('/storage/emulated/0/');
    final songs = <Mp3FileEntity>[];

    await _manualRecursiveScan(rootDir, songs);

    return songs;
  }

  Future<void> _manualRecursiveScan(
      Directory dir,
      List<Mp3FileEntity> songs,
      ) async {
    try {
      final entities = dir.list(
        recursive: false,
        followLinks: false,
      );

      await for (final entity in entities) {
        final path = entity.path;

        if (path.contains('/Android') || path.split('/').last.startsWith('.')) {
          continue;
        }

        if (entity is File && path.toLowerCase().endsWith('.mp3')) {
          final song = await _createSongFromFile(entity);
          songs.add(song);
        } else if (entity is Directory) {
          await _manualRecursiveScan(entity, songs);
        }
      }
    } catch (e) {
      debugPrint('Không thể đọc thư mục ${dir.path}: $e');
    }
  }

  Future<Mp3FileEntity> _createSongFromFile(File file) async {
    final path = file.path;

    try {
      final metadata = readMetadata(file);

      return Mp3FileEntity(
        id: path.hashCode.toString(),
        path: path,
        title: metadata.title ?? path.split('/').last,
        artist: metadata.artist ?? 'Unknown Artist',
        duration: metadata.duration?.inMilliseconds ?? 0,
        size: await file.length(),
        dateAdded: DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      return Mp3FileEntity(
        id: path.hashCode.toString(),
        path: path,
        title: path.split('/').last,
        artist: 'Unknown Artist',
        duration: 0,
        size: await file.length(),
        dateAdded: DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.audio.request().isGranted ||
        await Permission.storage.request().isGranted) {
      return true;
    }

    return false;
  }
}