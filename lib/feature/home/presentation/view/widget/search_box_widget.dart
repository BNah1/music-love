import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class SearchMusicBox extends StatefulWidget {
  const SearchMusicBox({super.key,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  State<SearchMusicBox> createState() => SearchMusicBoxState();
}

class SearchMusicBoxState extends State<SearchMusicBox> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.query,
    );
  }

  @override
  void didUpdateWidget(covariant SearchMusicBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query != _controller.text) {
      _controller.text = widget.query;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return Container(
      decoration: BoxDecoration(
        color: appTheme.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: appTheme.shadowColor,
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Tìm bài hát, ca sĩ, album...',
          hintStyle: TextStyle(
            color: appTheme.subtitleColor,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: appTheme.accentColor,
          ),
          suffixIcon: widget.query.isEmpty
              ? null
              : IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              _controller.clear();
              widget.onClear();
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}