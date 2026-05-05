import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/home/presentation/provider/home_provider.dart';
import 'package:musiclove/feature/home/presentation/state/home_state.dart';
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

    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _buildBody(
            context: context,
            state: state,
            onScanPressed: notifier.scanSongs,
            onRetryPressed: notifier.loadSongs,
          ),
        ),
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required HomeState state,
    required VoidCallback onScanPressed,
    required VoidCallback onRetryPressed,
  }) {
    if (state.status == BaseStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.status == BaseStatus.error) {
      return _buildErrorBody(
        context: context,
        message: state.errorMessage,
        onRetryPressed: onRetryPressed,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HomeHeader(
            isScanning: state.isScanning,
            onScanPressed: onScanPressed,
          ),
          const SizedBox(height: 30),
          const _SectionTitle(title: 'Gần đây'),
          const SizedBox(height: 15),
          _RecentList(songs: state.songs),
          const SizedBox(height: 30),
          const _SectionTitle(title: 'Tất cả bài hát'),
          _SuggestionList(songs: state.songs),
          const SizedBox(height: 100),
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
              message.isEmpty ? 'Có lỗi xảy ra' : message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: appTheme.textColor,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetryPressed,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onScanPressed;

  const _HomeHeader({
    required this.isScanning,
    required this.onScanPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào buổi sáng! 🌸',
                style: TextStyle(
                  fontSize: 16,
                  color: appTheme.subtitleColor,
                ),
              ),
              Text(
                'Bonah Music',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: appTheme.textColor,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: isScanning ? null : onScanPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isScanning
                    ? Theme.of(context).disabledColor
                    : appTheme.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: appTheme.shadowColor,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: isScanning
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : Icon(
                Icons.sync_rounded,
                color: appTheme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

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

  const _RecentList({
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: songs.isEmpty
          ? const Center(
        child: Text('Trống'),
      )
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length > 5 ? 5 : songs.length,
        itemBuilder: (context, index) {
          return MusicRowTileWidget(
            song: songs[index],
          );
        },
      ),
    );
  }
}

class _SuggestionList extends StatelessWidget {
  final List<Mp3FileEntity> songs;

  const _SuggestionList({
    required this.songs,
  });

  @override
  Widget build(BuildContext context) {
    if (songs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 50),
        child: Center(
          child: Text('Hãy bấm scan để tìm nhạc'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        return MusicColumnTileWidget(
          song: songs[index],
        );
      },
    );
  }
}