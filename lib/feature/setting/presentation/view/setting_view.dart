import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/app_config.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/setting/domain/repository/setting_repository.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/bottom_option_tile.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/select_tile_widget.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SettingRepository _repo = SettingRepository();
  late String _currentLanguageCode;

  @override
  void initState() {
    super.initState();
    _currentLanguageCode = _repo.getString(
      SettingKeys.languageCode,
      defaultValue: AppConfig.defaultLocale.languageCode,
    );
  }

  Future<void> _setLanguage(String languageCode) async {
    await context.setLocale(Locale(languageCode));
    await _repo.setString(SettingKeys.languageCode, languageCode);
    setState(() {
      _currentLanguageCode = languageCode;
    });
  }

  Future<void> _showLanguageSheet() async {
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
                title: bottomSheetContext.tr(AppString.settingsVietnamese),
                selected: _currentLanguageCode == 'vi',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setLanguage('vi');
                },
              ),
              BottomOptionTile(
                title: bottomSheetContext.tr(AppString.settingsEnglish),
                selected: _currentLanguageCode == 'en',
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  _setLanguage('en');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return Container(
      decoration: BoxDecoration(gradient: appTheme.backgroundGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            context.tr(AppString.settingsTitle),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            /// Ngôn ngữ
            _buildSettingItemTile(
              title: context.tr(AppString.settingsLanguage),
              subtitle: _currentLanguageCode == 'en'
                  ? context.tr(AppString.settingsEnglish)
                  : context.tr(AppString.settingsVietnamese),
              onTap: _showLanguageSheet,
            ),

            /// Chủ đề
            _buildSettingItemTile(
              title: context.tr(AppString.settingsTheme),
              onTap: () {
                context.push(AppRoutes.settingTheme);
              },
            ),

            _buildSettingItemTile(
              title: context.tr(AppString.settingsBluetooth),
              onTap: () {
                context.push(AppRoutes.settingBluetooth);
              },
            ),

            _buildSettingItemTile(
              title: context.tr(AppString.settingsLibrary),
              onTap: () {
                context.push(AppRoutes.settingLibrary);
              },
            ),

            _buildSettingItemTile(
              title: context.tr(AppString.settingsPlayer),
              onTap: () {
                context.push(AppRoutes.settingMusicPlayer);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItemTile({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final appTheme = AppTheme.extensionOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: appTheme.navBackground,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: appTheme.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SelectTile(title: title, subtitle: subtitle, onTap: onTap),
      ),
    );
  }
}
