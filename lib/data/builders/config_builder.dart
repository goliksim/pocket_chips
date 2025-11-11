import '../../domain/models/config_model.dart';
import '../storage/entities/config_entity.dart';

class ConfigEntityBuilder {
  static ConfigModel fromEntity(ConfigEntity entity) => ConfigModel(
        isDark: entity.isDark,
        firstLaunch: entity.firstLaunch,
        locale: entity.locale,
        version: entity.version,
      );

  static ConfigEntity toEntity(ConfigModel model) => ConfigEntity(
        isDark: model.isDark,
        firstLaunch: model.firstLaunch,
        locale: model.locale,
        version: model.version,
      );
}
