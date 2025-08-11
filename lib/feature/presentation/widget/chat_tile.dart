import 'package:flutter/material.dart';


const _userImage = 'assets/icons/profile.png';
const _userName = 'bonah';
const _lastMessage = 'hello there alo alo alo';
const _lastMessageTime = '5 minutes ago';

class ChatTile extends StatefulWidget {
  const ChatTile({super.key});

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 8.0,
      ),
      child: InkWell(
        onTap: () {
        },
        child: const Row(
          children: [
            // Profile Pic
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(_userImage),
            ),
            SizedBox(width: 10),
            // Column (Name + Last Message + Last Message Timetstamp)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Text(
                    _userName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Last Message + Ts
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _lastMessage,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(' → '),
                      Text(
                        _lastMessageTime,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Message status
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.check_circle_outline,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
