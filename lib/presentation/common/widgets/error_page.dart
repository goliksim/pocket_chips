import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/extensions.dart';
import '../../../utils/theme/ui_values.dart';
import 'ui_widgets.dart';

class ErrorPage extends StatelessWidget {
  final String message;
  final bool canPop;
  final VoidCallback? retryCallback;

  const ErrorPage({
    required this.message,
    this.canPop = false,
    this.retryCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) => PatternBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: canPop
                ? IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back,
                      size: stdIconSize,
                    ),
                  )
                : null,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.all(stdHorizontalOffset * 2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: stdHorizontalOffset,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    size: stdIconSize * 3,
                    color: context.theme.alertColor,
                  ),
                  Text(
                    context.strings.error_was_found,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.theme.stdTextStyle.copyWith(
                      fontSize: stdFontSize * 1.2,
                      color: context.theme.alertColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: context.theme.stdTextStyle.copyWith(
                      fontSize: stdFontSize * 0.8,
                      color: context.theme.onBackground,
                    ),
                  ),
                  MyButton(
                    height: stdButtonHeight * 0.65,
                    buttonColor: context.theme.hintColor,
                    action: () {
                      Clipboard.setData(ClipboardData(text: message));
                    },
                    textString: context.strings.error_copy,
                  ),
                  if (retryCallback != null)
                    MyButton(
                      height: stdButtonHeight * 0.75,
                      buttonColor: context.theme.primaryColor,
                      action: retryCallback,
                      textString: context.strings.error_retry_button,
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
