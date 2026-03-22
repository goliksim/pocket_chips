import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/models/player/player_model.dart';

part 'game_player_item.freezed.dart';

@freezed
abstract class GamePlayerItem with _$GamePlayerItem {
  const factory GamePlayerItem({
    required String uid,
    required String name,
    required String assetUrl,
    required bool isDealer,
    required bool isCurrent,
    required bool isFolded,
    required int bank,
    required int bet,
  }) = _GamePlayerItem;
}

extension GamePlayerItemX on GamePlayerItem {
  PlayerModel get toDomain => PlayerModel(
        uid: uid,
        name: name,
        assetUrl: assetUrl,
      );
}
