import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/model/mp3_file_model.dart';

import 'more_vert_widget.dart';

class MusicColumnTileWidget extends StatelessWidget {
  const MusicColumnTileWidget({
    super.key,
    required this.song,
    this.currentPlaylistId,
    this.onChanged,
  });

  final Mp3FileModel song;
  final String? currentPlaylistId;
  final VoidCallback? onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      onTap: () {
        if(
        currentPlaylistId!= null
        ){
          context.push('${AppRoutes.playMusic}/${song.id}?playlistId=$currentPlaylistId');
        }else{
          context.push('${AppRoutes.playMusic}/${song.id}');
        }
      },
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.pink[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: Colors.pinkAccent,
        ),
      ),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        song.artist ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: MoreVertWidget(
        song: song,
        currentPlaylistId: currentPlaylistId,
        onChanged: onChanged,
      ),
    );
  }
}