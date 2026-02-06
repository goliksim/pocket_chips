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

  static const Key savedPlayersButton = Key('savedPlayersButton');
  static const Key addPlayerButton = Key('addPlayerButton');

  static const Key gameButton = Key('gameButton');

  static Key playerCard(String name) => Key('playerCard_$name');
  static Key userAvatarKeyByAsset(String asset) =>
      Key('user_asset_avatar_$asset');
}

/// Keys for the Game Page.
class GameKeys {
  static const Key page = Key('gamePage');
  static const Key undoButton = Key('undoButton');

  static Key gameStatusTitle(GameStatusEnum status) =>
      Key('gameStatusTitle_${status.name}');

  static const startGameButton = Key('startGameButton');
  static const settingsButton = Key('settingsButton');
}

/// Keys for the Player Editor Page.
class PlayerEditorKeys {
  static const Key dialog = Key('playerEditorDialog');
  static const Key avatarSelectorDialog = Key('avatarSelectorDialog');
  static const Key editorAvatar = Key('editorAvatar');
  static Key selectableAvatar(int index) => Key('selectableAvatar_$index');
  static Key avatarKeyByAsset(String asset) => Key('asset_avatar_$asset');

  static const Key usernameField = Key('usernameField');

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
}

class DonationKeys {
  static const Key dialog = Key('donationDialog');
  static const Key itemsUnavailable = Key('itemsUnavailable');
  static const Key restoreButton = Key('restoreButton');
  static const Key retryButton = Key('retryButtin');

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

class CommonKeys {
  static Key themeKey(Themes theme) => Key('theme_${theme.name}');
  static const Key closePageButton = Key('close_page_button');

  static const Key confirmationWindow = Key('confirmationWindow');
  static const Key confirmButton = Key('confirmButton');

  static const Key settingsDialog = Key('settingsDialog');
}
