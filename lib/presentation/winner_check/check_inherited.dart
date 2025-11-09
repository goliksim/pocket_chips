import 'package:flutter/material.dart' hide Card;

import '../../domain/models/cards/card_model.dart';
import '../../domain/winner_solver.dart';

extension CheckCardsBuilder on BuildContext {
  int get winner => CheckCardsInherited.of(this).winner;
  List<Combination?> get combinations =>
      CheckCardsInherited.of(this).combinations;
  List<Card?>? get tableCards => CheckCardsInherited.of(this).tableCards;
  List<List<Card?>>? get playerCards =>
      CheckCardsInherited.of(this).playerCards;
  Function(Card?) get notInCards => CheckCardsInherited.of(this).notInCards;
  Function get updateCombinations =>
      CheckCardsInherited.of(this).updateCombinations;
}

class CheckCardsInherited extends InheritedWidget {
  CheckCardsInherited({
    required this.winner,
    required this.combinations,
    required super.child,
    required this.tableCards,
    required this.playerCards,
    super.key,
  });

  final List<Card?> tableCards;
  final List<List<Card?>> playerCards;
  int winner;
  List<Combination?> combinations;

  bool notInCards(Card? card) {
    if (card == null) return true;
    var allCards = tableCards;
    for (var cards in playerCards) {
      allCards = [...allCards, ...cards];
    }
    return allCards.every((e) => e != card);
  }

  void updateCombinations() {
    var (win, comb) = WinnerSolver.determineWinner(playerCards, tableCards);
    combinations = comb;
    winner = win;
  }

  @override
  bool updateShouldNotify(CheckCardsInherited oldWidget) {
    return (oldWidget.tableCards != tableCards ||
        playerCards != playerCards ||
        oldWidget.winner != winner ||
        oldWidget.combinations != combinations);
  }

  static CheckCardsInherited of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CheckCardsInherited>()!;
}
