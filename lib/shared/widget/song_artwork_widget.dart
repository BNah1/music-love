import 'dart:io';

import 'package:flutter/material.dart';

class SongArtworkWidget extends StatelessWidget {
  const SongArtworkWidget({
    super.key,
    required this.artworkPath,
    required this.fallback,
    this.borderRadius = BorderRadius.zero,
    this.fit = BoxFit.cover,
  });

  final String? artworkPath;
  final Widget fallback;
  final BorderRadius borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final path = artworkPath;
    if (path == null || path.isEmpty || !File(path).existsSync()) {
      return fallback;
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.file(
        File(path),
        width: double.infinity,
        height: double.infinity,
        fit: fit,
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}
