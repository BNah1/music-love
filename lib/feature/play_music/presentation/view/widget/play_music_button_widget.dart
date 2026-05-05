import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/app_path.dart';
import 'package:musiclove/core/constant/theme.dart';

class PlayMusicButtonWidget extends StatelessWidget {
  final EnumPlayMusic enumPlayMusic;
  final bool isBigButton;
  final VoidCallback? onTap;

  const PlayMusicButtonWidget({
    super.key,
    required this.enumPlayMusic,
    this.isBigButton = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);
    final double buttonSize = isBigButton ? 70 : 50;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: buttonSize,
        width: buttonSize,
        padding: EdgeInsets.all(isBigButton ? 18 : 12),
        decoration: BoxDecoration(
          color: appTheme.selectedIconColor.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(
            color: appTheme.selectedIconColor.withOpacity(0.30),
            width: 1.5,
          ),
        ),
        child: SvgPicture.asset(
          _getPathSvg(enumPlayMusic),
          colorFilter: ColorFilter.mode(
            appTheme.selectedIconColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  String _getPathSvg(EnumPlayMusic type) {
    switch (type) {
      case EnumPlayMusic.next:
        return AppPath.playMusicIcon[0];
      case EnumPlayMusic.back:
        return AppPath.playMusicIcon[1];
      case EnumPlayMusic.pause:
        return AppPath.playMusicIcon[2];
      case EnumPlayMusic.play:
        return AppPath.playMusicIcon[3];
      }
  }
}
