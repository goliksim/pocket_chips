import 'package:flutter/material.dart';

import '../../../utils/theme/ui_values.dart';
import 'ui_widgets.dart';

class AttentionButton extends StatefulWidget {
  final Widget textWidget;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;
  final bool Function() needToAnimate;

  const AttentionButton({
    required this.textWidget,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
    required this.needToAnimate,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.easeInOut,
    this.maxSize = 0.05,
    super.key,
  });

  final Duration duration;
  final double maxSize;
  final Curve curve;

  @override
  AttentionAddPlayerButtonState createState() =>
      AttentionAddPlayerButtonState();
}

class AttentionAddPlayerButtonState extends State<AttentionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late bool needToAnimate;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    needToAnimate = widget.needToAnimate();
    _startAnimation();
  }

  void _startAnimation() async {
    if (needToAnimate) {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        controller.forward();
      }
    }

    controller.addStatusListener(_statusHandler);
  }

  Future<void> _statusHandler(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      needToAnimate = widget.needToAnimate();

      if (needToAnimate) controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      await Future.delayed(const Duration(seconds: 5));

      needToAnimate = widget.needToAnimate();
      if (!mounted) {
        return;
      }

      if (needToAnimate) {
        controller.forward();
      } else {
        controller.stop();
        controller.removeStatusListener(_statusHandler);
      }
    }
  }

  @override
  void dispose() {
    controller
      ..removeStatusListener(_statusHandler)
      ..dispose();

    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double _shake(double value) => widget.curve.transform(value);

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) => Transform.scale(
            scale: 1.0 - widget.maxSize * _shake(controller.value),
            child: child,
          ),
          child: MyButton(
            height: stdButtonHeight,
            width: double.infinity,
            buttonColor: widget.bgColor,
            child: widget.textWidget,
            action: () => widget.onTap(),
          ),
        ),
      );
}
