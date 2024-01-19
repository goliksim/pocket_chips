import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pocket_chips/data/uiValues.dart';
import 'package:pocket_chips/ui/ui_widgets.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({super.key, required this.child, this.edgeOffset});
  final double? edgeOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: thisTheme.bgrColor, //Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        vertical: stdHorizontalOffset,
        horizontal: adaptiveOffset,
      ), //windowInitialization(MediaQuery.of(context).size.height,MediaQuery.of(context).size.width)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(stdBorderRadius)),
      ),
      child: SizedBox(
        width: stdButtonWidth,
        height: 560.h,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(
              stdBorderRadius,
            ),
          ),
          child: PatternContainer(
            opacity: 0.4,
            child: Padding(
              padding: EdgeInsets.all(edgeOffset ?? stdHorizontalOffset * 2),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
