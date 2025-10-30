import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_model.freezed.dart';

@freezed
abstract class ConfigModel with _$ConfigModel {
  const factory ConfigModel({
    required bool isDark,
    required bool firstLaunch,
    required String locale,
    required String version,
  }) = _ConfigModel;

  factory ConfigModel.defaults(String version) => ConfigModel(
        isDark: false,
        firstLaunch: true,
        locale: 'en',
        version: version,
      );
}
