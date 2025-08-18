import 'package:flutter/material.dart';
import 'package:musiclove/core/utils/message_utils.dart';

import '../../../core/mock/message_model.dart';
import '../../../core/utils/valid_utils.dart';

class MessageContents extends StatelessWidget {
  const MessageContents({
    super.key,
    required this.message, required this.type, this.isLastInLine = false, this.isLastMessage = false,
  });

  final ConversationMessage message;
  final EnumMessageType type;
  final bool isLastInLine;
  final bool isLastMessage;

  @override
  Widget build(BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          color: MessageUtils.getBackgroundColor(type, context),
          borderRadius: BorderRadius.circular(10),),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 5),
            isLastInLine ? Text(MessageUtils.getTimeMessage(message.sentAt),style: TextStyle(fontSize: 10),) : SizedBox.shrink()
          ],
        ),
      );
  }
}





//
// import 'package:flutter/material.dart';
//
// class MessageContents extends StatelessWidget {
//   const MessageContents({
//     super.key,
//     required this.message,
//     this.isSentMessage = false,
//   });
//
//   final String message;
//   final bool isSentMessage;
//
//   @override
//   Widget build(BuildContext context) {
//     return Text(
//       message,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w400,
//         color: Colors.black,
//       ),
//     );
//   }
// }