import '../models/remote_config_links.dart';

abstract class RemoteConfigRepository {
  Future<void> initialize();
  Future<RemoteConfigLinks> fetchLinks();
}
