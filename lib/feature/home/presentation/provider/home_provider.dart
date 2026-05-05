import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/feature/home/presentation/state/home_state.dart';
import 'package:musiclove/feature/library/domain/repository/song_repository.dart';
import 'package:musiclove/feature/library/presentation/provider/library_provider.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

final homeProvider = StateNotifierProvider<HomeNotifier,HomeState>((ref){
  final songRepository = ref.read(songRepositoryProvider);

  return HomeNotifier(
    songRepository: songRepository,
  )..loadSongs();
});


class HomeNotifier extends StateNotifier<HomeState>{
  final SongRepository songRepository;

  HomeNotifier({
    required this.songRepository,
  }) : super(const HomeState());


  Future<void> loadSongs() async{
    stateLoading();

    try{
      final songs = await songRepository.getAllSongs();
      stateLoaded(songs);

    }catch(e){
      stateError(e.toString());
    }

  }

  Future<void> scanSongs() async{
    if(state.isScanning) return;

    stateScanning();

    try{
      final songs = await songRepository.scanLocalSongs();

      stateLoaded(songs);

    }catch(e){
      stateError(e.toString());
    }
  }











  ///////////////////////////////

  void stateLoaded(List<Mp3FileEntity> songs){
    state = state.copyWith(
      songs: songs,
      status: songs.isEmpty ? BaseStatus.empty : BaseStatus.loaded,
      errorMessage: '',
      isScanning: false,
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
      isScanning: false,
    );
  }

  void stateScanning(){
    state = state.copyWith(
      status: BaseStatus.loading,
      isScanning: true,
      errorMessage: '',
    );
  }
}