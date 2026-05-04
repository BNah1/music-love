import 'package:flutter/material.dart';
import 'package:musiclove/feature/setting/domain/repository/setting_repository.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/setting_card_widget.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/switch_tile_widget.dart';

class SettingHeadphoneBluetoothView extends StatefulWidget {
  const SettingHeadphoneBluetoothView({super.key});

  @override
  State<SettingHeadphoneBluetoothView> createState() => _SettingHeadphoneBluetoothViewState();
}

class _SettingHeadphoneBluetoothViewState extends State<SettingHeadphoneBluetoothView> {
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
        appBar: AppBar(title: Text('Tai nghe - Bluetooth'),),
        body: _buildHeadphoneBluetoothSection());
  }


  Widget _buildHeadphoneBluetoothSection() {
    return SettingCard(
      title: 'Tai nghe / Bluetooth',
      icon: Icons.headphones_battery_outlined,
      children: [
        SwitchTile(
          title: 'Tự phát khi kết nối tai nghe',
          subtitle: 'Khi cắm tai nghe hoặc kết nối Bluetooth, tự phát bài đang nghe',
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
          title: 'Tạm dừng khi ngắt tai nghe',
          subtitle: 'Tự pause khi rút tai nghe hoặc mất kết nối Bluetooth',
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
          title: 'Hiển thị tên thiết bị Bluetooth',
          subtitle: 'Hiển thị tên tai nghe trong mini player nếu có',
          value: _showBluetoothDeviceName,
          onChanged: (value) async {
            await _repo.setBool(
              SettingKeys.showBluetoothDeviceName,
              value,
            );

            setState(() {
              _showBluetoothDeviceName = value;
            });
          },
        ),
      ],
    );
  }
}
