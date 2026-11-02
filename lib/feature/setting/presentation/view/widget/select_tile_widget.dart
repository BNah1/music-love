import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class SelectTile extends StatelessWidget {
  const SelectTile({super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: appTheme.unselectedIconColor,
      ),
    );
  }
}