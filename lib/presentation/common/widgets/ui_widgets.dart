import 'package:flutter/material.dart';

import '../../../app/keys/keys.dart';
import '../../../services/assets_provider.dart';
import '../../../utils/extensions.dart';
import '../../../utils/logs.dart';
import '../../../utils/theme/ui_values.dart';

class ConfirmationWindow extends StatelessWidget {
  const ConfirmationWindow({
    super.key,
    required this.title,
    required this.message,
    required this.action,
    required this.actionTitle,
  });

  final String title;
  final String message;
  final String actionTitle;
  final Function action;

  @override
  Widget build(BuildContext context) => Dialog(
        key: CommonKeys.confirmationWindow,
        elevation: 0,
        backgroundColor: context.theme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: adaptiveOffset,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
        ),
        child: Container(
          padding: EdgeInsets.all(
            stdHorizontalOffset,
          ),
          width: stdButtonWidth,
          height: stdDialogHeight / 1.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                alignment: Alignment.center,
                height: stdButtonHeight * 0.5,
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.theme.onBackground,
                    fontSize: stdFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: context.theme.onBackground,
                      fontSize: stdFontSize,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: MyButton(
                      key: CommonKeys.confirmButton,
                      height: stdButtonHeight * 0.75,
                      width: double.infinity,
                      buttonColor: context.theme.bgrColor,
                      textString: actionTitle,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: context.theme.alertColor,
                        fontSize: stdFontSize,
                      ),
                      action: () async {
                        Navigator.of(context).pop(true);
                        action();
                      },
                    ),
                  ),
                  Expanded(
                    child: MyButton(
                      height: stdButtonHeight * 0.75,
                      width: double.infinity,
                      buttonColor: context.theme.bgrColor,
                      textString: context.strings.conf_canc,
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: context.theme.primaryColor,
                        fontSize: stdFontSize,
                      ),
                      action: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.height,
    required this.buttonColor,
    this.action,
    this.borderRadius,
    this.textString,
    this.padding = EdgeInsets.zero,
    this.alignment,
    this.longAction,
    this.width,
    this.child,
    this.textStyle,
    this.side,
  })  : assert(
          textString == null || child == null,
          'Cannot provide both a textString and a child\n',
        ),
        assert(
          textString != null || child != null,
          'textString or child should be set\n',
        );

  final double? height;
  final double? width;
  final EdgeInsets padding;
  final Color buttonColor;
  final Function? action;
  final Function? longAction;
  final BorderRadius? borderRadius;
  final String? textString;
  final Alignment? alignment;
  final Widget? child;
  final TextStyle? textStyle;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) => Container(
        height: (height != null) ? height : stdButtonHeight,
        alignment: alignment,
        width: (width != null) ? width : stdButtonWidth,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: side,
            elevation: stdElevation,
            shape: RoundedRectangleBorder(
              borderRadius: (borderRadius != null)
                  ? borderRadius!
                  : BorderRadius.circular(stdBorderRadius),
            ),
            padding: padding,
            foregroundColor: context.theme.bgrColor,
            backgroundColor: buttonColor,
          ),
          onPressed: () => action?.call(),
          onLongPress: longAction == null ? null : () => longAction?.call(),
          child: (textString != null)
              ? Text(
                  textString!,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: (textStyle != null)
                      ? textStyle
                      : context.theme.stdTextStyle.copyWith(
                          fontSize: stdFontSize,
                        ),
                )
              : child,
        ),
      );
}

class PatternBackground extends StatelessWidget {
  final Widget child;
  final double opacity;

  const PatternBackground({
    required this.child,
    this.opacity = 1.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: context.theme.bgrColor,
          image: DecorationImage(
            filterQuality: FilterQuality.high,
            opacity: 0.3 * opacity,
            image: AssetsProvider.backgroundPattern,
            onError: (_, __) {
              logs.writeLog(
                'Cannot load pattern asset ${AssetsProvider.backgroundPattern}',
              );
            },
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      );
}

Widget proxyDecorator(Widget child, int index, Animation<double> animation) =>
    AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) => Material(
        elevation: 0,
        color: Colors.transparent,
        child: child,
      ),
      child: child,
    );
