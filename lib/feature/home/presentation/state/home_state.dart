import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/state/base_state.dart';
import 'package:musiclove/core/constant/song_sort_option.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

class HomeState extends BaseState {
  final List<Mp3FileEntity> songs;
  final bool isScanning;
  final String searchQuery;
  final bool isSearch;
  final SongSortOption sortOption;

  const HomeState({
    this.songs = const [],
    this.isScanning = false,
    this.isSearch = false,
    this.searchQuery = '',
    this.sortOption = SongSortOption.newest,
    super.status = BaseStatus.initial,
    super.errorMessage = '',
  });

  bool get isSearching => searchQuery.trim().isNotEmpty;

  List<Mp3FileEntity> get filteredSongs {
    final keyword = searchQuery.trim().toLowerCase();

    if (keyword.isEmpty) {
      return sortOption.sort(songs);
    }

    return sortOption.sort(
      songs.where((song) {
        final title = song.title.toLowerCase();
        final artist = song.artist?.toLowerCase() ?? '';
        final album = song.album?.toLowerCase() ?? '';

        return title.contains(keyword) ||
            artist.contains(keyword) ||
            album.contains(keyword);
      }).toList(),
    );
  }

  @override
  HomeState copyWith({
    List<Mp3FileEntity>? songs,
    bool? isScanning,
    bool? isSearch,
    String? searchQuery,
    SongSortOption? sortOption,
    BaseStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      songs: songs ?? this.songs,
      isScanning: isScanning ?? this.isScanning,
      isSearch: isSearch ?? this.isSearch,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
