import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onToggleObscure;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onToggleObscure,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị errorText ở trên TextField
          if (errorText != null && errorText!.isNotEmpty)
            const Text('error'),
          TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
