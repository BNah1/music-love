import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class BottomOptionTile extends StatelessWidget {
  const BottomOptionTile({super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return ListTile(
      onTap: onTap,
      title: Text(title),
      trailing: selected
          ? Icon(
        Icons.check_circle_rounded,
        color: appTheme.accentColor,
      )
          : null,
    );
  }
}