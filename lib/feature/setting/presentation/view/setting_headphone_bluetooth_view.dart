import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/feature/setting/domain/repository/setting_repository.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/setting_card_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/switch_tile_widget.dart';

class SettingHeadphoneBluetoothView extends StatefulWidget {
  const SettingHeadphoneBluetoothView({super.key});

  @override
  State<SettingHeadphoneBluetoothView> createState() =>
      _SettingHeadphoneBluetoothViewState();
}

class _SettingHeadphoneBluetoothViewState
    extends State<SettingHeadphoneBluetoothView> {
  final SettingRepository _repo = SettingRepository();
  late bool _autoPlayWhenHeadphoneConnected;
  late bool _pauseWhenHeadphoneDisconnected;
  late bool _showBluetoothDeviceName;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    _autoPlayWhenHeadphoneConnected = _repo.getBool(
      SettingKeys.autoPlayWhenHeadphoneConnected,
      defaultValue: false,
    );

    _pauseWhenHeadphoneDisconnected = _repo.getBool(
      SettingKeys.pauseWhenHeadphoneDisconnected,
      defaultValue: true,
    );

    _showBluetoothDeviceName = _repo.getBool(
      SettingKeys.showBluetoothDeviceName,
      defaultValue: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr(AppString.settingsBluetooth))),
      body: _buildHeadphoneBluetoothSection(context),
    );
  }

  Widget _buildHeadphoneBluetoothSection(BuildContext context) {
    return SettingCard(
      title: context.tr(AppString.settingsBluetooth),
      icon: Icons.headphones_battery_outlined,
      children: [
        SwitchTile(
          title: context.tr(AppString.settingsBluetoothAutoplay),
          subtitle: context.tr(AppString.settingsBluetoothAutoplayDesc),
          value: _autoPlayWhenHeadphoneConnected,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.autoPlayWhenHeadphoneConnected,
              value,
            );

            setState(() {
              _autoPlayWhenHeadphoneConnected = value;
            });
          },
        ),
        SwitchTile(
          title: context.tr(AppString.settingsBluetoothPause),
          subtitle: context.tr(AppString.settingsBluetoothPauseDesc),
          value: _pauseWhenHeadphoneDisconnected,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.pauseWhenHeadphoneDisconnected,
              value,
            );

            setState(() {
              _pauseWhenHeadphoneDisconnected = value;
            });
          },
        ),
        SwitchTile(
          title: context.tr(AppString.settingsBluetoothDeviceName),
          subtitle: context.tr(AppString.settingsBluetoothDeviceNameDesc),
          value: _showBluetoothDeviceName,
          onChanged: (value) async {
            await _repo.setBool(SettingKeys.showBluetoothDeviceName, value);

            setState(() {
              _showBluetoothDeviceName = value;
            });
          },
        ),
      ],
    );
  }
}
