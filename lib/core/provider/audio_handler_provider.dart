import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/audio/coordinated_audio_handler.dart';

final audioHandlerProvider = Provider<AudioHandler>((ref) {
  throw UnimplementedError('AudioHandler chưa được khởi tạo trong main.dart');
});

final coordinatedAudioHandlerProvider = Provider<CoordinatedAudioHandler>((
  ref,
) {
  throw UnimplementedError('AudioService chưa được khởi tạo trong main.dart');
});
