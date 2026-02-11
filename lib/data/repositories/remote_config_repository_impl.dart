import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../domain/models/remote_config_links.dart';
import '../../domain/repositories/remote_config_repository.dart';
import '../../utils/logs.dart';
import '../builders/remote_config_links_builder.dart';
import '../models/links_config_entity.dart';

class RemoteConfigRepositoryImpl implements RemoteConfigRepository {
  final FirebaseRemoteConfig remoteConfig;
  Future<void>? _configureFuture;

  RemoteConfigRepositoryImpl({
    required this.remoteConfig,
  });

  static const _fetchTimeout = Duration(seconds: 10);
  static const _minimumFetchInterval = Duration(hours: 12);

  @override
  Future<void> initialize() => _configureFuture ??= _configure();

  @override
  Future<RemoteConfigLinks> fetchLinks() async {
    try {
      final activated = await remoteConfig.fetchAndActivate();
      logs.writeLog('RemoteConfig fetchAndActivate: $activated');

      final json = remoteConfig.getValue(LinksConfigEntity.name).asString();
      final entity = json.isEmpty
          ? LinksConfigEntity.defaults
          : LinksConfigEntity.fromJson(jsonDecode(json));

      logs.writeLog('RemoteConfig get config: $json');

      return RemoteConfigLinksBuilder.fromEntity(entity);
    } catch (error) {
      logs.writeLog('RemoteConfig fetch error: $error');

      return RemoteConfigLinksBuilder.fromEntity(LinksConfigEntity.defaults);
    }
  }

  Future<void> _configure() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: _fetchTimeout,
        minimumFetchInterval: _minimumFetchInterval,
      ),
    );

    /* await remoteConfig.setDefaults(
      {
        LinksConfigEntity.name: jsonEncode(LinksConfigEntity.defaults.toJson()),
      },
    );*/
  }
}
