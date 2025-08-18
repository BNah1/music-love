import 'package:flutter/material.dart';
import 'package:musiclove/core/utils/message_utils.dart';
import 'package:musiclove/feature/presentation/view/chat_view.dart';

import '../../../core/mock/message_model.dart';
import 'message_tile.dart';

class MessageReceivedWidget extends StatelessWidget {
  const MessageReceivedWidget({super.key, required this.message, required this.isLastInLine, required this.isLastMessage});
  final ConversationMessage message;
  final bool isLastInLine;
  final bool isLastMessage;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, right: 50, left: 8),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildUser(), Flexible(child: MessageContents(message: message, type: EnumMessageType.receive,isLastMessage: isLastMessage,isLastInLine: isLastInLine,))]),
      ),
    );
  }

  // Widget buildTextTile() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
  //     decoration: BoxDecoration(
  //       color: Colors.white70,
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child:  Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         MessageContents(message: message,),
  //         SizedBox(width: 5),
  //         Text(_time, style: TextStyle(fontSize: 10)),
  //       ],
  //     ),
  //   );
  // }

  Widget buildUser() {
    return const Padding(
      padding: EdgeInsets.only(right: 5),
      child: CircleAvatar(
        radius: 18,
        backgroundImage: AssetImage('assets/icons/profile.png'),
      ),
    );
  }
}
const String _time = '10:10';
