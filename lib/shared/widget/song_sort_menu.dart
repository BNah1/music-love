import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/song_sort_option.dart';
import 'package:musiclove/core/constant/theme.dart';

class SongSortMenu extends StatelessWidget {
  const SongSortMenu({super.key, required this.value, required this.onChanged});

  final SongSortOption value;
  final ValueChanged<SongSortOption> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.extensionOf(context);
    return PopupMenuButton<SongSortOption>(
      initialValue: value,
      tooltip: context.tr(AppString.songSort),
      onSelected: onChanged,
      icon: Icon(Icons.sort_rounded, color: theme.accentColor),
      itemBuilder: (_) => SongSortOption.values
          .map(
            (option) => PopupMenuItem(
              value: option,
              child: Row(
                children: [
                  Icon(
                    option == value
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(context.tr(_key(option))),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  String _key(SongSortOption option) => switch (option) {
    SongSortOption.newest => AppString.songSortNewest,
    SongSortOption.title => AppString.songSortTitle,
    SongSortOption.artist => AppString.songSortArtist,
  };
}
