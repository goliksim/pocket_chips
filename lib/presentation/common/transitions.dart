//ФАЙЛ С ПЕРЕХОДАМИ МЕЖДУ ВИДЖЕТАМИ

import 'package:flutter/material.dart';

import '../../utils/theme/ui_values.dart';

enum DialogTransitionType {
  scale,
  slideUp,
  slideDown;
}

Future<T?> transitionDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required Widget child,
  required WidgetBuilder builder,
  DialogTransitionType type = DialogTransitionType.scale,
  Duration duration = const Duration(milliseconds: 500),
  Color barrierColor = const Color(0x80000000),
}) {
  final ThemeData theme = Theme.of(context);
  return showGeneralDialog<T>(
    context: context,
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      final Widget pageChild = child;
      Builder(
        builder: (BuildContext context) => Theme(
          data: theme,
          child: pageChild,
        ),
      );
      return child;
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: barrierColor,
    transitionDuration: duration,
    transitionBuilder: getTransitionBuilder(type),
  );
}

Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    getTransitionBuilder(DialogTransitionType type) {
  switch (type) {
    case DialogTransitionType.scale:
      return _dialogScale;
    case DialogTransitionType.slideUp:
      return _dialogSlideUp;
    case DialogTransitionType.slideDown:
      return _dialogSlideDown;
  }
}

Widget _dialogScale(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) =>
    ScaleTransition(
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
      ),
    );

Widget _dialogSlideUp(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) =>
    SlideTransition(
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
        child: child,
      ),
    );

Widget _dialogSlideDown(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) =>
    SlideTransition(
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
      ),
    );

Widget dialogWaveBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) =>
    ShaderMask(
      shaderCallback: (rect) => RadialGradient(
        radius: Tween<double>(begin: 0, end: 2.5).evaluate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.fastOutSlowIn.flipped,
            reverseCurve: Curves.fastOutSlowIn,
          ),
        ),
        colors: const [Colors.white, Colors.transparent, Colors.transparent],
        stops: const [0.4, 0.7, 1],
        center: FractionalOffset(
          0.5 - 0.275 * stdButtonWidth / MediaQuery.of(context).size.width,
          0.5,
        ),
      ).createShader(rect),
      child: child,
    );

class SlidedPade<T> extends Page<T> {
  final Widget child;

  const SlidedPade({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  @override
  Route<T> createRoute(BuildContext context) => PageRouteBuilder(
        settings: this,
        transitionDuration: const Duration(milliseconds: 650),
        reverseTransitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
}

class FadedPage<T> extends Page<T> {
  final Widget child;

  const FadedPage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  @override
  Route<T> createRoute(BuildContext context) => PageRouteBuilder(
        settings: this,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
}
