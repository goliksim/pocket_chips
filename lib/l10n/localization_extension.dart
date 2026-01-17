import '../domain/models/game/game_state_enum.dart';
import 'app_localizations.dart';

extension LocalizationExtension on AppLocalizations {
  String getGameStateName(GameStatusEnum state) {
    switch (state) {
      case GameStatusEnum.notStarted:
        return game_welc;
      case GameStatusEnum.preFlop:
        return game_pflop;
      case GameStatusEnum.flop:
        return game_flop;
      case GameStatusEnum.turn:
        return game_turn;
      case GameStatusEnum.river:
        return game_river;
      case GameStatusEnum.showdown:
        return game_shdw;
      case GameStatusEnum.gameBreak:
        return game_break;
    }
  }

  String getProductNameById(String productId) {
    switch (productId) {
      case 'pocket_chips_pro':
        return 'Pocket Chips PRO';
      case 'huge_donat':
        return support_huge;
      case 'modest_donat':
        return support_modest;
      case 'nice_donat':
        return support_nice;
      default:
        return 'Unkown item';
    }
  }
}
