import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/state/base_state.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

class HomeState extends BaseState {
  final List<Mp3FileEntity> songs;
  final bool isScanning;

  const HomeState({
    this.songs = const [],
    this.isScanning = false,
    super.status = BaseStatus.initial,
    super.errorMessage = '',
  });

  @override
  HomeState copyWith({
    List<Mp3FileEntity>? songs,
    bool? isScanning,
    BaseStatus? status,
    String? errorMessage,
  }) {
    return HomeState(
      songs: songs ?? this.songs,
      isScanning: isScanning ?? this.isScanning,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}