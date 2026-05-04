class PlaylistModel {
  final String id;
  final String name;
  final List<String> songIds;
  final int createdAt;
  final int updatedAt;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.songIds,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'songIds': songIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
      id: map['id'],
      name: map['name'],
      songIds: List<String>.from(map['songIds'] ?? []),
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  PlaylistModel copyWith({
    String? id,
    String? name,
    List<String>? songIds,
    int? createdAt,
    int? updatedAt,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}