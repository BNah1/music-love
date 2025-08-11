import 'package:flutter/material.dart';
import 'package:musiclove/feature/presentation/view/chat_view.dart';

import 'message_tile.dart';

class MessageReceivedWidget extends StatelessWidget {
  const MessageReceivedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.listUserMock[0];

    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, right: 50, left: 8),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [buildUser(), Flexible(child: buildTextTile())]),
      ),
    );
  }

  Widget buildTextTile() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageContents(message: 'Phàm Nhân Tu Tiên Phàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu TiênPhàm Nhân Tu Tiên ', isSentMessage: true),
          SizedBox(width: 5),
          Text(_time, style: TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

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
