import 'package:flutter_test/flutter_test.dart';
import 'package:musiclove/core/constant/app_enum.dart';
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
}
