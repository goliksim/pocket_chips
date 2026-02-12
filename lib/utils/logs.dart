import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

final Logs logs = Logs();

class Logs {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/pocketchips/poker_chips.log').create(recursive: true);
  }

  Future<void> writeLog(String text) async {
    log(text);
    //!kDebugMode &&
    if ((!kIsWeb && (Platform.isAndroid || Platform.isIOS))) {
      DateTime date = DateTime.now();
      String finalDateString =
          '${DateFormat.yMd().format(date)} ${DateFormat.jms().format(date)}\t';
      final file = await _localFile;
      file.writeAsStringSync('$finalDateString$text\n', mode: FileMode.append);
    }
  }
}
