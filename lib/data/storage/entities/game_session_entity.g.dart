// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_session_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameSessionEntity _$GameSessionEntityFromJson(Map json) => GameSessionEntity(
      bets: Map<String, int>.from(json['bets'] as Map),
      foldedPlayersInactive: (json['foldedPlayersInactive'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      lapCounter: (json['lapCounter'] as num).toInt(),
      currentPlayerUid: json['currentPlayerUid'] as String?,
      firstPlayerUid: json['firstPlayerUid'] as String?,
    );

Map<String, dynamic> _$GameSessionEntityToJson(GameSessionEntity instance) =>
    <String, dynamic>{
      'bets': instance.bets,
      'foldedPlayersInactive': instance.foldedPlayersInactive.toList(),
      'lapCounter': instance.lapCounter,
      'currentPlayerUid': instance.currentPlayerUid,
      'firstPlayerUid': instance.firstPlayerUid,
    };
