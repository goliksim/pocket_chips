import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_entity.g.dart';

@JsonSerializable()
class ConfigEntity {
  final bool isDark;
  final bool firstLaunch;
  final String locale;
  final String version;

  const ConfigEntity({
    required this.isDark,
    required this.firstLaunch,
    required this.locale,
    required this.version,
  });

  factory ConfigEntity.fromJson(Map<String, dynamic> json) =>
      _$ConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigEntityToJson(this);

  @override
  String toString() {
    return '[ConfigEntitiy] - isDark: $isDark, firstLaunch: $firstLaunch, locale: $locale, version: $version';
  }
}
