import 'package:flutter/material.dart';

/// Scrolls only when the rendered title is wider than its available space.
class ScrollingSongTitle extends StatefulWidget {
  const ScrollingSongTitle({
    super.key,
    required this.title,
    required this.style,
    this.textAlign = TextAlign.start,
  });

  final String title;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  State<ScrollingSongTitle> createState() => _ScrollingSongTitleState();
}

class _ScrollingSongTitleState extends State<ScrollingSongTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);
  double _overflow = 0;

  @override
  void didUpdateWidget(covariant ScrollingSongTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title || oldWidget.style != widget.style) {
      _controller.stop();
      _controller.value = 0;
      _overflow = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.title, style: widget.style),
          maxLines: 1,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout();
        final overflow = (painter.width - constraints.maxWidth).clamp(
          0.0,
          double.infinity,
        );
        if (overflow != _overflow) {
          _overflow = overflow;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (overflow <= 0 || MediaQuery.disableAnimationsOf(context)) {
              _controller.stop();
              _controller.value = 0;
            } else {
              _controller.duration = Duration(
                milliseconds: (overflow * 24).round().clamp(2500, 12000),
              );
              _controller.repeat(reverse: true);
            }
          });
        }
        return ClipRect(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => Transform.translate(
              offset: Offset(-_overflow * _controller.value, 0),
              child: child,
            ),
            child: SizedBox(
              width: painter.width > constraints.maxWidth
                  ? painter.width
                  : constraints.maxWidth,
              child: Text(
                widget.title,
                maxLines: 1,
                softWrap: false,
                textAlign: widget.textAlign,
                style: widget.style,
              ),
            ),
          ),
        );
      },
    );
  }
}
