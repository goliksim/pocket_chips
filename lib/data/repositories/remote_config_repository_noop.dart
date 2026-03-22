import '../builders/remote_config_links_builder.dart';
import '../models/links_config_entity.dart';
import '../../domain/models/remote_config_links.dart';
import '../../domain/repositories/remote_config_repository.dart';

class RemoteConfigRepositoryNoop implements RemoteConfigRepository {
  @override
  Future<void> initialize() async {}

  @override
  Future<RemoteConfigLinks> fetchLinks() async =>
      RemoteConfigLinksBuilder.fromEntity(LinksConfigEntity.defaults);
}
