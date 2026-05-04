import 'package:flutter/material.dart';
import 'package:musiclove/feature/setting/domain/repository/setting_repository.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final SettingRepository _repo = SettingRepository();

  late String _themeMode;
  late bool _autoPlayWhenHeadphoneConnected;
  late bool _pauseWhenHeadphoneDisconnected;
  late bool _showBluetoothDeviceName;

  late bool _autoScanLibrary;
  late bool _scanHiddenFiles;
  late String _librarySortType;

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
    _themeMode = _repo.getString(
      SettingKeys.themeMode,
      defaultValue: 'system',
    );

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

  Future<void> _setThemeMode(String value) async {
    await _repo.setString(SettingKeys.themeMode, value);

    setState(() {
      _themeMode = value;
    });
  }

  Future<void> _setLibrarySortType(String value) async {
    await _repo.setString(SettingKeys.librarySortType, value);

    setState(() {
      _librarySortType = value;
    });
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
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: const Color(0xFFF7F7FA),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: [
          _buildThemeSection(),
          const SizedBox(height: 16),
          _buildHeadphoneBluetoothSection(),
          const SizedBox(height: 16),
          _buildLibrarySection(),
          const SizedBox(height: 16),
          _buildPlayerSection(),
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
    return _SettingCard(
      title: 'Chủ đề',
      icon: Icons.palette_outlined,
      children: [
        _OptionTile(
          title: 'Theo hệ thống',
          subtitle: 'Tự đổi sáng/tối theo thiết bị',
          selected: _themeMode == 'system',
          onTap: () => _setThemeMode('system'),
        ),
        _OptionTile(
          title: 'Sáng',
          subtitle: 'Luôn dùng giao diện sáng',
          selected: _themeMode == 'light',
          onTap: () => _setThemeMode('light'),
        ),
        _OptionTile(
          title: 'Tối',
          subtitle: 'Luôn dùng giao diện tối',
          selected: _themeMode == 'dark',
          onTap: () => _setThemeMode('dark'),
        ),
      ],
    );
  }

  Widget _buildHeadphoneBluetoothSection() {
    return _SettingCard(
      title: 'Tai nghe / Bluetooth',
      icon: Icons.headphones_battery_outlined,
      children: [
        _SwitchTile(
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
        _SwitchTile(
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
        _SwitchTile(
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

  Widget _buildLibrarySection() {
    return _SettingCard(
      title: 'Thư viện',
      icon: Icons.library_music_outlined,
      children: [
        _SwitchTile(
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
        _SwitchTile(
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
        _SelectTile(
          title: 'Sắp xếp thư viện',
          subtitle: _librarySortLabel(_librarySortType),
          onTap: _showLibrarySortSheet,
        ),
        _ActionTile(
          title: 'Khôi phục cài đặt thư viện',
          subtitle: 'Đưa các tùy chọn thư viện về mặc định',
          icon: Icons.restore_rounded,
          onTap: _clearLibrarySettings,
        ),
      ],
    );
  }

  Widget _buildPlayerSection() {
    return _SettingCard(
      title: 'Trình phát nhạc',
      icon: Icons.graphic_eq_rounded,
      children: [
        _SwitchTile(
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
        _SwitchTile(
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
        _SelectTile(
          title: 'Chế độ lặp mặc định',
          subtitle: _repeatLabel(_defaultRepeat),
          onTap: _showRepeatModeSheet,
        ),
        _SwitchTile(
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
        _ActionTile(
          title: 'Xóa cache trình phát',
          subtitle: 'Xóa bài đang nghe, vị trí nghe và queue đã lưu',
          icon: Icons.cleaning_services_outlined,
          onTap: _clearPlayerCache,
        ),
      ],
    );
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
              _BottomOptionTile(
                title: 'Tên bài hát',
                selected: _librarySortType == 'name',
                onTap: () {
                  Navigator.pop(context);
                  _setLibrarySortType('name');
                },
              ),
              _BottomOptionTile(
                title: 'Ca sĩ',
                selected: _librarySortType == 'artist',
                onTap: () {
                  Navigator.pop(context);
                  _setLibrarySortType('artist');
                },
              ),
              _BottomOptionTile(
                title: 'Mới thêm',
                selected: _librarySortType == 'date',
                onTap: () {
                  Navigator.pop(context);
                  _setLibrarySortType('date');
                },
              ),
              _BottomOptionTile(
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
              _BottomOptionTile(
                title: 'Không lặp',
                selected: _defaultRepeat == 'none',
                onTap: () {
                  Navigator.pop(context);
                  _setDefaultRepeat('none');
                },
              ),
              _BottomOptionTile(
                title: 'Lặp tất cả',
                selected: _defaultRepeat == 'all',
                onTap: () {
                  Navigator.pop(context);
                  _setDefaultRepeat('all');
                },
              ),
              _BottomOptionTile(
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

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.pinkAccent,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      activeColor: Colors.pinkAccent,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      onChanged: onChanged,
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: selected
          ? const Icon(
        Icons.check_circle_rounded,
        color: Colors.pinkAccent,
      )
          : const Icon(
        Icons.circle_outlined,
        color: Colors.black26,
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  const _SelectTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(icon),
    );
  }
}

class _BottomOptionTile extends StatelessWidget {
  const _BottomOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: selected
          ? const Icon(
        Icons.check_circle_rounded,
        color: Colors.pinkAccent,
      )
          : null,
    );
  }
}