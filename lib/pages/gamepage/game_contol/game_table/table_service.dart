import 'dart:math';

import 'package:pocket_chips/data/lobby.dart';

double getCos(a, addButton) {
  double offset =
      thisLobby.lobbyRandomOffset[a] / thisLobby.lobbyPlayers.length;
  return cos(2 * pi * (a / (thisLobby.lobbyPlayers.length + addButton))) *
      pow(
        (cos(
          2 * pi * (a / (thisLobby.lobbyPlayers.length + addButton)) + offset,
        )).abs(),
        0.3,
      );
}

double getSin(a, addButton, {multiply = 0}) {
  double offset =
      0; // thisLobby.lobbyRandomOffset[a]/thisLobby.lobbyPlayers.length*2;
  return sin(
        2 * pi * (a / (thisLobby.lobbyPlayers.length + addButton)) + offset,
      ) *
      pow(
        sin(
          2 * pi * (a / (thisLobby.lobbyPlayers.length + addButton)) +
              0.01 +
              offset,
        ).abs(),
        multiply,
      );
}
