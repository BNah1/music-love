import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class ActionTile extends StatelessWidget {
  const ActionTile({super.key,
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
    final appTheme = AppTheme.extensionOf(context);

    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: Icon(
        icon,
        color: appTheme.accentColor,
      ),
    );
  }
}