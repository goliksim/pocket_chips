import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'player_id.dart';

part 'player_model.freezed.dart';

@freezed
abstract class PlayerModel with _$PlayerModel {
  const factory PlayerModel({
    required PlayerId uid,
    required String name,
    required String assetUrl,
  }) = _PlayerModel;

  const PlayerModel._();

  @override
  //override operator == to not add existing players
  bool operator ==(covariant PlayerModel other) => ((uid == other.uid) &&
      (name == other.name) &&
      (assetUrl == other.assetUrl));

  @override
  int get hashCode => uid.codeUnits.reduce((a, b) => a + b);
}

extension PlayerModelX on Iterable<PlayerModel> {
  PlayerModel? findByUid(String? uid) => firstWhereOrNull((p) => p.uid == uid);
}
