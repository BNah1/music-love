import 'package:flutter/material.dart';

class AppTab {
  AppTab._();

  // static List<Widget> get listTabView => [
  //   PaymentView(key: UniqueKey()),
  //   const CalendarView(),
  //   const ReportView(),
  //   Container(color: Colors.orangeAccent),
  // ];

  static List<Widget> listTabView = [
  ];

  static TabBarView tabView(TabController tabController) {
    return TabBarView(controller: tabController, children: listTabView);
  }

  static List<Tab> getHomeScreenTabs(int index) {
    return [
      Tab(
        // iconMargin: const EdgeInsets.only(top: AppSize.paddingMenu),
        text: 'Input',
        icon: Icon(index == 0 ? Icons.edit : Icons.edit_outlined),
      ),
      Tab(
        // iconMargin: const EdgeInsets.only(top: AppSize.paddingMenu),
        text: 'Calendar',
        icon: Icon(
          index == 1 ? Icons.calendar_month : Icons.calendar_month_outlined,
        ),
      ),
      Tab(
        // iconMargin: const EdgeInsets.only(top: AppSize.paddingMenu),
        text: 'Report',
        icon: Icon(index == 2 ? Icons.pie_chart : Icons.pie_chart_outline),
      ),
      Tab(
        // iconMargin: const EdgeInsets.only(top: AppSize.paddingMenu),
        text: 'Setting',
        icon: Icon(index == 3 ? Icons.settings : Icons.settings_outlined),
      ),
    ];
  }
}
