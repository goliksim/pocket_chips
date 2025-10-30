import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/models/player/player_model.dart';

part 'lobby_player_item.freezed.dart';

@freezed
abstract class LobbyPlayerItem with _$LobbyPlayerItem {
  const factory LobbyPlayerItem({
    required String uid,
    required String name,
    required String assetUrl,
    @Default(false) bool isDealer,
    int? bank,
  }) = _LobbyPlayerItem;
}

extension LobbyPlayerItemX on LobbyPlayerItem {
  PlayerModel get toDomain => PlayerModel(
        uid: uid,
        name: name,
        assetUrl: assetUrl,
      );
}

extension PlayerModelX on PlayerModel {
  LobbyPlayerItem toStateItem({
    required bool isDealer,
    int? bank,
  }) =>
      LobbyPlayerItem(
        uid: uid,
        name: name,
        assetUrl: assetUrl,
        bank: bank,
        isDealer: isDealer,
      );
}
