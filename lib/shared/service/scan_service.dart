import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/cupertino.dart';
import 'package:musiclove/core/model/mp3_file_model.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicScannerService {

  Future<List<Mp3FileModel>> scanLocalSongs() async {
    bool hasPermission = await _requestStoragePermission();
    print("DEBUG: Quyền truy cập = $hasPermission");
    if (!hasPermission) return [];

    debugPrint("===> [START SCAN] Đang bắt đầu...");
    final rootDir = Directory('/storage/emulated/0/');

    // Kiểm tra quyền thủ công trước khi quét

    final List<Mp3FileModel> songs = [];
    await _manualRecursiveScan(rootDir, songs);

    debugPrint("===> [FINISH SCAN] Tìm thấy tổng cộng: ${songs.length} bài.");
    return songs;
  }

  Future<void> _manualRecursiveScan(Directory dir, List<Mp3FileModel> songs) async {
    try {
      final entities = dir.list(recursive: false, followLinks: false);

      await for (var entity in entities) {
        final path = entity.path;

        // Bỏ qua Android folder và file ẩn
        if (path.contains('/Android') || path.split('/').last.startsWith('.')) {
          continue;
        }

        if (entity is File && path.toLowerCase().endsWith('.mp3')) {
          try {
            final metadata = await readMetadata(entity);
            songs.add(Mp3FileModel(
              id: path.hashCode.toString(),
              path: path,
              title: metadata.title ?? path.split('/').last,
              artist: metadata.artist ?? "Unknown Artist",
              duration: metadata.duration?.inMilliseconds ?? 0,
              size: await entity.length(),
              dateAdded: DateTime.now().millisecondsSinceEpoch,
            ));
            // debugPrint("      [+] Đã tìm thấy: ${metadata.title}");
          } catch (e) {
            songs.add(Mp3FileModel(
              id: path.hashCode.toString(),
              path: path,
              title: path.split('/').last,
              artist: "Unknown",
              duration: 0,
              size: await entity.length(),
              dateAdded: DateTime.now().millisecondsSinceEpoch,
            ));
          }
        } else if (entity is Directory) {
          await _manualRecursiveScan(entity, songs);
        }
      }
    } catch (e) {
      debugPrint("===> [PERMISSION/ERROR] Không thể đọc thư mục: ${dir.path} - Lỗi: $e");
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



