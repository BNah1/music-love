// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class BHXHTabBarWidgetBeauty extends StatefulWidget {
//   static const String routeName = "/tabBarWidget";
//   final List<String> listTitleName;
//   final List<Widget> listBody;
//   final Color backgroundColor;
//   final PageController pageController;
//   final Color titleColor;
//   final bool disable;
//   final double offset;
//   final Function onPageChanged;
//
//   final Widget bottomAppbarWidget;
//
//   // final int indexSelected;
//   final Function(int index, double offset) onCallBackUpdate;
//
//   BHXHTabBarWidgetBeauty(
//       {@required this.listTitleName,
//         @required this.listBody,
//         this.backgroundColor,
//         this.pageController,
//         this.disable = false,
//         this.offset = 0,
//         this.titleColor,
//         this.onPageChanged,
//         this.bottomAppbarWidget,
//         // this.indexSelected,
//         this.onCallBackUpdate});
//
//   @override
//   State<BHXHTabBarWidgetBeauty> createState() => _BHXHTabBarWidgetBeautyState();
// }
//
// class _BHXHTabBarWidgetBeautyState extends State<BHXHTabBarWidgetBeauty>
//     with WidgetsBindingObserver {
//   PageController pageController;
//   double offsetPageController = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     pageController = widget.pageController ?? PageController();
//     offsetPageController = widget.offset ?? 0.0;
//     pageController.addListener(() {
//       if (mounted) {
//         setState(() {
//           offsetPageController = pageController.offset;
//         });
//       }
//     });
//     if (pageController.initialPage == 1) {
//       offsetPageController = Get.width;
//     }
//     WidgetsBinding.instance.addObserver(this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       /// build UI lại update lại offset cho pageController
//       if (pageController.hasClients) {
//         pageController.animateTo(offsetPageController,
//             duration: const Duration(milliseconds: 1), curve: Curves.easeInOut);
//       }
//     });
//   }
//
//   @override
//   void didChangeMetrics() {
//     if (mounted) {
//       setState(() {
//         offsetPageController = pageController.offset;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double widthScreen = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: widget.backgroundColor ?? BHXHThemePrimary.primaryColor,
//       body: Stack(
//         children: [
//           Positioned(
//             child: SizedBox(
//               width: widthScreen,
//               height: 66,
//               child: Row(
//                 children: widget.listTitleName
//                     .map((e) => Expanded(
//                     child: Center(
//                         child: Text(
//                           e.tr,
//                           style: TextStyle(
//                               color: widget.disable
//                                   ? const Color(0xffEBEBEB).withOpacity(0.5)
//                                   : const Color(0xffEBEBEB),
//                               fontWeight: FontWeight.bold),
//                         ))))
//                     .toList(),
//               ),
//             ),
//           ),
//           CustomPaint(
//             painter: ClipperBorderShadow(
//                 offset: offsetPageController,
//                 countPage: widget.listTitleName.length),
//             child: ClipPath(
//               clipper: TabClipper(
//                   offset: offsetPageController,
//                   countPage: widget.listTitleName.length),
//               child: Container(
//                 color: Colors.white,
//                 child: Stack(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (widget.bottomAppbarWidget != null) ...[
//                           Container(
//                               margin: const EdgeInsets.only(top: 60),
//                               child: widget.bottomAppbarWidget),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                         if (widget.bottomAppbarWidget == null)
//                           SizedBox(
//                             height: 70,
//                           ),
//                         Expanded(
//                           child: PageView.builder(
//                               physics: widget.disable
//                                   ? const NeverScrollableScrollPhysics()
//                                   : null,
//                               controller: pageController,
//                               onPageChanged: widget.onPageChanged,
//                               itemCount: widget.listTitleName.length,
//                               itemBuilder: (context, index) {
//                                 return KeepAliveWrapperWidget(
//                                     child: widget.listBody[index]);
//                               }),
//                         )
//                       ],
//                     ),
//                     Positioned(
//                       child: SizedBox(
//                         width: widthScreen,
//                         height: 66,
//                         // color: Colors.black87,
//                         child: Row(
//                           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: widget.listTitleName
//                                 .map((e) => Expanded(
//                                 child: Center(
//                                     child: Text(
//                                       e.tr,
//                                       style: TextStyle(
//                                           color: widget.disable
//                                               ? BHXHThemePrimary.primaryColor
//                                               .withOpacity(0.5)
//                                               : widget.titleColor ??
//                                               BHXHThemePrimary.primaryColor,
//                                           fontWeight: FontWeight.bold),
//                                     ))))
//                                 .toList()),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             child: SizedBox(
//               width: widthScreen,
//               height: 66,
//               // color: Colors.black87,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Row(
//                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: widget.listTitleName
//                         .map((e) => Expanded(
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(16.0),
//                           onTap: () {
//                             if (!widget.disable) {
//                               int _indexSelected =
//                               widget.listTitleName.indexOf(e);
//                               if (widget.onCallBackUpdate != null) {
//                                 widget.onCallBackUpdate(
//                                     _indexSelected, offsetPageController);
//                               }
//                               pageController.animateToPage(_indexSelected,
//                                   duration:
//                                   const Duration(milliseconds: 500),
//                                   curve: Curves.ease);
//                             }
//                           },
//                         )))
//                         .toList()),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class TabClipper extends CustomClipper<Path> {
//   final int countPage;
//   final double offset;
//
//   TabClipper({@required this.countPage, @required this.offset});
//
//   double heightDefault = 48.0;
//   double padding = 9.0;
//   double sizePlus = 15;
//
//   @override
//   Path getClip(Size size) {
//     double titleBoxWidth = size.width / countPage;
//     double position = offset / countPage; //countPage;
//     Path path = Path();
//     path.moveTo(0.0, heightDefault + padding);
//     // path.lineTo(0.0, heightDefault+padding);
//
//     //1
//     path.lineTo(position - 15 - sizePlus * 0.5, heightDefault + padding);
//     //2
//     path.quadraticBezierTo(
//         position - 1.5 + padding * 0.6 - sizePlus * 0.5,
//         heightDefault + 0.7 + padding,
//         position + padding * 0.5 - sizePlus * 0.5,
//         heightDefault - 15 + padding);
//     //3
//     path.lineTo(position + padding * 0.5 - sizePlus * 0.5, 15 + padding);
//     //4
//     path.quadraticBezierTo(
//         position + 2.5 + padding * 0.3 - sizePlus * 0.5,
//         2.5 + padding * 0.6,
//         position + 15.0 + padding - sizePlus * 0.5,
//         padding);
//     //4
//     path.lineTo(
//         position + titleBoxWidth - 15.0 - padding + sizePlus * 0.5, padding);
//     //3
//     path.quadraticBezierTo(
//         position + titleBoxWidth - 2.5 - padding * 0.3 + sizePlus * 0.5,
//         2.5 + padding * 0.6,
//         position + titleBoxWidth - padding * 0.5 + sizePlus * 0.5,
//         15.0 + padding);
//     //2
//     path.lineTo(position + titleBoxWidth - padding * 0.5 + sizePlus * 0.5,
//         heightDefault - 15 + padding);
//
//     //1
//     path.quadraticBezierTo(
//         position + titleBoxWidth + 1.5 - padding * 0.6 + sizePlus * 0.5,
//         heightDefault + 0.7 + padding,
//         position + titleBoxWidth + 15 + sizePlus * 0.5,
//         heightDefault + padding);
//
//     path.lineTo(size.width, heightDefault + padding);
//     path.lineTo(size.width, size.height + padding);
//     path.lineTo(0, size.height + padding);
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => true;
// }
//
// class ClipperBorderShadow extends CustomPainter {
//   final int countPage;
//   final double offset;
//
//   ClipperBorderShadow({@required this.countPage, @required this.offset});
//
//   double heightDefault = 48.0;
//   double padding = 0.0;
//   double sizePlus = 15;
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     double titleBoxWidth = size.width / countPage;
//     double position = offset / countPage; //countPage;
//     Path path = Path();
//     path.moveTo(0.0, heightDefault + padding);
//     // path.lineTo(0.0, heightDefault+padding);
//
//     //1
//     path.lineTo(position - 15 - sizePlus * 0.5, heightDefault + padding);
//     //2
//     path.quadraticBezierTo(
//         position - 1.5 + padding * 0.6 - sizePlus * 0.5,
//         heightDefault + 0.7 + padding,
//         position + padding * 0.5 - sizePlus * 0.5,
//         heightDefault - 15 + padding);
//     //3
//     path.lineTo(position + padding * 0.5 - sizePlus * 0.5, 15 + padding);
//     //4
//     path.quadraticBezierTo(
//         position + 2.5 + padding * 0.3 - sizePlus * 0.5,
//         2.5 + padding * 0.6,
//         position + 15.0 + padding - sizePlus * 0.5,
//         padding);
//     //4
//     path.lineTo(
//         position + titleBoxWidth - 15.0 - padding + sizePlus * 0.5, padding);
//     //3
//     path.quadraticBezierTo(
//         position + titleBoxWidth - 2.5 - padding * 0.3 + sizePlus * 0.5,
//         2.5 + padding * 0.6,
//         position + titleBoxWidth - padding * 0.5 + sizePlus * 0.5,
//         15.0 + padding);
//     //2
//     path.lineTo(position + titleBoxWidth - padding * 0.5 + sizePlus * 0.5,
//         heightDefault - 15 + padding);
//
//     //1
//     path.quadraticBezierTo(
//         position + titleBoxWidth + 1.5 - padding * 0.6 + sizePlus * 0.5,
//         heightDefault + 0.7 + padding,
//         position + titleBoxWidth + 15 + sizePlus * 0.5,
//         heightDefault + padding);
//
//     path.lineTo(size.width, heightDefault + padding);
//     path.lineTo(size.width, size.height + padding);
//     path.lineTo(0, size.height + padding);
//
//     /// remove shadow -> Colors.transparent, 0
//     canvas.drawShadow(path, Colors.transparent, 0, false);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// /*
//   Bao Custom
//   Widget giữ trạng thái thường dùng cho tabview
//  */
//
// class KeepAliveWrapperWidget extends StatefulWidget {
//   /// ***
//   /// Bao Custom
//   /// Widget giữ trạng thái thường dùng cho tabview
//   /// ***
//
//   final Widget child;
//
//   const KeepAliveWrapperWidget({Key key, this.child}) : super(key: key);
//
//   @override
//   __KeepAliveWrapperState createState() => __KeepAliveWrapperState();
// }
//
// class __KeepAliveWrapperState extends State<KeepAliveWrapperWidget>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return widget.child;
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }