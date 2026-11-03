import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_string.dart';
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
      SnackBar(content: Text(context.tr(AppString.playerCacheCleared))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(AppString.settingsPlayer))),
      body: _buildPlayerSection(context),
    );
  }

  Widget _buildPlayerSection(BuildContext context) {
    return SettingCard(
      title: context.tr(AppString.settingsPlayer),
      icon: Icons.graphic_eq_rounded,
      children: [
        SwitchTile(
          title: context.tr(AppString.settingsPlayerResume),
          subtitle: context.tr(AppString.settingsPlayerResumeDesc),
          value: _resumeLastSong,
          onChanged: (value) async {
            await _repo.setBool(SettingKeys.resumeLastSong, value);

            setState(() {
              _resumeLastSong = value;
            });
          },
        ),
        SwitchTile(
          title: context.tr(AppString.settingsPlayerDefaultShuffle),
          subtitle: context.tr(AppString.settingsPlayerDefaultShuffleDesc),
          value: _defaultShuffle,
          onChanged: (value) async {
            await _repo.setBool(SettingKeys.defaultShuffle, value);

            setState(() {
              _defaultShuffle = value;
            });
          },
        ),
        SelectTile(
          title: context.tr(AppString.settingsPlayerDefaultRepeat),
          subtitle: _repeatLabel(context, _defaultRepeat),
          onTap: () => _showRepeatModeSheet(context),
        ),
        SwitchTile(
          title: context.tr(AppString.settingsPlayerKeepNotification),
          subtitle: context.tr(AppString.settingsPlayerKeepNotificationDesc),
          value: _keepNotificationWhenPause,
          onChanged: (value) async {
            await _repo.setBool(SettingKeys.keepNotificationWhenPause, value);

            setState(() {
              _keepNotificationWhenPause = value;
            });
          },
        ),
        ActionTile(
          title: context.tr(AppString.settingsPlayerClearCache),
          subtitle: context.tr(AppString.settingsPlayerClearCacheDesc),
          icon: Icons.cleaning_services_outlined,
          onTap: _clearPlayerCache,
        ),
      ],
    );
  }

  Future<void> _showRepeatModeSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      showDragHandle: true,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomOptionTile(
                title: bottomSheetContext.tr(AppString.repeatNone),
                selected: _defaultRepeat == 'none',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setDefaultRepeat('none');
                },
              ),
              BottomOptionTile(
                title: bottomSheetContext.tr(AppString.repeatAll),
                selected: _defaultRepeat == 'all',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setDefaultRepeat('all');
                },
              ),
              BottomOptionTile(
                title: bottomSheetContext.tr(AppString.repeatOne),
                selected: _defaultRepeat == 'one',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setDefaultRepeat('one');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _repeatLabel(BuildContext context, String value) {
    switch (value) {
      case 'all':
        return context.tr(AppString.repeatAll);
      case 'one':
        return context.tr(AppString.repeatOne);
      case 'none':
      default:
        return context.tr(AppString.repeatNone);
    }
  }
}
