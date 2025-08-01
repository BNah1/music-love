import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_enum.dart';
import 'package:musiclove/feature/play_music/domain/usecase/get_mp3_file.dart';
import 'package:musiclove/feature/play_music/presentation/view/widget/play_music_button_widget.dart';

class PlayMusicView extends StatefulWidget {
  const PlayMusicView({super.key});

  @override
  State<PlayMusicView> createState() => _PlayMusicViewState();
}

class _PlayMusicViewState extends State<PlayMusicView> {
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildPickMp3(),
          buildButton()
        ],
      ),
    );
  }

  Widget buildButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// back button
        const PlayMusicButtonWidget(enumPlayMusic: EnumPlayMusic.back),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width/8),
          child: const PlayMusicButtonWidget(enumPlayMusic: EnumPlayMusic.play),
        ),
        const PlayMusicButtonWidget(enumPlayMusic: EnumPlayMusic.next),
      ],
    );
  }

  Widget buildPickMp3(){
    return Padding(
      padding: const EdgeInsets.all(50),
      child: InkWell(
        child: Icon(Icons.add,size: 50,),
        onTap: () async {
          await requestPermission();
          await pickFileMp3();
        },
      ),
    );
  }
}
