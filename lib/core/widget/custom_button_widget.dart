import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_style.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.tap,
    this.paddingHorizontal = 40,
    this.paddingVertical = 10,
    this.color = AppColor.primaryColor,
    this.colorText = Colors.black,
  });

  final String text;
  final VoidCallback tap;
  final double paddingHorizontal;
  final double paddingVertical;
  final Color color;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if (kDebugMode) {
          print('Tap < $text >');
        }
        tap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: paddingHorizontal,
          vertical: paddingVertical,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
        ),
        child: Text(text, style: AppTextStyle.textTaskTitle(colorText)),
      ),
    );
  }
}
