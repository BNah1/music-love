class Mp3FileEntity {
  final String id;
  final String path;
  final String title;
  final String? artist;
  final String? album;
  final int duration;
  final int size;
  final String? artworkPath;
  final int dateAdded;
  final bool isFavorite;

  const Mp3FileEntity({
    required this.id,
    required this.path,
    required this.title,
    this.artist = "Unknown Artist",
    this.album,
    required this.duration,
    required this.size,
    this.artworkPath,
    required this.dateAdded,
    this.isFavorite = false,
  });

  Mp3FileEntity copyWith({
    String? id,
    String? path,
    String? title,
    String? artist,
    String? album,
    int? duration,
    int? size,
    String? artworkPath,
    int? dateAdded,
    bool? isFavorite,
  }) {
    return Mp3FileEntity(
      id: id ?? this.id,
      path: path ?? this.path,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      artworkPath: artworkPath ?? this.artworkPath,
      dateAdded: dateAdded ?? this.dateAdded,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}