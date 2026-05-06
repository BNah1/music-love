import 'package:flutter/cupertino.dart';

class MenuItem {
  final int index;
  final String path;
  final IconData icon;
  final String label;

  const MenuItem({
    required this.index,
    required this.path,
    required this.icon,
    required this.label,
  });
}