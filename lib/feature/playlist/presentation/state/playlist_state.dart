import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/state/base_state.dart';
import 'package:musiclove/shared/entity/playlist_detail_enity.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';


class PlaylistState extends BaseState {
  final List<PlaylistEntity> playlists;
  final PlaylistDetailEntity? currentPlaylist;

  const PlaylistState({
    this.playlists = const [],
    super.status = BaseStatus.initial,
    super.errorMessage = '', this.currentPlaylist,
  });

  @override
  PlaylistState copyWith({
    List<PlaylistEntity>? playlists,
    PlaylistDetailEntity? currentPlaylist,
    BaseStatus? status,
    String? errorMessage,
  }) {
    return PlaylistState(
      playlists: playlists ?? this.playlists,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
        currentPlaylist: currentPlaylist ?? this.currentPlaylist
    );
  }
}