import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/home/presentation/provider/home_provider.dart';
import 'package:musiclove/feature/home/presentation/view/widget/search_box_widget.dart';
import 'package:musiclove/shared/widget/music_column_tile_widget.dart';
import 'package:musiclove/shared/widget/song_sort_menu.dart';

class AllSongsView extends ConsumerWidget {
  const AllSongsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.extensionOf(context);
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final songs = state.filteredSongs;

    return Container(
      decoration: BoxDecoration(gradient: theme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(context.tr(AppString.allSongsTitle)),
          actions: [
            SongSortMenu(
              value: state.sortOption,
              onChanged: notifier.changeSort,
            ),
          ],
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SearchMusicBox(
                  query: state.searchQuery,
                  onChanged: notifier.searchSongs,
                  onClear: notifier.clearSearch,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: songs.isEmpty
                      ? Center(
                          child: Text(
                            context.tr(AppString.homeNoMatchingSongs),
                            style: TextStyle(color: theme.subtitleColor),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.only(bottom: 110),
                          itemCount: songs.length,
                          itemBuilder: (_, index) =>
                              MusicColumnTileWidget(song: songs[index]),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
