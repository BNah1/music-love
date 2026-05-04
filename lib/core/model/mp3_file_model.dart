class Mp3FileModel {
  final String id;           // Unique ID (thường lấy từ on_audio_query hoặc path hash)
  final String path;         // Đường dẫn tuyệt đối tới file trong máy
  final String title;        // Tên bài hát
  final String? artist;      // Nghệ sĩ
  final String? album;       // Tên album
  final int duration;        // Thời lượng (miliseconds)
  final int size;            // Dung lượng file (để lọc file rác)
  final String? artworkPath; // Đường dẫn tới ảnh cover đã cache (nếu có)
  final int dateAdded;       // Ngày thêm vào máy (để làm tính năng "Gần đây")
  bool isFavorite;           // Trạng thái yêu thích

  Mp3FileModel({
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

  factory Mp3FileModel.fromMap(Map<String, dynamic> map) {
    return Mp3FileModel(
      id: map['id'],
      path: map['path'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      duration: map['duration'],
      size: map['size'],
      artworkPath: map['artworkPath'],
      dateAdded: map['dateAdded'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}