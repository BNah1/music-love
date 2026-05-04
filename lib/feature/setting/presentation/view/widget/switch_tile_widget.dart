import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class SwitchTile extends StatelessWidget {
  const SwitchTile({super.key,
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
    final appTheme = AppTheme.extensionOf(context);

    return SwitchListTile(
      value: value,
      activeColor: appTheme.accentColor,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      onChanged: onChanged,
    );
  }
}