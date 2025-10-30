import '../domain/models/game/game_state_enum.dart';
import 'app_localizations.dart';

String getGameStateName({
  required AppLocalizations strings,
  required GameStatusEnum state,
}) {
  switch (state) {
    case GameStatusEnum.notStarted:
      return strings.game_welc;
    case GameStatusEnum.preFlop:
      return strings.game_pflop;
    case GameStatusEnum.flop:
      return strings.game_flop;
    case GameStatusEnum.turn:
      return strings.game_turn;
    case GameStatusEnum.river:
      return strings.game_river;
    case GameStatusEnum.showdown:
      return strings.game_shdw;
    case GameStatusEnum.gameBreak:
      return strings.game_break;
  }
}
