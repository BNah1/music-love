import 'package:flutter/material.dart';
import 'package:musiclove/core/mock/data.dart';
import 'package:musiclove/core/mock/message_model.dart';
import 'package:musiclove/feature/presentation/widget/message_received_widget.dart';

import '../../../core/utils/message_utils.dart';
import 'message_sent_widget.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  List<ConversationMessage> list = MockDataMessage.messages;
  final int myId = 101;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEBECF0),
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index){

            final message = list[index];
            final isMyMessage = message.senderId == myId;

            final isLastMessageInLine = MessageUtils.checkLastMessageInLine(list, message);
            final isLastMessage = MessageUtils.checkLastMessage(list, message);
            final isFirstMessageInDay = MessageUtils.checkIsFirstMessageInDay(list, message);
            final time = MessageUtils.getTimeMessageFull(message.sentAt);

            print(' ${message.id} : isLastMessage $isLastMessage  isLastMessageInLine $isLastMessageInLine');

            if (isMyMessage) {
              return Column(
                children: [
                  buildTimeTile(isFirstMessageInDay, time),
                  MessageSentWidget(message: message, isLastInLine: isLastMessageInLine ,isLastMessage: isLastMessage,),
                ],
              );
            } else {
              return Column(
                children: [
                  buildTimeTile(isFirstMessageInDay, time),
                  MessageReceivedWidget(message: message, isLastInLine: isLastMessageInLine ,isLastMessage: isLastMessage,),
                ],
              );
            }
      }),
    );
  }

  Widget buildTimeTile(bool isFirstMessageInDay, String time){

    return isFirstMessageInDay ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.shade400
            ),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(time, style: const TextStyle(fontSize: 12),),
          ),
        )
        : const SizedBox.shrink();
  }
}
