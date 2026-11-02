import 'package:musiclove/shared/entity/mp3_file_entity.dart';

class Mp3FileModel extends Mp3FileEntity {
  const Mp3FileModel({
    required super.id,
    required super.path,
    required super.title,
    super.artist = "Unknown Artist",
    super.album,
    required super.duration,
    required super.size,
    super.artworkPath,
    required super.dateAdded,
    super.isFavorite = false,
  });

  factory Mp3FileModel.fromEntity(Mp3FileEntity entity) {
    return Mp3FileModel(
      id: entity.id,
      path: entity.path,
      title: entity.title,
      artist: entity.artist,
      album: entity.album,
      duration: entity.duration,
      size: entity.size,
      artworkPath: entity.artworkPath,
      dateAdded: entity.dateAdded,
      isFavorite: entity.isFavorite,
    );
  }

  factory Mp3FileModel.fromMap(Map<String, dynamic> map) {
    return Mp3FileModel(
      id: map['id']?.toString() ?? '',
      path: map['path']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      artist: map['artist']?.toString(),
      album: map['album']?.toString(),
      duration: map['duration'] ?? 0,
      size: map['size'] ?? 0,
      artworkPath: map['artworkPath']?.toString(),
      dateAdded: map['dateAdded'] ?? 0,
      isFavorite: map['isFavorite'] == 1 || map['isFavorite'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'size': size,
      'artworkPath': artworkPath,
      'dateAdded': dateAdded,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }
}