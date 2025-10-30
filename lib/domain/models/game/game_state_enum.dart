enum GameStatusEnum {
  notStarted,
  preFlop,
  flop,
  turn,
  river,
  showdown,
  gameBreak;
}

extension LobbyStateEnumX on GameStatusEnum {
  bool get isStarted => this != GameStatusEnum.notStarted;
  bool get isNotStarted => this == GameStatusEnum.notStarted;

  bool get canEditPlayers =>
      {GameStatusEnum.notStarted, GameStatusEnum.gameBreak}.contains(this);

  GameStatusEnum get next {
    switch (this) {
      case GameStatusEnum.notStarted:
        return GameStatusEnum.preFlop;
      case GameStatusEnum.preFlop:
        return GameStatusEnum.flop;
      case GameStatusEnum.flop:
        return GameStatusEnum.turn;
      case GameStatusEnum.turn:
        return GameStatusEnum.river;
      case GameStatusEnum.river:
        return GameStatusEnum.showdown;
      case GameStatusEnum.showdown:
        return GameStatusEnum.gameBreak;
      case GameStatusEnum.gameBreak:
        return GameStatusEnum.preFlop;
    }
  }
}
