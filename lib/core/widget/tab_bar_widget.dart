import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_style.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key, required this.tabController});

  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelPadding: const EdgeInsets.symmetric(vertical: 5.0),
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 3.0, color: AppColor.primaryColor),
        insets: EdgeInsets.symmetric(horizontal: 20.0),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal,fontSize: 20),
      labelColor: AppColor.primaryTextColorTitle,
      controller: tabController,
      tabs: const [
        Text('Payment'),
        Text('InCome'),
      ],
    );
  }
}
