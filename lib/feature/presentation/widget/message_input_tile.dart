import 'package:flutter/material.dart';
import 'package:musiclove/feature/presentation/widget/emoji_picker_widget.dart';

class MessageInputTile extends StatefulWidget {
  const MessageInputTile({super.key});

  @override
  State<MessageInputTile> createState() => _MessageInputTileState();
}

class _MessageInputTileState extends State<MessageInputTile> {
  late final TextEditingController messageController;
  late final String chatroomId;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }


  void _onEmojiSelected(String emoji) {
    final text = messageController.text;
    int start = messageController.selection.start;
    int end = messageController.selection.end;

    // Nếu selection chưa được đặt hoặc invalid, đặt vào cuối text
    if (start < 0 || start > text.length) {
      start = text.length;
    }
    if (end < 0 || end > text.length) {
      end = text.length;
    }

    final newText = text.replaceRange(start, end, emoji);
    final emojiLength = emoji.length;

    messageController.text = newText;
    messageController.selection = TextSelection.collapsed(offset: start + emojiLength);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          EmojiPickerDemo(onEmojiSelected: _onEmojiSelected,),
          // Text Field
          Expanded(child: buildTextInput(),),

          buildButtonRight(),
        ],
      ),
    );
  }

  Widget buildTextInput() {
    return SizedBox(
      child: TextField(
        onChanged: (text) {
          setState(() {});
        },
        controller: messageController,
        decoration: const InputDecoration(
          hintText: 'Tin nhan',
          hintStyle: TextStyle(),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 20, bottom: 10),
        ),
        maxLines: null,
        textInputAction: TextInputAction.done,
      ),
    );
  }

  Widget buildButtonMenu() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.more_horiz, color: Colors.grey),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.mic_none_outlined, color: Colors.grey),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.image, color: Colors.grey),
          onPressed: () async {},
        ),
      ],
    );
  }

  Widget buildButtonRight() {
    return messageController.value.text.isEmpty
        ? buildButtonMenu()
        : IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {},
          );
  }

  Widget buildIconButton() {
    return InkWell(
      onTap: () {},
      child: const Icon(Icons.add_reaction_outlined),
    );
  }
}
