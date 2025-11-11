import 'dart:math';

import 'package:flutter/material.dart';

class RotationCard extends StatelessWidget {
  const RotationCard({
    super.key,
    required this.firstSide,
    required this.secondSide,
    required this.count,
    required this.conditionByIndex,
    required this.durationByIndex,
    this.padding,
  });
  final Widget Function(int) firstSide;
  final Widget Function(int) secondSide;
  final int count;
  final bool Function(int) conditionByIndex;
  final int Function(int) durationByIndex;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) => AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          duration: Duration(milliseconds: durationByIndex(index)),
          transitionBuilder: (Widget widget, Animation<double> animation) {
            final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);

            return AnimatedBuilder(
              animation: rotateAnim,
              child: widget,
              builder: (context, widget) {
                final isUnder = (const ValueKey('1') != widget?.key);
                var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
                tilt *= isUnder ? -1.0 : 1.0;
                final value = min(rotateAnim.value, pi / 2);

                return Transform(
                  transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                  alignment: Alignment.center,
                  child: widget,
                );
              },
            );
          },
          child: Padding(
            key: conditionByIndex(index)
                ? const ValueKey('1')
                : const ValueKey('2'),
            padding: padding ?? EdgeInsets.zero,
            child:
                conditionByIndex(index) ? firstSide(index) : secondSide(index),
          ),
        ),
      );
}
