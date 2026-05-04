import 'package:flutter/material.dart';
import 'package:musiclove/feature/storage/domain/repository/song_repository.dart';
import 'package:musiclove/shared/service/scan_service.dart';
import 'package:musiclove/shared/widget/music_column_tile_widget.dart';
import 'package:musiclove/shared/widget/music_row_tile_widget.dart';
import 'core/model/mp3_file_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier<List<Mp3FileModel>> _songsNotifier =
  ValueNotifier<List<Mp3FileModel>>(MockData.getSongs());

  bool _isScanning = false;

  @override
  void initState() {
    // final cache = Hive.box('player_cache').get('last_session');
    init();
    super.initState();
  }

  @override
  void dispose() {
    _songsNotifier.dispose();
    super.dispose();
  }

  init(){
    final repo = SongRepository();
    final songs = repo.getAllSongs();

    if (songs.isNotEmpty) {
      _songsNotifier.value = songs;
    }
  }

  // Hàm xử lý khi bấm nút Scan
  Future<void> _onScanPressed() async {
    setState(() => _isScanning = true);

    final scanner = MusicScannerService();
    final newSongs = await scanner.scanLocalSongs();

    if (newSongs.isNotEmpty) {
      final repo = SongRepository();

      await repo.upsertSongs(newSongs);

      _songsNotifier.value = repo.getAllSongs();
    }

    setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: ValueListenableBuilder<List<Mp3FileModel>>(
          valueListenable: _songsNotifier,
          builder: (context, currentSongs, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 30),
                  _buildSectionTitle("Gần đây"),
                  const SizedBox(height: 15),
                  _buildRecentList(currentSongs),
                  const SizedBox(height: 30),
                  _buildSectionTitle("Tất cả bài hát"),
                  _buildSuggestionGrid(currentSongs),
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Chào buổi sáng! 🌸", style: TextStyle(fontSize: 16, color: Colors.grey)),
              Text("Bonah Music", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          ),
          // Nút SCAN được thiết kế style Chibi bo tròn
          GestureDetector(
            onTap: _isScanning ? null : _onScanPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isScanning ? Colors.grey[300] : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: _isScanning
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.sync_rounded, color: Colors.pinkAccent),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }

  Widget _buildRecentList(List<Mp3FileModel> songs) {
    return SizedBox(
      height: 150,
      child: songs.isEmpty
          ? const Center(child: Text("Trống"))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: songs.length > 5 ? 5 : songs.length,
        itemBuilder: (context, index) => MusicRowTileWidget(song: songs[index]),
      ),
    );
  }

  Widget _buildSuggestionGrid(List<Mp3FileModel> songs) {
    return songs.isEmpty
        ? const Padding(padding: EdgeInsets.only(top: 50), child: Center(child: Text("Hãy bấm scan để tìm nhạc")))
        : ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: songs.length,
      itemBuilder: (context, index) => MusicColumnTileWidget(song: songs[index]),
    );
  }
}

class MockData {
  static List<Mp3FileModel> getSongs() {
    return [
      Mp3FileModel(
        id: '1',
        path: '/storage/emulated/0/Music/song1.mp3',
        title: 'Nắng Ấm Xa Dần',
        artist: 'Sơn Tùng M-TP',
        duration: 210000,
        size: 5000000,
        dateAdded: 1714800000,
        isFavorite: true,
      ),
      Mp3FileModel(
        id: '2',
        path: '/storage/emulated/0/Music/song2.mp3',
        title: 'Waiting For You',
        artist: 'MONO',
        duration: 185000,
        size: 4500000,
        dateAdded: 1714810000,
      ),
      Mp3FileModel(
        id: '3',
        path: '/storage/emulated/0/Music/song3.mp3',
        title: 'Thích Em Hơi Nhiều',
        artist: 'Wren Evans',
        duration: 192000,
        size: 4800000,
        dateAdded: 1714820000,
        isFavorite: true,
      ),
    ];
  }
}