import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/main_shell/presentation/provider/main_shell_provider.dart';
import 'package:musiclove/feature/main_shell/presentation/state/menu_item.dart';

class BottomNavWidget extends ConsumerWidget {
  const BottomNavWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = AppTheme.extensionOf(context);
    final currentIndex = ref.watch(bottomNavProvider);
    final menuItems = ref.read(bottomNavProvider.notifier).menuItems;

    // final String location = GoRouterState.of(context).uri.toString();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(bottomNavProvider.notifier).syncWithLocation(
    //       location
    //   );
    // });

    return SafeArea(
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: appTheme.navBackground,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: appTheme.shadowColor,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildAnimatedIndicator(context, currentIndex, appTheme, menuItems.length),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: menuItems.map((item) {
                return _buildNavItem(
                  context,
                  ref,
                  item,
                  currentIndex,
                  appTheme,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIndicator(BuildContext context, int currentIndex, AppThemeExtension appTheme, int length) {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCirc,
      alignment: Alignment(-1.0 + (currentIndex * 1.0), 0),
      child: FractionallySizedBox(
        widthFactor: 1 / length,
        child: Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            gradient: appTheme.navIndicatorGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: appTheme.shadowColor,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      WidgetRef ref,
      MenuItem item,
      int currentIndex,
      AppThemeExtension appTheme,
      ) {
    final bool isSelected = currentIndex == item.index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(bottomNavProvider.notifier).setIndex(item.index);
          context.go(item.path);
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                item.icon,
                color: isSelected ? appTheme.selectedIconColor : appTheme.unselectedIconColor,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

}