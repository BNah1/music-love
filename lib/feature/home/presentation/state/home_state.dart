import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/state/base_state.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

class HomeState extends BaseState {
  final List<Mp3FileEntity> songs;
  final bool isScanning;
  final String searchQuery;
  final bool isSearch;

  const HomeState({
    this.songs = const [],
    this.isScanning = false,
    this.isSearch = false,
    this.searchQuery = '',
    super.status = BaseStatus.initial,
    super.errorMessage = '',
  });

  bool get isSearching => searchQuery.trim().isNotEmpty;

  List<Mp3FileEntity> get filteredSongs {
    final keyword = searchQuery.trim().toLowerCase();

    if (keyword.isEmpty) {
      return songs;
    }

    return songs.where((song) {
      final title = song.title.toLowerCase();
      final artist = song.artist?.toLowerCase() ?? '';
      final album = song.album?.toLowerCase() ?? '';

      return title.contains(keyword) ||
          artist.contains(keyword) ||
          album.contains(keyword);
    }).toList();
  }

  @override
  HomeState copyWith({
    List<Mp3FileEntity>? songs,
    bool? isScanning,
    bool? isSearch,
    String? searchQuery,
    BaseStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      songs: songs ?? this.songs,
      isScanning: isScanning ?? this.isScanning,
      isSearch: isSearch ?? this.isSearch,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}