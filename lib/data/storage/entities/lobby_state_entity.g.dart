// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lobby_state_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LobbyStateEntity _$LobbyStateEntityFromJson(Map json) => LobbyStateEntity(
      smallBlindValue: (json['smallBlindValue'] as num).toInt(),
      defaultBank: (json['defaultBank'] as num).toInt(),
      gameState: $enumDecode(_$GameStatusEnumEnumMap, json['gameState']),
      players: (json['players'] as List<dynamic>?)
          ?.map(
              (e) => PlayerEntity.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      banks: (json['banks'] as Map?)?.map(
        (k, e) => MapEntry(k as String, (e as num).toInt()),
      ),
      dealerId: json['dealerId'] as String?,
    );

Map<String, dynamic> _$LobbyStateEntityToJson(LobbyStateEntity instance) =>
    <String, dynamic>{
      'gameState': _$GameStatusEnumEnumMap[instance.gameState]!,
      'smallBlindValue': instance.smallBlindValue,
      'defaultBank': instance.defaultBank,
      'players': instance.players?.map((e) => e.toJson()).toList(),
      'banks': instance.banks,
      'dealerId': instance.dealerId,
    };

const _$GameStatusEnumEnumMap = {
  GameStatusEnum.notStarted: 'notStarted',
  GameStatusEnum.preFlop: 'preFlop',
  GameStatusEnum.flop: 'flop',
  GameStatusEnum.turn: 'turn',
  GameStatusEnum.river: 'river',
  GameStatusEnum.showdown: 'showdown',
  GameStatusEnum.gameBreak: 'gameBreak',
};
