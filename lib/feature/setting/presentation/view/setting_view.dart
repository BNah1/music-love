import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:musiclove/core/constant/routes.dart';
import 'package:musiclove/core/constant/theme.dart';
import 'package:musiclove/feature/setting/presentation/view/widget/select_tile_widget.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.extensionOf(context);

    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Cài đặt',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [

            /// Chủ đề
            _buildSettingItemTile(
              title: 'Chủ đề',
              onTap: (){
                context.push(AppRoutes.settingTheme);
              },
            ),

            _buildSettingItemTile(
              title: 'Tai nghe / Bluetooth',
              onTap: (){
                context.push(AppRoutes.settingBluetooth);
              },
            ),

            _buildSettingItemTile(
              title: 'Thư viện',
              onTap: (){
                context.push(AppRoutes.settingLibrary);
              },
            ),

            _buildSettingItemTile(
              title: 'Trình phát nhạc',
              onTap: (){
                context.push(AppRoutes.settingMusicPlayer);
              },
            ),
          ],
        ),
      ),
    );
  }
  
  
  
  Widget _buildSettingItemTile({required String title, required VoidCallback onTap}){
    final appTheme = AppTheme.extensionOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
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
        child: SelectTile(
          title: title,
          onTap: onTap,
        ),
      ),
    );
  }



}








