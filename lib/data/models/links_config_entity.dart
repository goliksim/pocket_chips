import 'package:freezed_annotation/freezed_annotation.dart';

part 'links_config_entity.freezed.dart';
part 'links_config_entity.g.dart';

@freezed
abstract class LinksConfigEntity with _$LinksConfigEntity {
  static const String name = 'links_config';

  const factory LinksConfigEntity({
    @JsonKey(
      name: 'android_store_url',
      defaultValue: DefaultLinksConfig.androidStoreUrlDefault,
    )
    required String androidStoreUrl,
    @JsonKey(
      name: 'ios_store_url',
      defaultValue: DefaultLinksConfig.iosStoreUrlDefault,
    )
    required String iosStoreUrl,
    @JsonKey(
      name: 'privacy_policy_url',
      defaultValue: DefaultLinksConfig.privacyPolicyUrlDefault,
    )
    required String privacyPolicyUrl,
    @JsonKey(
      name: 'github_url',
      defaultValue: DefaultLinksConfig.githubUrlDefault,
    )
    required String githubUrl,
    @JsonKey(
      name: 'telegram_url',
      defaultValue: DefaultLinksConfig.telegramUrlDefault,
    )
    required String telegramUrl,
    @JsonKey(
      name: 'support_email',
      defaultValue: DefaultLinksConfig.supportEmailDefault,
    )
    required String supportEmail,
  }) = _LinksConfigEntity;

  factory LinksConfigEntity.fromJson(Map<String, dynamic> json) =>
      _$LinksConfigEntityFromJson(json);

  static LinksConfigEntity defaultConfig() => LinksConfigEntity(
        androidStoreUrl: DefaultLinksConfig.androidStoreUrlDefault,
        iosStoreUrl: DefaultLinksConfig.iosStoreUrlDefault,
        privacyPolicyUrl: DefaultLinksConfig.privacyPolicyUrlDefault,
        githubUrl: DefaultLinksConfig.githubUrlDefault,
        telegramUrl: DefaultLinksConfig.telegramUrlDefault,
        supportEmail: DefaultLinksConfig.supportEmailDefault,
      );
}

class DefaultLinksConfig {
  static const String androidStoreUrlDefault =
      'https://play.google.com/store/apps/details?id=com.goliksim.pocketchips';
  //TODO add iOS store URL
  static const String iosStoreUrlDefault =
      'https://apps.apple.com/app/idYOUR_IOS_APP_ID';
  static const String privacyPolicyUrlDefault =
      'https://github.com/goliksim/pocket_chips/blob/main/privacy_policy.md';
  static const String githubUrlDefault = 'https://github.com/goliksim';
  static const String telegramUrlDefault = 'https://t.me/goliksim';
  static const String supportEmailDefault = 'goliksim@gmail.com';
}
