import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_style.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(50),
        child: Center(child: Text(title,style: AppTextStyle.textBodyTile(color: AppColor.primaryTextColor),),));
  }
}
