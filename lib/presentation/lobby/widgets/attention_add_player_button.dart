import 'package:flutter/material.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import '../../common/widgets/ui_widgets.dart';

class AttentionAddPlayerButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool Function() needToAnimate;

  const AttentionAddPlayerButton({
    required this.onTap,
    required this.needToAnimate,
    this.duration = const Duration(seconds: 1),
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

class AttentionAddPlayerButtonState extends State<AttentionAddPlayerButton>
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
      controller.forward();
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
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double _shake(double value) {
    return widget.curve.transform(value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.scale(
        scale: 1.0 - widget.maxSize * _shake(controller.value),
        child: child,
      ),
      child: MyButton(
        height: stdButtonHeight,
        width: double.infinity,
        buttonColor: thisTheme.playerColor,
        child: needToAnimate
            ? Text(
                context.strings.playp_add,
                style: TextStyle(
                  color: thisTheme.primaryColor,
                  fontSize: stdFontSize * 0.75,
                ),
              )
            : Icon(
                Icons.add_sharp,
                color: thisTheme.primaryColor,
                size: stdIconSize,
              ),
        action: () => widget.onTap(),
      ),
    );
  }
}
