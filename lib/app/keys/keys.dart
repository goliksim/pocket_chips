import 'package:flutter/widgets.dart';

import '../../domain/models/game/game_state_enum.dart';
import '../../utils/theme/themes.dart';

/// Keys for the Onboarding flow.
class OnboardingKeys {
  static const Key updateDialog = Key('updateDialog');
  static const Key aboutDialog = Key('aboutDialog');

  static const Key skipButton = Key('skipButton');

  static const Key showUpdateDialogButton = Key('showUpdateDialogButton');

  static const Key closeUpdateDialogButton = Key('closeUpdateDialogButton');
  static const Key closeAboutDialogButton = Key('closeAboutDialogButton');
}

/// Keys for the Home Page.
class HomeKeys {
  static const Key page = Key('homePage');

  static const Key helpButton = Key('aboutButton');
  static const Key themeSwapButton = Key('themeSwapButton');

  static const Key continueButton = Key('continueButton');
  static const Key newGameButton = Key('newGameButton');
  static const Key solverButton = Key('solverButton');
  static const Key donationButton = Key('donationButton');
}

/// Keys for the Lobby Page.
class LobbyKeys {
  static const Key page = Key('lobbyPage');

  static const Key startingStackButton = Key('startingStackButton');
  static const Key resetLobbyButton = Key('resetLobbyButton');
  static const Key savedPlayersButton = Key('savedPlayersButton');
  static const Key addPlayerButton = Key('addPlayerButton');

  static const Key gameButton = Key('gameButton');
  static const Key settingsButton = Key('settingsButton');

  static Key playerCard(String name) => Key('playerCard_$name');
  static Key playerBank(int bank) => Key('playerBank_$bank');
  static const Key dealerIcon = Key('player_dealer_icon');

  static Key userAvatarKeyByAsset(String asset) =>
      Key('user_asset_avatar_$asset');
}

class BankEditorKeys {
  static Key dialog = Key('bank_editor_dialog');

  static Key textField = Key('bank_editor_text_field');
  static Key confirmButton = Key('bank_editor_confirm_button');
}

/// Keys for the Game Page.
class GameKeys {
  static const Key page = Key('gamePage');
  static const Key undoButton = Key('undoButton');

  static Key gameStatusTitle(GameStatusEnum status) =>
      Key('gameStatusTitle_${status.name}');
  static Key blinds(int smallBlind) =>
      Key('blinds_${smallBlind}_${smallBlind * 2}');

  static const startGameButton = Key('startGameButton');
  static const settingsButton = Key('settingsButton');
}

class GameTableKeys {
  static const Key addMainButton = Key('game_add_main_button');
  static const Key addNewPlayerButton = Key('game_add_new_player_button');
  static const Key addSavedPlayerButton = Key('game_add_saved_player_button');

  static Key playerCard(String name) => Key('game_player_card_$name');
  static Key playerBank(String name, int bank) =>
      Key('game_player_bank_${name}_$bank');
  static Key playerBet(String name, int bet) =>
      Key('game_player_bet_${name}_$bet');
  static Key currentPlayerMarker(String name) =>
      Key('game_current_player_$name');
}

class GameControlKeys {
  static const Key raiseButton = Key('game_raise_button');
  static const Key callButton = Key('game_call_button');
  static const Key allInButton = Key('game_all_in_button');
  static const Key foldButton = Key('game_fold_button');

  static const Key raiseCancelButton = Key('game_raise_cancel_button');
  static const Key raiseConfirmButton = Key('game_raise_confirm_button');

  static const Key raiseField = Key('game_raise_field');
  static const Key raiseSlider = Key('game_raise_slider');
  static const Key raiseMinLabel = Key('game_raise_min_label');
  static const Key raiseMaxLabel = Key('game_raise_max_label');

  static Key raiseChip(int value) => Key('game_raise_chip_$value');
}

