import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_string.dart';
import 'package:musiclove/core/widget/app_overlay.dart';

Future<String?> showPlaylistNameDialog({
  required BuildContext context,
  required String title,
  String initialValue = '',
  String? submitLabel,
}) {
  return AppOverlay.showModal<String>(
    context: context,
    builder: (_) => _PlaylistNameDialog(
      title: title,
      initialValue: initialValue,
      submitLabel: submitLabel,
    ),
  );
}

class _PlaylistNameDialog extends StatefulWidget {
  const _PlaylistNameDialog({
    required this.title,
    required this.initialValue,
    this.submitLabel,
  });

  final String title;
  final String initialValue;
  final String? submitLabel;

  @override
  State<_PlaylistNameDialog> createState() => _PlaylistNameDialogState();
}

class _PlaylistNameDialogState extends State<_PlaylistNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.pop(context, name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          hintText: context.tr(AppString.playlistNameHint),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr(AppString.commonCancel)),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.submitLabel ?? context.tr(AppString.commonSave)),
        ),
      ],
    );
  }
}
