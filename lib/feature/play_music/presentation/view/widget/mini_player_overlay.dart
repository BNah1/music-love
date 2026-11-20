import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constant/routes.dart';
import '../../../../../core/provider/audio_handler_provider.dart';
import '../../../../../shared/widget/player_display_widgets.dart';

class MiniPlayerOverlay extends ConsumerWidget {
  const MiniPlayerOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioHandler = ref.watch(audioHandlerProvider);

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, mediaSnapshot) {
        final item = mediaSnapshot.data;
        if (item == null) return const SizedBox.shrink();

        return StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, stateSnapshot) {
            final isPlaying = stateSnapshot.data?.playing == true;

            return MiniPlayerDisplay(
              title: item.title,
              artist: item.artist ?? '',
              artworkPath: item.artUri?.toFilePath(),
              isPlaying: isPlaying,
              onOpen: () {
                final path = item.extras?['path'] as String?;
                final playlistId = item.extras?['playlistId'] as String?;
                if (path == null) return;
                final location = Uri(
                  path: '${AppRoutes.playMusic}/${item.id}',
                  queryParameters: playlistId != null && playlistId.isNotEmpty
                      ? {'playlistId': playlistId}
                      : null,
                ).toString();
                context.push(location);
              },
              onPlayPause: () {
                isPlaying ? audioHandler.pause() : audioHandler.play();
              },
            );
          },
        );
      },
    );
  }
}
