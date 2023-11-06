import 'dart:io';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:pocket_chips/data/storage.dart';

final Logs logs = Logs();

class Logs {
  Future<File> get _localFile async {
    final path = await localPath;
    return File('$path/pocketchips/poker_chips.log').create(recursive: true);
  }

  Future<void> writeLog(String text) async {
    log(text);

    if (kDebugMode && (Platform.isAndroid || Platform.isIOS)) {
      DateTime date = DateTime.now();
      String finalDateString =
          '${DateFormat.yMd().format(date)} ${DateFormat.jms().format(date)}\t';
      final file = await _localFile;
      file.writeAsStringSync('$finalDateString$text\n', mode: FileMode.append);
    }
  }
}