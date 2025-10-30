// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerEntity _$PlayerEntityFromJson(Map json) => PlayerEntity(
      uid: PlayerEntity.idFromJson(json['uid'] as String?),
      name: json['name'] as String,
      assetUrl: json['assetUrl'] as String,
    );

Map<String, dynamic> _$PlayerEntityToJson(PlayerEntity instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'assetUrl': instance.assetUrl,
    };
