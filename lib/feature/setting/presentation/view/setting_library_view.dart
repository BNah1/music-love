import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_string.dart';
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
      SnackBar(content: Text(context.tr(AppString.settingsLibraryRestored))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(AppString.settingsLibrary))),
      body: _buildLibrarySection(context),
    );
  }

  Widget _buildLibrarySection(BuildContext context) {
    return SettingCard(
      title: context.tr(AppString.settingsLibrary),
      icon: Icons.library_music_outlined,
      children: [
        SwitchTile(
          title: context.tr(AppString.settingsLibraryAutoScan),
          subtitle: context.tr(AppString.settingsLibraryAutoScanDesc),
          value: _autoScanLibrary,
          onChanged: (value) async {
            await _repo.setBool(SettingKeys.autoScanLibrary, value);

            setState(() {
              _autoScanLibrary = value;
            });
          },
        ),
        SwitchTile(
          title: context.tr(AppString.settingsLibraryScanHidden),
          subtitle: context.tr(AppString.settingsLibraryScanHiddenDesc),
          value: _scanHiddenFiles,
          onChanged: (value) async {
            await _repo.setBool(SettingKeys.scanHiddenFiles, value);

            setState(() {
              _scanHiddenFiles = value;
            });
          },
        ),
        SelectTile(
          title: context.tr(AppString.settingsLibrarySort),
          subtitle: _librarySortLabel(context, _librarySortType),
          onTap: () => _showLibrarySortSheet(context),
        ),
        ActionTile(
          title: context.tr(AppString.settingsLibraryRestore),
          subtitle: context.tr(AppString.settingsLibraryRestoreDesc),
          icon: Icons.restore_rounded,
          onTap: _clearLibrarySettings,
        ),
      ],
    );
  }

  String _librarySortLabel(BuildContext context, String value) {
    switch (value) {
      case 'artist':
        return context.tr(AppString.settingsSortArtist);
      case 'date':
        return context.tr(AppString.settingsSortDate);
      case 'duration':
        return context.tr(AppString.settingsSortDuration);
      case 'name':
      default:
        return context.tr(AppString.settingsSortName);
    }
  }

  Future<void> _showLibrarySortSheet(BuildContext context) async {
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
                title: bottomSheetContext.tr(AppString.settingsSortName),
                selected: _librarySortType == 'name',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setLibrarySortType('name');
                },
              ),
              BottomOptionTile(
                title: bottomSheetContext.tr(AppString.settingsSortArtist),
                selected: _librarySortType == 'artist',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setLibrarySortType('artist');
                },
              ),
              BottomOptionTile(
                title: bottomSheetContext.tr(AppString.settingsSortDate),
                selected: _librarySortType == 'date',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setLibrarySortType('date');
                },
              ),
              BottomOptionTile(
                title: bottomSheetContext.tr(AppString.settingsSortDuration),
                selected: _librarySortType == 'duration',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
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
