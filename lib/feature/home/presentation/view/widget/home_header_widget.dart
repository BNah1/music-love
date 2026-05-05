import 'package:flutter/material.dart';
import 'package:musiclove/core/constant/theme.dart';

class HomeHeader extends StatelessWidget {
  final bool isScanning;
  final bool isSearch;
  final VoidCallback onScanPressed;
  final VoidCallback onSearchPressed;

  const HomeHeader({super.key,
    required this.isScanning,
    required this.onScanPressed, required this.isSearch, required this.onSearchPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chào! 🌸🌸🌸',
                style: TextStyle(
                  fontSize: 16,
                  color: appTheme.subtitleColor,
                ),
              ),
              Text(
                'Bonah Music',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: appTheme.textColor,
                ),
              ),

            ],
          ),
          buildAction(context, appTheme)
        ],
      ),
    );
  }
  
  Widget buildAction(BuildContext context,AppThemeExtension appTheme){
    return Row(children: [
      buildIcon(context: context, icon: isScanning
        ? const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
      ),
    )
        : Icon(
      Icons.sync_rounded,
      color: appTheme.accentColor,
    ),
        isOn: isScanning, onPress: onScanPressed),
      const SizedBox(width: 20,),
      buildIcon(context: context, icon: isSearch
          ? Icon(
        Icons.search_off,
        color: appTheme.softAccentColor,
      )
          : Icon(
        Icons.search,
        color: appTheme.accentColor,
      ),
          isOn: isScanning, onPress: onSearchPressed),],);
  }


  Widget buildIcon({required BuildContext context, required Widget icon, required bool isOn, required VoidCallback onPress}){
final appTheme = AppTheme.extensionOf(context);

return GestureDetector(
      onTap: isOn ? null : onPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isOn
              ? Theme.of(context).disabledColor
              : appTheme.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: appTheme.shadowColor,
              blurRadius: 10,
            ),
          ],
        ),
        child: icon
      ),
    );
  }
}