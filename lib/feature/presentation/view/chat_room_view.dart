import 'package:flutter/material.dart';
import 'package:musiclove/feature/presentation/widget/message_input_tile.dart';
import 'package:musiclove/feature/presentation/widget/message_list.dart';

const String _userName = 'Bonah';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView({super.key});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: buildAppBar(),
    body: const Column(children: [
      /// build Message List in chat room
      Expanded(child: MessageList()),

      /// build input TextField
      MessageInputTile()
    ],),);
  }




  /// build app bar
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: const Text(_userName),
      backgroundColor: Colors.blue.shade400,
      actions: const [
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.call_outlined),
              Icon(Icons.videocam_outlined),
              Icon(Icons.list),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

}
