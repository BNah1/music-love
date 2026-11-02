import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/app_style.dart';

class ContainerCustomTile extends StatelessWidget {
   const ContainerCustomTile({super.key, required this.color, required this.child, required this.paddingInside});

  final Color color;
  final Widget child;
  final double paddingInside;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.symmetric(horizontal: AppSize.paddingDashBoard),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding:  EdgeInsets.all(paddingInside),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(AppSize.borderTile),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child
      ),
    );
  }
}
