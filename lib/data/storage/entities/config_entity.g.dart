// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigEntity _$ConfigEntityFromJson(Map json) => ConfigEntity(
      isDark: json['isDark'] as bool,
      firstLaunch: json['firstLaunch'] as bool,
      locale: json['locale'] as String,
      version: json['version'] as String,
    );

Map<String, dynamic> _$ConfigEntityToJson(ConfigEntity instance) =>
    <String, dynamic>{
      'isDark': instance.isDark,
      'firstLaunch': instance.firstLaunch,
      'locale': instance.locale,
      'version': instance.version,
    };
