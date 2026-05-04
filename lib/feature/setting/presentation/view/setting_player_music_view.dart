import 'package:flutter/material.dart';
import 'package:musiclove/feature/setting/domain/repository/setting_repository.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/action_tile_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/bottom_option_tile.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/select_tile_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/setting_card_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/switch_tile_widget.dart';

class SettingPlayerMusicView extends StatefulWidget {
  const SettingPlayerMusicView({super.key});

  @override
  State<SettingPlayerMusicView> createState() => _SettingPlayerMusicViewState();
}

class _SettingPlayerMusicViewState extends State<SettingPlayerMusicView> {
  final SettingRepository _repo = SettingRepository();


  late bool _resumeLastSong;
  late bool _defaultShuffle;
  late String _defaultRepeat;
  late bool _keepNotificationWhenPause;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {


    _resumeLastSong = _repo.getBool(
      SettingKeys.resumeLastSong,
      defaultValue: true,
    );

    _defaultShuffle = _repo.getBool(
      SettingKeys.defaultShuffle,
      defaultValue: false,
    );

    _defaultRepeat = _repo.getString(
      SettingKeys.defaultRepeat,
      defaultValue: 'none',
    );

    _keepNotificationWhenPause = _repo.getBool(
      SettingKeys.keepNotificationWhenPause,
      defaultValue: true,
    );
  }


  Future<void> _setDefaultRepeat(String value) async {
    await _repo.setString(SettingKeys.defaultRepeat, value);

    setState(() {
      _defaultRepeat = value;
    });
  }

  Future<void> _clearPlayerCache() async {
    await _repo.box.delete('last_session');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã xóa cache trình phát nhạc'),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Trình phát nhạc'),),
        body: _buildPlayerSection());
  }


  Widget _buildPlayerSection() {
    return SettingCard(
      title: 'Trình phát nhạc',
      icon: Icons.graphic_eq_rounded,
      children: [
        SwitchTile(
          title: 'Tiếp tục bài đang nghe',
          subtitle: 'Mở app lần sau có thể nghe tiếp bài đã pause',
          value: _resumeLastSong,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.resumeLastSong,
              value,
            );

            setState(() {
              _resumeLastSong = value;
            });
          },
        ),
        SwitchTile(
          title: 'Mặc định phát ngẫu nhiên',
          subtitle: 'Bật shuffle khi phát playlist',
          value: _defaultShuffle,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.defaultShuffle,
              value,
            );

            setState(() {
              _defaultShuffle = value;
            });
          },
        ),
        SelectTile(
          title: 'Chế độ lặp mặc định',
          subtitle: _repeatLabel(_defaultRepeat),
          onTap: _showRepeatModeSheet,
        ),
        SwitchTile(
          title: 'Giữ notification khi pause',
          subtitle: 'Dễ resume nhạc từ thanh thông báo',
          value: _keepNotificationWhenPause,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.keepNotificationWhenPause,
              value,
            );

            setState(() {
              _keepNotificationWhenPause = value;
            });
          },
        ),
        ActionTile(
          title: 'Xóa cache trình phát',
          subtitle: 'Xóa bài đang nghe, vị trí nghe và queue đã lưu',
          icon: Icons.cleaning_services_outlined,
          onTap: _clearPlayerCache,
        ),
      ],
    );
  }


  Future<void> _showRepeatModeSheet() async {
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
                title: 'Không lặp',
                selected: _defaultRepeat == 'none',
                onTap: () {
                  Navigator.pop(context);
                  _setDefaultRepeat('none');
                },
              ),
              BottomOptionTile(
                title: 'Lặp tất cả',
                selected: _defaultRepeat == 'all',
                onTap: () {
                  Navigator.pop(context);
                  _setDefaultRepeat('all');
                },
              ),
              BottomOptionTile(
                title: 'Lặp một bài',
                selected: _defaultRepeat == 'one',
                onTap: () {
                  Navigator.pop(context);
                  _setDefaultRepeat('one');
                },
              ),
            ],
          ),
        );
      },
    );
  }


  String _repeatLabel(String value) {
    switch (value) {
      case 'all':
        return 'Lặp tất cả';
      case 'one':
        return 'Lặp một bài';
      case 'none':
      default:
        return 'Không lặp';
    }
  }
}
