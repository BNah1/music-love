import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/feature/library/domain/repository/playlist_repository.dart';
import 'package:musiclove/feature/library/presentation/provider/library_provider.dart';
import 'package:musiclove/feature/playlist/presentation/state/playlist_state.dart';
import 'package:musiclove/shared/entity/playlist_detail_enity.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';

final playlistProvider =
StateNotifierProvider<PlaylistNotifier, PlaylistState>((ref) {
  final repository = ref.read(playlistRepositoryProvider);

  return PlaylistNotifier(
    repository: repository,
  )..loadPlaylists();
});


class PlaylistNotifier extends StateNotifier<PlaylistState>{

  final PlaylistRepository repository;

  PlaylistNotifier({
    required this.repository,
  }) : super(const PlaylistState());


  Future<void> loadPlaylists() async {
    stateLoading();

    try {
      final playlists = await repository.getAllPlaylists();
      stateLoadedPlaylists(playlists);
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> getDetailPlaylistById(String playlistId) async{
    try {
      final playlist = await repository.getPlaylistDetail(playlistId);
      stateLoadedCurrentPlaylist(playlist);
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> createPlaylist(String name) async {
    final playlistName = name.trim();

    if (playlistName.isEmpty) {
      stateError('Tên playlist không được để trống');
      return;
    }

    try {
      await repository.createPlaylist(playlistName);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> renamePlaylist({
    required String playlistId,
    required String name,
  }) async {
    final playlistName = name.trim();

    if (playlistName.isEmpty) {
      stateError('Tên playlist không được để trống');
      return;
    }

    try {
      await repository.renamePlaylist(
        playlistId: playlistId,
        name: playlistName,
      );

      await loadPlaylists();

      final currentPlaylistId = state.currentPlaylist?.playlist.id;

      if (currentPlaylistId == playlistId) {
        await getDetailPlaylistById(playlistId);
      }
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> removeSongFromPlaylist({
    required String playlistId,
    required String songId,
  }) async {
    try {
      await repository.removeSongFromPlaylist(playlistId: playlistId, songId: songId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }

  // Future<void> renamePlaylist({
  //   required String playlistId,
  //   required String name,
  // }) async {
  //   final playlistName = name.trim();
  //
  //   if (playlistName.isEmpty) {
  //     state = state.copyWith(
  //       status: BaseStatus.error,
  //       errorMessage: 'Tên playlist không được để trống',
  //     );
  //     return;
  //   }
  //
  //   try {
  //     await repository.renamePlaylist(
  //       playlistId: playlistId,
  //       name: playlistName,
  //     );
  //
  //     await loadPlaylists();
  //   } catch (e) {
  //     stateError(e.toString());
  //   }
  // }

  Future<void> deletePlaylist(String playlistId) async {
    try {
      await repository.deletePlaylist(playlistId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> clearPlaylist(String playlistId) async {
    try {
      await repository.clearPlaylist(playlistId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }


  Future<void> moveSongUp({
    required String playlistId,
    required String songId,
  })async {
    try {
      await repository.moveSongUp(playlistId: playlistId, songId: songId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> moveSongDown({
    required String playlistId,
    required String songId,
  })async {
    try {
      await repository.moveSongDown(playlistId: playlistId, songId: songId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> moveSongToTop({
    required String playlistId,
    required String songId,
  })async {
    try {
      await repository.moveSongToTop(playlistId: playlistId, songId: songId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> moveSongToBottom({
    required String playlistId,
    required String songId,
  })async {
    try {
      await repository.moveSongToBottom(playlistId: playlistId, songId: songId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }

  Future<void> addSongToPlaylist({
    required String playlistId,
    required String songId,
  })async {
    try {
      await repository.addSongToPlaylist(playlistId: playlistId, songId: songId);
      await loadPlaylists();
    } catch (e) {
      stateError(e.toString());
    }
  }


  ///////////////////////////////

  void stateLoadedPlaylists(List<PlaylistEntity> playlists){
    state = state.copyWith(
      playlists: playlists,
      status: playlists.isEmpty ? BaseStatus.empty : BaseStatus.loaded,
      errorMessage: '',
    );
  }

  void stateLoadedCurrentPlaylist(PlaylistDetailEntity? playlist){
    state = state.copyWith(
      currentPlaylist: playlist,
      status: playlist != null ? BaseStatus.empty : BaseStatus.loaded,
      errorMessage: '',
    );
  }

  void stateLoading(){
    state = state.copyWith(
      status: BaseStatus.loading,
      errorMessage: '',
    );
  }

  void stateError(String error){
    state = state.copyWith(
      status: BaseStatus.error,
      errorMessage: error,
    );
  }

  void stateScanning(){
    state = state.copyWith(
      status: BaseStatus.loading,
      errorMessage: '',
    );
  }

}