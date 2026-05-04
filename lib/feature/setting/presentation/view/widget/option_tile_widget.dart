import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class OptionTile extends StatelessWidget {
  const OptionTile({super.key,
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
    final appTheme = AppTheme.extensionOf(context);

    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: selected
          ? Icon(
        Icons.check_circle_rounded,
        color: appTheme.accentColor,
      )
          : Icon(
        Icons.circle_outlined,
        color: appTheme.unselectedIconColor.withOpacity(0.45),
      ),
    );
  }
}