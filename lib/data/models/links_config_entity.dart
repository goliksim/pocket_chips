import 'package:freezed_annotation/freezed_annotation.dart';

part 'links_config_entity.freezed.dart';
part 'links_config_entity.g.dart';

@freezed
abstract class LinksConfigEntity with _$LinksConfigEntity {
  static const String name = 'links_config';

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory LinksConfigEntity({
    @Default(DefaultLinksConfig.androidStoreUrlDefault) String androidStoreUrl,
    @Default(DefaultLinksConfig.iosStoreUrlDefault) String iosStoreUrl,
    @Default(DefaultLinksConfig.privacyPolicyUrlDefault)
    String privacyPolicyUrl,
    @Default(DefaultLinksConfig.githubUrlDefault) String githubUrl,
    @Default(DefaultLinksConfig.telegramUrlDefault) String telegramUrl,
    @Default(DefaultLinksConfig.supportEmailDefault) String supportEmail,
  }) = _LinksConfigEntity;

  factory LinksConfigEntity.fromJson(Map<String, dynamic> json) =>
      _$LinksConfigEntityFromJson(json);

  static const LinksConfigEntity defaults = LinksConfigEntity();
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
