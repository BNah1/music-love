import 'package:flutter/material.dart';
import 'package:musiclove/core/utils/message_utils.dart';

import '../../../core/mock/message_model.dart';
import '../../../core/utils/valid_utils.dart';
import 'message_tile.dart';

class MessageSentWidget extends StatelessWidget {
  const MessageSentWidget({super.key, required this.message, required this.isLastInLine, required this.isLastMessage});

  final ConversationMessage message;
  final bool isLastInLine;
  final bool isLastMessage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 8,bottom: 8,right: 8,left: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MessageContents(message: message, type: EnumMessageType.send,isLastInLine: isLastInLine, isLastMessage: isLastMessage,),
            // buildSeenTile(message.isRead),
          ],
        ),
      ),
    );

  }
  Widget buildSeenTile(bool isRead){
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isRead
                ? const Icon(
              Icons.done_all,
              color: Colors.white,
              size: 15,
            )
                : const Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
            // Text('Đã gửi',style: TextStyle(fontSize: 12, color: Colors.white),)
          ],),
      ),
    );
  }
}
