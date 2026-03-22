import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../shared_preferences/daos/dao.dart';

class ProVersionDao extends Dao<bool> {
  @override
  String get key => 'pro_version_key';

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(),
  );

  @override
  Future<bool> read() async {
    final value = await _storage.read(key: key);
    return value != null && value == 'true';
  }

  @override
  Future<void> write(bool value) async {
    await _storage.write(
      key: key,
      value: value.toString(),
    );
  }
}
