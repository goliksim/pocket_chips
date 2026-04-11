import '../view_state/game_control_result.dart';
import '../view_state/game_page_control_state.dart';

abstract interface class GameControlViewModel {
  GamePageControlState get controlsState;

  Future<void> onControlAction(GameControlResult result);

  Future<void> openSettings();

  Future<void> startBetting();

  Future<void> increaseGameLevel();
}
