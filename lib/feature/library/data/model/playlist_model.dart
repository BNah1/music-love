import 'package:musiclove/shared/entity/playlist_entity.dart';

class PlaylistModel extends PlaylistEntity {
  const PlaylistModel({
    required super.id,
    required super.name,
    required super.songIds,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PlaylistModel.fromEntity(PlaylistEntity entity) {
    return PlaylistModel(
      id: entity.id,
      name: entity.name,
      songIds: entity.songIds,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      songIds: List<String>.from(map['songIds'] ?? []),
      createdAt: map['createdAt'] ?? 0,
      updatedAt: map['updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'songIds': songIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}