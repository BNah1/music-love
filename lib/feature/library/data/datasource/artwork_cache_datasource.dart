import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:path_provider/path_provider.dart';

abstract class ArtworkCacheDataSource {
  Future<String?> cacheArtwork({
    required String songId,
    required List<Picture> pictures,
  });
}

class ArtworkCacheDataSourceImpl implements ArtworkCacheDataSource {
  ArtworkCacheDataSourceImpl({Future<Directory> Function()? directoryProvider})
    : _directoryProvider = directoryProvider;

  final Future<Directory> Function()? _directoryProvider;
  Future<Directory>? _cacheDirectory;

  static const int _maxArtworkBytes = 5 * 1024 * 1024;

  @override
  Future<String?> cacheArtwork({
    required String songId,
    required List<Picture> pictures,
  }) async {
    final validPictures = pictures.where(_isValid).toList();
    if (validPictures.isEmpty) return null;

    final picture = validPictures.firstWhere(
      (item) => item.pictureType == PictureType.coverFront,
      orElse: () => validPictures.first,
    );
    final extension = _extensionFor(picture.mimetype);
    if (extension == null) return null;

    final directory = await (_cacheDirectory ??= _createCacheDirectory());
    final safeId = songId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final file = File('${directory.path}/$safeId.$extension');

    if (await file.exists() && await file.length() == picture.bytes.length) {
      return file.path;
    }

    await file.writeAsBytes(picture.bytes, flush: true);
    return file.path;
  }

  bool _isValid(Picture picture) {
    return picture.bytes.isNotEmpty &&
        picture.bytes.length <= _maxArtworkBytes &&
        _extensionFor(picture.mimetype) != null;
  }

  String? _extensionFor(String mimeType) {
    return switch (mimeType.toLowerCase()) {
      'image/jpeg' || 'image/jpg' => 'jpg',
      'image/png' => 'png',
      _ => null,
    };
  }

  Future<Directory> _createCacheDirectory() async {
    final customDirectory = _directoryProvider;
    if (customDirectory != null) {
      final directory = await customDirectory();
      if (!await directory.exists()) await directory.create(recursive: true);
      return directory;
    }
    final supportDirectory = await getApplicationSupportDirectory();
    final directory = Directory('${supportDirectory.path}/song_artwork');
    if (!await directory.exists()) await directory.create(recursive: true);
    return directory;
  }
}
