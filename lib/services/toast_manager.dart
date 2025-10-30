import 'package:fluttertoast/fluttertoast.dart';

import '../utils/theme/ui_values.dart';

/// Менеджер всплывающих уведомлений
class ToastManager {
  Future<bool?> toastWarning(String text) => Fluttertoast.showToast(
        msg: text,
        fontSize: stdFontSize * 0.75,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: thisTheme.bgrColor,
        textColor: thisTheme.onBackground,
      );

  void showToast(String text) async {
    try {
      await toastWarning(text);
    } catch (e) {
      // ignore: avoid_print
      print('TOAST ERROR of: $text');
    }
  }
}

mixin ToastsMixin {
  void showToast(String text) => ToastManager().showToast(text);
}
