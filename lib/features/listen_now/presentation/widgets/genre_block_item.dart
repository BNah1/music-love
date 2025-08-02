import 'package:flutter/material.dart';
import 'package:musiclove/features/listen_now/presentation/widgets/gradient_text.dart';

class GenreBlockItem extends StatelessWidget {
  final String title;
  final Color? color;
  const GenreBlockItem({
    Key? key,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            // color: color ?? Colors.orange,
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              color ?? Colors.orange,
              color?.withAlpha(190) ?? Colors.orange.shade300,
            ]),
          ),
          height: 200,
          width: 200,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                      top: 3,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.apple,
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          "Music",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //title heading
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // const Spacer(),
                ],
              ),
              //title color transitioning
              Positioned(
                bottom: -25,
                left: 6,
                child: GradientText(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 102,
                    // decorationColor: Colors.white,
                  ),
                  gradient: LinearGradient(colors: [
                    // Colors.black26,
                    Colors.black12,
                    Colors.white38,
                    // Colors.white10,
                  ]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "${title} Station",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Apple Music ${title}",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
