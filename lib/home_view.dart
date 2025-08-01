import 'dart:ui';

import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final double _baseHeight = 120;
  final double padding = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          /// App bar
          buildAppBar(),

          /// Phí cần thay toán
          buildItemTile(title: 'Phí cần thanh toán', child: buildPaymentCost()),


          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('aaaaa')),
              childCount: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChart() {
    return SizedBox();
  }

  /// App bar
  Widget buildAppBar() {
    return SliverAppBar(
      leading: Icon(Icons.arrow_back, color: Colors.white),
      actions: [
        Text(
          'Bonah-01/08-2025',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Icon(Icons.arrow_drop_down, color: Colors.white),
      ],
      stretch: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      expandedHeight: _baseHeight,
      collapsedHeight: _baseHeight-60,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          double stretchAmount = constraints.maxHeight - _baseHeight;
          bool isStretching = stretchAmount > _baseHeight - 150;

          double baseFontSize = 12;
          double maxFontSize = 60;
          print(stretchAmount);
          double fontSizeCollapsed = 20;
          double paddingTopCollapsed = 15;

          double fontSize = baseFontSize + stretchAmount * 0.2;
          if (fontSize > maxFontSize) fontSize = maxFontSize;
          if (fontSize < fontSizeCollapsed) fontSize = fontSizeCollapsed;

          double paddingTop = _baseHeight*0.4 + stretchAmount/3;
          if(stretchAmount < 50){
            double t = stretchAmount / 50; // t từ 0 → 1 khi scroll lên
            paddingTop = lerpDouble(22, _baseHeight * 0.4 + 50 / 3, t)!;
            print(paddingTop);
          } else {
            _baseHeight*0.4 + stretchAmount/4;
          }

          if(paddingTop < 14){
            print('asds');
          }


          Widget appBarContent = Container(
            height: isStretching ? constraints.maxHeight : _baseHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade700,
                  Colors.blue.shade300,
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 50, top: paddingTop),
                child: Text(
                  'Home',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          );

          /// log check vi tri scroll
          if (paddingTop > 14) {
            return ClipPath(
              clipper: StretchClipper(stretchAmount: stretchAmount),
              child: appBarContent,
            );
          } else{
            return appBarContent;
          }
        },
      ),
    );
  }

  ///widget chứa menu tile
  Widget buildItemTile({required String title, required Widget child}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(color: Colors.white, child: child),
          ],
        ),
      ),
    );
  }

  /// phi thanh toan
  Widget buildPaymentCost() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: Center(
        child: Text(
          'O đ',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}

///Clip path tạo đường cong
class StretchClipper extends CustomClipper<Path> {
  final double stretchAmount;

  StretchClipper({required this.stretchAmount});

  @override
  Path getClip(Size size) {
    final path = Path();

    if (stretchAmount == 0) {
      path.addRect(Rect.fromLTWH(0, 0, size.width , size.height));
      return path;
    }

    final double paddingBottom = 20;

    /// diem so 1
    final p1 = Offset(0, size.height - paddingBottom - stretchAmount / 4);
    /// diem so 2
    final p2 = Offset(size.width - 80, size.height);
    /// diem so 3
    final p3 = Offset(size.width, size.height - paddingBottom  - stretchAmount / 4);

    double cornerRadius = 20.0 + stretchAmount / 4;


    /// bo goc tron tai diem so 2
    final vec1 = (p1 - p2).direction; // Góc hướng từ P2 về P1
    final vec2 = (p3 - p2).direction; // Góc hướng từ P2 về P3

    /// Lùi khỏi P2 một đoạn cornerRadius theo 2 hướng
    final p2Start = p2 + Offset.fromDirection(vec1, cornerRadius);
    final p2End = p2 + Offset.fromDirection(vec2, cornerRadius);

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2Start.dx, p2Start.dy); // Đi đến trước điểm bo
    // Vẽ bo tròn tại P2
    path.quadraticBezierTo(
      p2.dx, p2.dy,     // Control point  P2
      p2End.dx, p2End.dy,
    );
    // quay ve diem 3
    path.lineTo(p3.dx, p3.dy);
    // chay het 2 diem dau va cuoi de hien thi full widget
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant StretchClipper oldClipper) {
    return oldClipper.stretchAmount != stretchAmount;
  }
}

Widget buildBanner() {
  return Positioned(
    top: 20,
    right: -20,
    child: Transform.rotate(
      angle: 0.7, //
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade500,
          boxShadow: [
            BoxShadow(
              offset: Offset(1, 1),
              blurRadius: 3,
              color: Colors.green,
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
        child: Text(
          "ĐÃ THANH TOÁN",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0.5, 0.5),
                blurRadius: 0.5,
                color: Colors.white54,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
