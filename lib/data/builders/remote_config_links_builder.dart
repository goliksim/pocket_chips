import '../../domain/models/remote_config_links.dart';
import '../models/links_config_entity.dart';

abstract class RemoteConfigLinksBuilder {
  static RemoteConfigLinks fromEntity(LinksConfigEntity entity) =>
      RemoteConfigLinks(
        androidStoreUrl: entity.androidStoreUrl,
        iosStoreUrl: entity.iosStoreUrl,
        privacyPolicyUrl: entity.privacyPolicyUrl,
        githubUrl: entity.githubUrl,
        telegramUrl: entity.telegramUrl,
        supportEmail: entity.supportEmail,
      );
}
