import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/home/presentation/provider/home_provider.dart';
import 'package:musiclove/feature/home/presentation/state/home_state.dart';
import 'package:musiclove/feature/home/presentation/view/widget/home_header_widget.dart';
import 'package:musiclove/feature/home/presentation/view/widget/search_box_widget.dart';
import 'package:musiclove/feature/playlist/presentation/provider/playlist_provider.dart';
import 'package:musiclove/shared/entity/playlist_entity.dart';
import 'package:musiclove/shared/entity/mp3_file_entity.dart';
import 'package:musiclove/shared/widget/music_column_tile_widget.dart';
import 'package:musiclove/shared/widget/music_row_tile_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme.extensionOf(context);
    final state = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);
    final playlists = ref.watch(playlistProvider).playlists;

    return Container(
      decoration: BoxDecoration(gradient: appTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _buildBody(
            context: context,
            state: state,
            onScanPressed: notifier.scanSongs,
            onRetryPressed: notifier.loadSongs,
            onSearchChanged: notifier.searchSongs,
            onClearSearch: notifier.clearSearch,
            onSearchPressed: notifier.pressSearch,
            playlists: playlists,
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required HomeState state,
    required VoidCallback onScanPressed,
    required VoidCallback onSearchPressed,
    required VoidCallback onRetryPressed,
    required ValueChanged<String> onSearchChanged,
    required VoidCallback onClearSearch,
    required List<PlaylistEntity> playlists,
  }) {
    if (state.status == BaseStatus.loading && state.songs.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == BaseStatus.error) {
      return _buildErrorBody(
        context: context,
        message: state.errorMessage,
        onRetryPressed: onRetryPressed,
      );
    }

    final songsToShow = state.filteredSongs;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(
            isScanning: state.isScanning,
            onScanPressed: onScanPressed,
            isSearch: state.isSearch,
            onSearchPressed: onSearchPressed,
          ),

          const SizedBox(height: 20),

          if (state.isSearch)
            SearchMusicBox(
              query: state.searchQuery,
              onChanged: onSearchChanged,
              onClear: onClearSearch,
            ),

          const SizedBox(height: 25),

          if (state.isSearching) ...[
            _SectionTitle(
              title: context.tr(
                AppString.homeSearchResults,
                namedArgs: {'count': '${songsToShow.length}'},
              ),
            ),
            const SizedBox(height: 10),
            _SearchResultList(songs: songsToShow),
          ] else ...[
            if (playlists.isNotEmpty) ...[
              _SectionTitle(title: context.tr(AppString.homePlaylists)),
              const SizedBox(height: 15),
              _PlaylistList(playlists: playlists),
              const SizedBox(height: 30),
            ],
            _SectionTitle(title: context.tr(AppString.homeRecent)),
            const SizedBox(height: 15),
            _RecentList(songs: state.songs),
            const SizedBox(height: 30),
            _SectionTitle(title: context.tr(AppString.homeAllSongs)),
            _SuggestionList(songs: state.songs),
          ],

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildErrorBody({
    required BuildContext context,
    required String message,
    required VoidCallback onRetryPressed,
  }) {
    final appTheme = AppTheme.extensionOf(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: appTheme.accentColor,
            ),
            const SizedBox(height: 16),
            Text(
              message.isEmpty ? context.tr(AppString.homeError) : message,
              textAlign: TextAlign.center,
              style: TextStyle(color: appTheme.textColor, fontSize: 15),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetryPressed,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.tr(AppString.homeRetry)),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaylistList extends StatelessWidget {
  final List<PlaylistEntity> playlists;

  const _PlaylistList({required this.playlists});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);
    return SizedBox(
      height: 112,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: playlists.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final playlist = playlists[index];
          return SizedBox(
            width: 170,
            child: Card(
              color: appTheme.cardBackground,
              child: InkWell(
                onTap: () =>
                    context.push(AppRoutes.playlistDetail(playlist.id)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.queue_music_rounded,
                        color: appTheme.accentColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        playlist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: appTheme.textColor,
                        ),
                      ),
                      Text(
                        context.tr(
                          AppString.playlistSongsCount,
                          namedArgs: {'count': '${playlist.songIds.length}'},
                        ),
                        style: TextStyle(color: appTheme.subtitleColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: appTheme.textColor,
      ),
    );
  }
}

class _RecentList extends StatelessWidget {
  final List<Mp3FileEntity> songs;

  const _RecentList({required this.songs});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: songs.isEmpty
          ? Center(child: Text(context.tr(AppString.homeEmpty)))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: songs.length > 5 ? 5 : songs.length,
              itemBuilder: (context, index) {
                return MusicRowTileWidget(song: songs[index]);
              },
            ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  final List<Mp3FileEntity> songs;

  const _SuggestionList({required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Center(child: Text(context.tr(AppString.homeScanToFind))),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return MusicColumnTileWidget(song: songs[index]);
      },
    );
  }
}

class _SearchResultList extends StatelessWidget {
  final List<Mp3FileEntity> songs;

  const _SearchResultList({required this.songs});

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Center(child: Text(context.tr(AppString.homeNoMatchingSongs))),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return MusicColumnTileWidget(song: songs[index]);
      },
    );
  }
}
