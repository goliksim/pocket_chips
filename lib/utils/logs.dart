import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_flags.dart';

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
    if (kEnableFirebase && Firebase.apps.isNotEmpty) {
      await FirebaseCrashlytics.instance.log(text);
    }
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
