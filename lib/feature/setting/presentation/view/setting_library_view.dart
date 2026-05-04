import 'package:flutter/material.dart';
import 'package:musiclove/feature/setting/domain/repository/setting_repository.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/action_tile_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/bottom_option_tile.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/select_tile_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/setting_card_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/switch_tile_widget.dart';

class SettingLibraryView extends StatefulWidget {
  const SettingLibraryView({super.key});

  @override
  State<SettingLibraryView> createState() => _SettingLibraryViewState();
}

class _SettingLibraryViewState extends State<SettingLibraryView> {
  final SettingRepository _repo = SettingRepository();
  late bool _autoScanLibrary;
  late bool _scanHiddenFiles;
  late String _librarySortType;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _autoScanLibrary = _repo.getBool(
      SettingKeys.autoScanLibrary,
      defaultValue: true,
    );

    _scanHiddenFiles = _repo.getBool(
      SettingKeys.scanHiddenFiles,
      defaultValue: false,
    );

    _librarySortType = _repo.getString(
      SettingKeys.librarySortType,
      defaultValue: 'name',
    );
  }

  Future<void> _setLibrarySortType(String value) async {
    await _repo.setString(SettingKeys.librarySortType, value);

    setState(() {
      _librarySortType = value;
    });
  }

  Future<void> _clearLibrarySettings() async {
    await _repo.setBool(SettingKeys.autoScanLibrary, true);
    await _repo.setBool(SettingKeys.scanHiddenFiles, false);
    await _repo.setString(SettingKeys.librarySortType, 'name');

    setState(() {
      _autoScanLibrary = true;
      _scanHiddenFiles = false;
      _librarySortType = 'name';
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã khôi phục cài đặt thư viện'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Thư viện'),),
        body: _buildLibrarySection());
  }


  Widget _buildLibrarySection() {
    return SettingCard(
      title: 'Thư viện',
      icon: Icons.library_music_outlined,
      children: [
        SwitchTile(
          title: 'Tự quét nhạc khi mở app',
          subtitle: 'Tự cập nhật danh sách MP3 trong máy',
          value: _autoScanLibrary,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.autoScanLibrary,
              value,
            );

            setState(() {
              _autoScanLibrary = value;
            });
          },
        ),
        SwitchTile(
          title: 'Quét file ẩn',
          subtitle: 'Bao gồm các thư mục hoặc file bắt đầu bằng dấu chấm',
          value: _scanHiddenFiles,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.scanHiddenFiles,
              value,
            );

            setState(() {
              _scanHiddenFiles = value;
            });
          },
        ),
        SelectTile(
          title: 'Sắp xếp thư viện',
          subtitle: _librarySortLabel(_librarySortType),
          onTap: _showLibrarySortSheet,
        ),
        ActionTile(
          title: 'Khôi phục cài đặt thư viện',
          subtitle: 'Đưa các tùy chọn thư viện về mặc định',
          icon: Icons.restore_rounded,
          onTap: _clearLibrarySettings,
        ),
      ],
    );
  }

  String _librarySortLabel(String value) {
    switch (value) {
      case 'artist':
        return 'Ca sĩ';
      case 'date':
        return 'Mới thêm';
      case 'duration':
        return 'Thời lượng';
      case 'name':
      default:
        return 'Tên bài hát';
    }
  }

  Future<void> _showLibrarySortSheet() async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomOptionTile(
                title: 'Tên bài hát',
                selected: _librarySortType == 'name',
                onTap: () {
                  Navigator.pop(context);
                  _setLibrarySortType('name');
                },
              ),
              BottomOptionTile(
                title: 'Ca sĩ',
                selected: _librarySortType == 'artist',
                onTap: () {
                  Navigator.pop(context);
                  _setLibrarySortType('artist');
                },
              ),
              BottomOptionTile(
                title: 'Mới thêm',
                selected: _librarySortType == 'date',
                onTap: () {
                  Navigator.pop(context);
                  _setLibrarySortType('date');
                },
              ),
              BottomOptionTile(
                title: 'Thời lượng',
                selected: _librarySortType == 'duration',
                onTap: () {
                  Navigator.pop(context);
                  _setLibrarySortType('duration');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
