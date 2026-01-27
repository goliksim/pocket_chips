import 'package:fluttertoast/fluttertoast.dart';

import '../utils/logs.dart';
import '../utils/theme/ui_values.dart';

class ToastManager {
  Future<bool?> toastWarning(String text) => Fluttertoast.showToast(
        msg: text,
        fontSize: stdFontSize * 0.75,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        //TODO: make container for ToastManager
        //backgroundColor: context.theme.bgrColor,
        //textColor: context.theme.onBackground,
      );

  void showToast(String text) async {
    try {
      await toastWarning(text);
    } catch (e) {
      logs.writeLog('TOAST ERROR of: $text');
    }
  }
}

mixin ToastsMixin {
  void showToast(String text) => ToastManager().showToast(text);
}
