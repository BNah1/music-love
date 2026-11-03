import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/setting/domain/repository/setting_repository.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/option_tile_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/setting_card_widget.dart';

class SettingThemeView extends StatefulWidget {
  const SettingThemeView({super.key});

  @override
  State<SettingThemeView> createState() => _SettingThemeViewState();
}

class _SettingThemeViewState extends State<SettingThemeView> {
  final SettingRepository _repo = SettingRepository();
  late String _themeMode;
  late String _themeStyle;

  @override
  void initState() {
    _loadSettings();
    super.initState();
  }

  void _loadSettings() {
    _themeMode = _repo.getString(SettingKeys.themeMode, defaultValue: 'system');

    _themeStyle = _repo.getString(
      SettingKeys.themeStyle,
      defaultValue: AppThemePreset.musicLove.value,
    );
  }

  Future<void> _setThemeMode(String value) async {
    await _repo.setString(SettingKeys.themeMode, value);

    setState(() {
      _themeMode = value;
    });
  }

  Future<void> _setThemeStyle(String value) async {
    await _repo.setString(SettingKeys.themeStyle, value);

    setState(() {
      _themeStyle = value;
    });
  }

  Widget _buildThemeSection() {
    final selectedPreset = AppTheme.presetFromString(_themeStyle);

    return SettingCard(
      title: context.tr(AppString.settingsTheme),
      icon: Icons.palette_outlined,
      children: [
        OptionTile(
          title: context.tr(AppString.settingsThemeSystem),
          subtitle: context.tr(AppString.settingsThemeSystemDesc),
          selected: _themeMode == 'system',
          onTap: () => _setThemeMode('system'),
        ),
        OptionTile(
          title: context.tr(AppString.settingsThemeLight),
          subtitle: context.tr(AppString.settingsThemeLightDesc),
          selected: _themeMode == 'light',
          onTap: () => _setThemeMode('light'),
        ),
        OptionTile(
          title: context.tr(AppString.settingsThemeDark),
          subtitle: context.tr(AppString.settingsThemeDarkDesc),
          selected: _themeMode == 'dark',
          onTap: () => _setThemeMode('dark'),
        ),

        // const _SettingDivider(),

        // const _SettingSubTitle(title: 'Kiểu giao diện'),
        ...AppThemePreset.values.map(
          (preset) => _ThemePresetTile(
            preset: preset,
            selected: selectedPreset == preset,
            onTap: () => _setThemeStyle(preset.value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(AppString.settingsTheme))),
      body: _buildThemeSection(),
    );
  }
}

class _ThemePresetTile extends StatelessWidget {
  const _ThemePresetTile({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final AppThemePreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: preset.previewColors),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? appTheme.accentColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: appTheme.shadowColor,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          preset.icon,
          color: selected ? appTheme.selectedIconColor : Colors.white,
        ),
      ),
      title: Text(
        preset.label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(preset.subtitle),
      trailing: selected
          ? Icon(Icons.check_circle_rounded, color: appTheme.accentColor)
          : Icon(
              Icons.circle_outlined,
              color: appTheme.unselectedIconColor.withOpacity(0.45),
            ),
    );
  }
}
