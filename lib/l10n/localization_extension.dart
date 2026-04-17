import '../domain/models/game/blind_level_model.dart';
import '../domain/models/game/game_state_enum.dart';
import '../domain/models/game/sit_out_mode.dart';
import '../presentation/settings/view_state/game_settings_mode_state.dart';
import '../utils/extensions.dart';
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

  String anteTypeLabel(AnteType type) {
    switch (type) {
      case AnteType.none:
        return ante_type_none;
      case AnteType.traditional:
        return ante_type_traditional;
      case AnteType.bigBlindAnte:
        return ante_type_big_blind;
    }
  }

  String sitOutModeLabel(SitOutMode mode) {
    switch (mode) {
      case SitOutMode.cashGame:
        return sit_out_mode_cash;
      case SitOutMode.tournament:
        return sit_out_mode_tournament;
    }
  }

  String settingsModeLabel(GameSettingsModeState mode) =>
      mode == GameSettingsModeState.simple ? sett_mode_simple : sett_mode_pro;

  String progressionLabel(BlindProgressionType type) {
    switch (type) {
      case BlindProgressionType.manual:
        return sett_progression_manual;
      case BlindProgressionType.everyNHands:
        return sett_progression_hands;
      case BlindProgressionType.everyNMinutes:
        return sett_progression_minutes;
    }
  }

  String progressionLeftLabel(BlindProgressionType type) {
    switch (type) {
      case BlindProgressionType.manual:
        return "";
      case BlindProgressionType.everyNHands:
        return sett_progression_hands_left;
      case BlindProgressionType.everyNMinutes:
        return sett_progression_minutes_left;
    }
  }

  String blindsValueLabel(int smallBlind) =>
      '${smallBlind.toCompactBank}\u2215${(smallBlind * 2).toCompact}';
  String anteValueLabel(int? anteValue, AnteType anteType) =>
      '${anteValue != null ? '${anteValue.toCompactBank} \u2215 ' : ''}${anteTypeLabel(anteType)}';
}
