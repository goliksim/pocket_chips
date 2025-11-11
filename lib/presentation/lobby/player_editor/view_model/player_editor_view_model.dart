import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/navigation/navigation_manager.dart';
import '../../../../domain/model_holders/lobby_state_holder.dart';
import '../../../../domain/model_holders/saved_players_model_holder.dart';
import '../../../../domain/models/lobby/lobby_state_model.dart';
import '../../../../domain/models/player/player_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../services/assets_provider.dart';
import '../../../../services/toast_manager.dart';
import '../view_state/player_editing_state.dart';

class PlayerEditorViewModel with ChangeNotifier {
  final NavigationManager _navigationManager;
  final SavedPlayersModelHolder _savedPlayersModelHolder;
  final LobbyStateHolder _lobbyStateHolder;
  final ToastManager _toastManager;
  final AppLocalizations _strings;
  final String? _playerUid;

  static const String standartName = '';

  late PlayerEditingState playerState;

  bool get newPlayerEditing => _playerUid == null;

  PlayerEditorViewModel({
    required LobbyStateHolder lobbyStateHolder,
    required SavedPlayersModelHolder savedPlayersModelHolder,
    required NavigationManager navigationManager,
    required ToastManager toastManager,
    required AppLocalizations strings,
    String? playerUid,
  })  : _lobbyStateHolder = lobbyStateHolder,
        _savedPlayersModelHolder = savedPlayersModelHolder,
        _navigationManager = navigationManager,
        _toastManager = toastManager,
        _strings = strings,
        _playerUid = playerUid {
    _init();
  }

  void _init() {
    final newPlayer = _playerUid == null;
    final lobby = _lobbyStateHolder.activeLobby;

    final lobbyPlayer = newPlayer ? null : lobby.players.findByUid(_playerUid!);
    final lobbyPlayerBank = lobby.banks[_playerUid];

    if (!newPlayer && (lobbyPlayer == null)) {
      throw Exception('Cannot find player with uid $_playerUid');
    }

    final playerForEditing = newPlayer ? null : lobbyPlayer;

    playerState = PlayerEditingState(
      nameInput: playerForEditing?.name,
      assetUrl: playerForEditing?.assetUrl ?? AssetsProvider.emptyPlayerAsset,
      bankInput: lobbyPlayerBank ?? lobby.defaultBank,
      forceDeadler: lobby.dealerId == null,
      makeDealer: lobby.dealerId == _playerUid && _playerUid != null,
    );
  }

  Future<void> openLogoEditor() async {
    final newLogo = await _navigationManager.openPlayerLogoEditor();

    if (newLogo != null) {
      _changeLogo(newLogo);
    }
  }

  void _changeLogo(String newLogo) {
    playerState = playerState.copyWith(assetUrl: newLogo);

    notifyListeners();
  }

  void changePlayerName(String name) {
    final result = name.isEmpty ? null : name;

    playerState = playerState.copyWith(nameInput: result);

    notifyListeners();
  }

  void makeDealer(bool? isDealer) {
    playerState = playerState.copyWith(makeDealer: isDealer!);

    notifyListeners();
  }

  void changeBank(String bank) {
    final int? newBank;

    if (bank.isNotEmpty) {
      newBank = int.parse(bank);
    } else {
      newBank = _lobbyStateHolder.activeLobby.defaultBank;
    }

    playerState = playerState.copyWith(bankInput: newBank);

    notifyListeners();
  }

  bool get _validBank {
    final bankInput = playerState.bankInput;
    return kDebugMode || (bankInput != null && bankInput > 0);
  }

  bool get _validIcon =>
      playerState.assetUrl != AssetsProvider.emptyPlayerAsset;
  bool get _validName => playerState.nameInput?.isNotEmpty ?? false;

  bool get validateInput => _validIcon && _validName && _validBank;

  void notifyWrongInput() {
    if (!_validName) {
      return _toastManager.showToast('Please enter player name');
    }
    if (!_validIcon) {
      return _toastManager.showToast('Please select icon for player');
    }
    if (!_validBank) {
      return _toastManager.showToast(_strings.toast_bank3);
    }
  }

  Future<void> confirmEditing() async {
    // проверка чтобы челикс не ввел пустой символ
    //SystemChrome.restoreSystemUIOverlays();

    final lobby = _lobbyStateHolder.activeLobby;

    // Проверяем, что новый игрок с норм данными
    if (!validateInput) {
      _toastManager.showToast(
        _strings.toast_incorrect_player,
      );

      return;
    }

    final playerModel = PlayerModel(
      uid: _playerUid ?? Uuid().v4(),
      name: playerState.nameInput!,
      assetUrl: playerState.assetUrl,
    );

    // Проверяем, что не ввели данные существующего игрока
    if (newPlayerEditing && lobby.players.contains(playerModel)) {
      _toastManager.showToast(_strings.toast_alred2);

      return;
    }

    // Проверяем банк на минимальный блайнд
    final bank = playerState.bankInput!;
    final currentBigBlind = lobby.bigBlindValue;
    if (bank < currentBigBlind) {
      _toastManager.showToast(
        '${_strings.toast_bank1}\n${_strings.toast_bank2} - ${lobby.bigBlindValue}',
      );
    }

    try {
      if (newPlayerEditing) {
        await _lobbyStateHolder.addPlayer(
          player: playerModel,
          bank: bank,
          makeDealer: playerState.forceDeadler || playerState.makeDealer,
        );

        return _pop();
      }

      await _lobbyStateHolder.updatePlayer(
        player: playerModel,
        bank: bank,
        makeDealer: playerState.makeDealer,
      );
      await _savedPlayersModelHolder.updatePlayer(
        player: playerModel,
      );

      return _pop();
    } on Exception catch (e) {
      _toastManager.showToast(e.toString());

      return;
    }
  }

  void _pop() => _navigationManager.pop();
}
