import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class AppOverlay {
  AppOverlay._();

  static Future<T?> showSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool isDismissible = true,
  }) {
    final theme = AppTheme.extensionOf(context);
    return showModalBottomSheet<T>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      showDragHandle: true,
      backgroundColor: theme.navBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: builder,
    );
  }

  static Future<T?> showModal<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  static void showToast(
    BuildContext context,
    String message, {
    IconData icon = Icons.check_circle_outline_rounded,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final theme = AppTheme.extensionOf(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: theme.selectedIconColor),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }
}
