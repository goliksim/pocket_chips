import 'package:flutter/material.dart';
import 'package:pocket_chips/internal/cards/card_model.dart' as c;
import 'package:pocket_chips/internal/cards/winner_gpt.dart';

extension CheckCardsBuilder on BuildContext {
  int get winner => CheckCardsInherited.of(this).winner;
  List<Combination?> get combinations =>
      CheckCardsInherited.of(this).combinations;
  List<c.Card?>? get tableCards => CheckCardsInherited.of(this).tableCards;
  List<List<c.Card?>>? get playerCards =>
      CheckCardsInherited.of(this).playerCards;
  Function(c.Card?) get notInCards => CheckCardsInherited.of(this).notInCards;
  Function get updateCombinations =>
      CheckCardsInherited.of(this).updateCombinations;
}

class CheckCardsInherited extends InheritedWidget {
  CheckCardsInherited({
    Key? key,
    required this.winner,
    required this.combinations,
    required Widget child,
    required this.tableCards,
    required this.playerCards,
  }) : super(key: key, child: child);

  final List<c.Card?> tableCards;
  final List<List<c.Card?>> playerCards;
  int winner;
  List<Combination?> combinations;

  bool notInCards(c.Card? card) {
    if (card == null) return true;
    var allCards = tableCards;
    for (var cards in playerCards) {
      allCards = [...allCards, ...cards];
    }
    return allCards.every((e) => e != card);
  }

  void updateCombinations() {
    var (win, comb) = determineWinner(playerCards, tableCards);
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
