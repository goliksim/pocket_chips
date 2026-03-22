import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/local_path.dart';

Future<File> localFile(String name) async {
  final path = await localPath;
  return File('$path/pocketchips/$name.json').create(recursive: true);
}

abstract class Dao<T> {
  late SharedPreferences prefs;

  String get key;

  Future<T?> read();

  Future<void> write(T value);
}
