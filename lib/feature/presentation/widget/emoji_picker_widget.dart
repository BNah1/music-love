import 'package:flutter/material.dart';

class EmojiPickerDemo extends StatefulWidget {
  final void Function(String emoji) onEmojiSelected;

  const EmojiPickerDemo({super.key, required this.onEmojiSelected});

  @override
  State<EmojiPickerDemo> createState() => _EmojiPickerDemoState();
}
class _EmojiPickerDemoState extends State<EmojiPickerDemo> {

  // Danh sách emoji mẫu, bạn có thể mở rộng hoặc lấy bộ icon đầy đủ hơn
  final List<String> emojis = [
    "😀", "😁", "😂", "🤣", "😃", "😄", "😅", "😆", "😉", "😊", "😋", "😎",
    "😍", "😘", "🥰", "😗", "😙", "😚", "🙂", "🤗", "🤩", "🤔", "🤨", "😐",
    "😑", "😶", "🙄", "😏", "😣", "😥", "😮", "🤐", "😯", "😪", "😫", "🥱",
    "😴", "😌", "😛", "😜", "😝", "🤤", "😒", "😓", "😔", "😕", "🙃", "🤑",
    "😲", "☹️", "🙁", "😖", "😞", "😟", "😤", "😢", "😭", "😦", "😧", "😨",
    "😩", "🤯", "😬", "😰", "😱", "🥵", "🥶", "😳", "🤪", "😵", "😡", "😠",
    "🤬", "😷", "🤒", "🤕", "🤢", "🤮", "🤧", "😇", "🤠", "🤡", "🥳", "🥺",
    "🤥", "🤫", "🤭", "🧐", "🤓", "😈", "👿", "👹", "👺", "💀", "👻", "👽",
    "🤖", "💩", "🙏", "👍", "👎", "👊", "✊", "🤛", "🤜", "👏", "🙌", "👐",
    "🤲", "🤝", "💪", "🦾", "🦵", "🦿", "🦶", "👂", "👃", "🧠", "🦷", "🦴",
    "👀", "👁️", "👅", "👄", "💋", "💥", "💫", "💦", "💨", "🔥", "✨", "🎉",
    "🎊", "🎈"
  ];


  void _openEmojiPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 250,
        child: GridView.builder(
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
          itemCount: emojis.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                widget.onEmojiSelected(emojis[index]);
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  emojis[index],
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.emoji_emotions),
      onPressed: _openEmojiPicker,
    );
  }
}
