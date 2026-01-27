import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import 'ui_widgets.dart';

class DialogWidget extends StatelessWidget {
  final double? edgeOffset;
  final Widget child;

  const DialogWidget({
    super.key,
    required this.child,
    this.edgeOffset,
  });

  @override
  Widget build(BuildContext context) => Dialog(
        elevation: 0,
        backgroundColor: context.theme.bgrColor,
        insetPadding: EdgeInsets.symmetric(
          vertical: stdHorizontalOffset,
          horizontal: adaptiveOffset,
        ),
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
            child: PatternBackground(
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
