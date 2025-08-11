import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/routes.dart';

import 'chat_tile.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: (){
            Navigator.of(context).pushNamed(AppRoutes.chatRoom);
            print('Go Chat room');
          },
          child: const ChatTile(
          ),
        );
      },
    );
  }
}
