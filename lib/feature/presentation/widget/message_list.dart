import 'package:flutter/material.dart';
import 'package:musiclove/feature/presentation/widget/message_received_widget.dart';

import 'message_sent_widget.dart';

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEBECF0),
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index){
        return const Column(
          children: [
            MessageReceivedWidget(),
            MessageSentWidget(),
          ],
        );
      }),
    );
  }
}
