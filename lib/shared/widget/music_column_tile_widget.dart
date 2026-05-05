import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';

import 'more_vert_widget.dart';

class MusicColumnTileWidget extends StatelessWidget {
  const MusicColumnTileWidget({
    super.key,
    required this.song,
    this.currentPlaylistId,
    this.onChanged,
  });

  final Mp3FileEntity song;
  final String? currentPlaylistId;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      onTap: () {
        if (currentPlaylistId != null) {
          context.push('${AppRoutes.playMusic}/${song.id}?playlistId=$currentPlaylistId');
        } else {
          context.push('${AppRoutes.playMusic}/${song.id}');
        }
      },
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: appTheme.musicCardGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: appTheme.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          Icons.play_arrow_rounded,
          color: appTheme.selectedIconColor,
        ),
      ),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: appTheme.textColor,
        ),
      ),
      subtitle: Text(
        song.artist ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: appTheme.subtitleColor),
      ),
      trailing: MoreVertWidget(
        song: song,
        currentPlaylistId: currentPlaylistId,
        onChanged: onChanged,
      ),
    );
  }
}
