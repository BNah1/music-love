import 'package:flutter/material.dart';
import 'package:musiclove/feature/presentation/widget/chat_list.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
        ),
        titleSpacing: 0,
        title: Text('Bonah'),
      ),
      body: Column(
        children: [
          _buildChatsAppBar(),
          _buildChatsSearchWidget(),
          _listUser(),
          const Divider(),
          const Expanded(child: ChatList())
        ],
      ),
    );

  }

  Widget _listUser() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MockData.listUserMock.length,
        itemBuilder: (context, index) {
          final user = MockData.listUserMock[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(user.pathImage),
                ),
                Text(user.userName),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildChatsAppBar() => const Row(
    children: [
      CircleAvatar(
        radius: 32,
        backgroundImage: AssetImage('assets/icons/profile.png'),
      ),
      SizedBox(width: 5),
      Text(
        'Chats',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      Spacer(),
      Icon(Icons.camera_alt)
    ],
  );

  Widget _buildChatsSearchWidget() => Container(
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(.5),
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 15),
        Icon(Icons.search),
        SizedBox(width: 15),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(),
            ),
          ),
        ),
      ],
    ),
  );
}






class MockData {
  static List<UserModel> listUserMock = [
    UserModel(
      userName: "Alice",
      id: "u001",
      pathImage: "assets/icons/profile.png",
      userLoginName: "tk01",
      passLoginName: "123456",
    ),
    UserModel(
      userName: "Bob",
      id: "u002",
      pathImage: "assets/icons/profile.png",
      userLoginName: "tk02",
      passLoginName: "123456",
    ),
    UserModel(
      userName: "Diana",
      id: "u003",
      pathImage: "assets/icons/profile.png",
      userLoginName: "tk03",
      passLoginName: "123456",
    ),
    UserModel(
      userName: "Urgot",
      id: "u004",
      pathImage: "assets/icons/profile.png",
      userLoginName: "tk04",
      passLoginName: "123456",
    ),
  ];
}

class UserModel{
  final String userName;
  final String id;
  final String pathImage;
  final String userLoginName;
  final String passLoginName;


  UserModel({required this.userName, required this.id,required this.pathImage,required this.userLoginName,required this.passLoginName});

}