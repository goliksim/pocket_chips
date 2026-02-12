import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_links.freezed.dart';

@freezed
abstract class RemoteConfigLinks with _$RemoteConfigLinks {
  const factory RemoteConfigLinks({
    required String androidStoreUrl,
    required String iosStoreUrl,
    required String privacyPolicyUrl,
    required String githubUrl,
    required String telegramUrl,
    required String supportEmail,
  }) = _RemoteConfigLinks;
}
