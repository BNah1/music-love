import 'package:audio_service/audio_service.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

extension Mp3MediaItemExtension on Mp3FileEntity {
  MediaItem toMediaItem() {
    return MediaItem(
      id: id,
      title: title,
      artist: artist,
      duration: Duration(milliseconds: duration),
      extras: {
        'path': path,
        'album': album,
        'artworkPath': artworkPath,
        'size': size,
        'dateAdded': dateAdded,
      },
    );
  }
}