import 'package:musiclove/shared/entity/mp3_file_entity.dart';

enum SongSortOption { newest, title, artist }

extension SongSortOptionX on SongSortOption {
  List<Mp3FileEntity> sort(List<Mp3FileEntity> songs) {
    final result = [...songs];
    switch (this) {
      case SongSortOption.newest:
        result.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
      case SongSortOption.title:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
      case SongSortOption.artist:
        result.sort((a, b) {
          final artistCompare = (a.artist ?? '').toLowerCase().compareTo(
            (b.artist ?? '').toLowerCase(),
          );
          return artistCompare != 0
              ? artistCompare
              : a.title.toLowerCase().compareTo(b.title.toLowerCase());
        });
    }
    return result;
  }
}