class WinnerKeys {
  static const Key winnerDialog = Key('winner_dialog');
  static const Key winnerChoiceDialog = Key('winner_choice_dialog');
  static const Key winnerChoiceConfirmButton =
      Key('winner_choice_confirm_button');
  static const Key winnerChoiceSolverButton =
      Key('winner_choice_solver_button');

  static Key winnerChoiceItem(String uid) => Key('winner_choice_item_$uid');
  static Key winnerChoiceCheckbox(String uid) =>
      Key('winner_choice_checkbox_$uid');
}

/// Keys for the Player Editor Page.
class PlayerEditorKeys {
  static const Key dialog = Key('playerEditorDialog');
  static const Key avatarSelectorDialog = Key('avatarSelectorDialog');
  static const Key editorAvatar = Key('editorAvatar');
  static Key selectableAvatar(int index) => Key('selectableAvatar_$index');
  static Key avatarKeyByAsset(String asset) => Key('asset_avatar_$asset');

  static const Key usernameField = Key('usernameField');
  static const Key bankField = Key('bankField');
  static const Key dealerCheckbox = Key('dealerCheckbox');

  static const Key confirmButton = Key('confirmButton');
}

class ProVersionKeys {
  static const Key proVersionOfferDialog = Key('proVersionOfferDialog');
  static const Key proVersionBlockWrapper = Key('proVersionBlockWrapper');

  static const Key proVersionPurshasedButton = Key('proVersionPurshasedButton');
  static const Key proVersionAvailableButton = Key('proVersionAvailableButton');
  static const Key proVersionNotAvailableButton =
      Key('proVersionNotAvailableButton');

  static const Key proVersionCloseButton = Key('proVersionCloseButton');
}

class SolverKeys {
  static const Key page = Key('solverDialog');

  static const Key closeButton = Key('closeButton');

  static const Key cardPickerDialog = Key('solver_card_picker_dialog');

  static Key cardPickerValue(int value) => Key('solver_card_value_$value');
  static Key cardPickerSuit(String suit) => Key('solver_card_suit_$suit');

  static Key tableCardFront(int index) =>
      Key('solver_table_front_index_$index');

  static Key cardValue(int value, String suit) =>
      Key('solver_card_value_${value}_suit_$suit');

  static Key tableCardBack(int index) => Key('solver_table_back_$index');

  static Key playerCardButtonFront(int playerIndex, int cardIndex) =>
      Key('solver_player_${playerIndex}_button_front_$cardIndex');

  static Key playerCardButtonBack(int playerIndex, int cardIndex) =>
      Key('solver_player_${playerIndex}_button_back_$cardIndex');

  static Key playerCardFront(int playerIndex, int cardIndex) =>
      Key('solver_player_${playerIndex}_front_$cardIndex');

  static Key playerCardBack(int playerIndex, int cardIndex) =>
      Key('solver_player_${playerIndex}_back_$cardIndex');

  static Key winnerBadge(int playerIndex) => Key('solver_winner_$playerIndex');
}

class DonationKeys {
  static const Key dialog = Key('donationDialog');
  static const Key itemsUnavailable = Key('itemsUnavailable');
  static const Key restoreButton = Key('restoreButton');
  static const Key retryButton = Key('retryButton');

  static Key item({
    required String id,
    required bool loaded,
    required bool isBuyed,
  }) =>
      Key('item_${id}_isBuyed_${isBuyed}_loaded_$loaded');
}

class SavedPlayersKeys {
  static const Key dialog = Key('savedPlayersDialog');

  static Key playerCard(String name) => Key('saved_playerCard_$name');
}

class GameSettingsKeys {
  static const Key dialog = Key('settings_dialog');

  static const Key stackField = Key('settings_stack_field');
  static const Key smallBlindField = Key('settings_sm_blind_field');

  static const Key confirmButton = Key('settings_confirm_button');
}

class CommonKeys {
  static Key themeKey(Themes theme) => Key('theme_${theme.name}');
  static const Key closePageButton = Key('close_page_button');

  static const Key confirmationWindow = Key('confirmationWindow');
  static const Key confirmButton = Key('confirmButton');
}
