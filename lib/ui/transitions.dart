import 'package:firstapp/internal/application.dart';
import 'package:flutter/material.dart';

Future<Object?> transitionDialog({
  required context,
  bool barrierDismissible = true,
  required Widget child,
  required WidgetBuilder builder,
  String type = "Scale",
  Duration duration = const Duration(milliseconds: 500),
  Color barrierColor = const Color(0x80000000),
}) {
  final ThemeData theme = Theme.of(context);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = child;
      Builder(builder: (BuildContext context) {
        return theme != null ? Theme(data: theme, child: pageChild) : pageChild;
      });
      return child;
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    transitionDuration: duration,
    transitionBuilder: getTransition(type),
  );
}

getTransition(String type) {
  switch (type) {
    case "Scale1":
      return dialogScale1;
    case "SlideUp":
      return _dialogSlideUp;
    case "SlideDown":
      return _dialogSlideDown;
    default:
      return dialogScale1;
  }
}

Widget dialogScale1(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeOutBack,
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        ),
        child: child,
      ));
}

Widget _dialogSlideUp(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
    child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        ),
        child: child),
  );
}

Widget _dialogSlideDown(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn,
        ),
        child: child,
      ));
}

Widget dialogWave1(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return ShaderMask(
      shaderCallback: (rect) {
        return RadialGradient(
                radius: Tween<double>(begin: 0, end: 2.5).evaluate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.fastOutSlowIn.flipped,
                    reverseCurve: Curves.fastOutSlowIn,
                  ),
                ),
                colors: [Colors.white, Colors.transparent, Colors.transparent],
                stops: [0.4, 0.7, 1],
                center: FractionalOffset(0.13, 0.5))
            .createShader(rect);
      },
      child: child);
}

//Слайд с главного экрана
class SlidePageRoute extends PageRouteBuilder {
  final Widget child;
  final Widget childCurrent;
  final AxisDirection direction;

  SlidePageRoute({
    required this.child,
    required this.childCurrent,
    this.direction = AxisDirection.left,
  }) : super(
          transitionDuration: const Duration(milliseconds: 850),
          reverseTransitionDuration: const Duration(milliseconds: 850),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      Stack(
        children: [
          SlideTransition(
              position: Tween<Offset>(
                begin: Offset.zero,
                end: getBeginOffset().scale(-1, -1),
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutQuart.flipped)),
              child: childCurrent),
          SlideTransition(
              position: Tween<Offset>(
                begin: getBeginOffset(),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutQuart.flipped)),
              child: child),
        ],
      );

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.right:
        return const Offset(-1, 0);
      case AxisDirection.left:
        return const Offset(1, 0);
    }
  }
}
