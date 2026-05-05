class PlaylistEntity {
  final String id;
  final String name;
  final List<String> songIds;
  final int createdAt;
  final int updatedAt;

  const PlaylistEntity({
    required this.id,
    required this.name,
    required this.songIds,
    required this.createdAt,
    required this.updatedAt,
  });

  PlaylistEntity copyWith({
    String? id,
    String? name,
    List<String>? songIds,
    int? createdAt,
    int? updatedAt,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}