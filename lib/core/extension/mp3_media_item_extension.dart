import 'package:audio_service/audio_service.dart';
import 'package:musiclove/core/model/mp3_file_model.dart';

extension Mp3MediaItemExtension on Mp3FileModel {
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