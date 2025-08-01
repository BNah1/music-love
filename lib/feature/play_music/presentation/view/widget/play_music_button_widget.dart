import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/core/constant/app_path.dart';

class PlayMusicButtonWidget extends StatefulWidget {
  const PlayMusicButtonWidget({super.key, required this.enumPlayMusic});

  final EnumPlayMusic enumPlayMusic;

  @override
  State<PlayMusicButtonWidget> createState() => _PlayMusicButtonWidgetState();
}

class _PlayMusicButtonWidgetState extends State<PlayMusicButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        getTap(widget.enumPlayMusic)();
      },
      child: SizedBox(
          height: size.height/15,
          width: size.height/15,
          child: SvgPicture.asset(getPathSvg(widget.enumPlayMusic), color: Colors.white)),
    );
  }
}

Function getTap(EnumPlayMusic enumPlayMusic){
  return (){
    print(enumPlayMusic.name);
  };
}

String getPathSvg(EnumPlayMusic enumPlayMusic){
  switch(enumPlayMusic){
    case EnumPlayMusic.next :
      return AppPath.playMusicIcon[0];
    case EnumPlayMusic.play:
      return AppPath.playMusicIcon[3];
    case EnumPlayMusic.back:
      return AppPath.playMusicIcon[1];
    case EnumPlayMusic.pause:
      return AppPath.playMusicIcon[0];
  }
}
