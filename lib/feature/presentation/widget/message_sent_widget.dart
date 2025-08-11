import 'package:flutter/material.dart';

import 'message_tile.dart';

class MessageSentWidget extends StatelessWidget {
  const MessageSentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 8,bottom: 8,right: 8,left: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE5F1FF),
                borderRadius: BorderRadius.circular(10),),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MessageContents(
                    message: 'Phàm Nhân Tu Tiên ',
                    isSentMessage: true,
                  ),
                  SizedBox(width: 5),
                  Text(_time,style: TextStyle(fontSize: 10),)
                ],
              ),
            ),
            buildSeenTile(),
            Divider()
          ],
        ),
      ),
    );
    
  }
  Widget buildSeenTile(){
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(10)
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          _isSeen
              ? Icon(
            Icons.done_all,
            color: Colors.white,
            size: 15,
          )
              : Icon(
            Icons.check,
            color: Colors.white,
            size: 15,
          ),
          Text('Đã gửi',style: TextStyle(fontSize: 12, color: Colors.white),)
        ],),
      ),
    );
  }
}
const bool _isSeen = true;
const String _time = '10:10';