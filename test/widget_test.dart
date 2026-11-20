import 'package:flutter_test/flutter_test.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/song_sort_option.dart';
import 'package:musiclove/feature/home/presentation/state/home_state.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

void main() {
  test('HomeState filters songs by title, artist, and album', () {
    const state = HomeState(
      status: BaseStatus.loaded,
      songs: [
        Mp3FileEntity(
          id: '1',
          path: '/music/one.mp3',
          title: 'One Love',
          artist: 'Artist A',
          album: 'First Album',
          duration: 1000,
          size: 1,
          dateAdded: 1,
        ),
        Mp3FileEntity(
          id: '2',
          path: '/music/two.mp3',
          title: 'Two',
          artist: 'Artist B',
          album: 'Second Album',
          duration: 1000,
          size: 1,
          dateAdded: 1,
        ),
      ],
      searchQuery: 'first album',
    );

    expect(state.filteredSongs.map((song) => song.id), ['1']);
  });

  test('HomeState sorts songs without mutating the original list', () {
    const songs = [
      Mp3FileEntity(
        id: '2',
        path: '/music/two.mp3',
        title: 'Zulu',
        artist: 'Beta',
        duration: 1000,
        size: 1,
        dateAdded: 20,
      ),
      Mp3FileEntity(
        id: '1',
        path: '/music/one.mp3',
        title: 'Alpha',
        artist: 'Gamma',
        duration: 1000,
        size: 1,
        dateAdded: 10,
      ),
    ];

    const titleState = HomeState(
      songs: songs,
      sortOption: SongSortOption.title,
    );
    const newestState = HomeState(
      songs: songs,
      sortOption: SongSortOption.newest,
    );

    expect(titleState.filteredSongs.map((song) => song.id), ['1', '2']);
    expect(newestState.filteredSongs.map((song) => song.id), ['2', '1']);
    expect(songs.map((song) => song.id), ['2', '1']);
  });
}
