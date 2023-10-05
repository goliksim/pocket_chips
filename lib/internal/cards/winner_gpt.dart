import 'card_model.dart';
part 'combination_gpt.dart';

// Функция для определения комбинации карт на столе
Combination detectCombination(List<Card> playerCards, List<Card> table) {
  List<Card> allCards = [
    ...playerCards,
    ...table
  ]; // Сначала объединяем карты игрока и карты на столе
  allCards.sort(
    (b, a) => a.key.compareTo(b.key),
  ); // !!! Сортируйте карты по их значению по УБЫВАНИЮ

  // Подсчитываем количество карт каждого значения
  Map<int, int> valueCounts = {};
  for (var card in allCards) {
    valueCounts[card.key] = (valueCounts[card.key] ?? 0) + 1;
  }

  // Группировка карт по масти
  Map<CardSuit, List<Card>> cardsBySuit = {};
  for (var card in allCards) {
    if (!cardsBySuit.containsKey(card.suit)) {
      cardsBySuit[card.suit] = [];
    }
    cardsBySuit[card.suit]!.add(card);
  }

  List<Combination Function()> checks = [
    () => _isRoyalFlush(cardsBySuit),
    () => _isStraightFlush(cardsBySuit),
    () => _isFourOfAKind(valueCounts),
    () => _isFullHouse(valueCounts),
    () => _isFlush(cardsBySuit),
    () => _isStraight(allCards),
    () => _isThreeOfAKind(valueCounts),
    () => _isTwoPair(valueCounts),
    () => _isPair(valueCounts),
    () => _highCard(playerCards),
  ];

  // Проверьте наличие комбинаций, начиная с наивысшей
  for (var check in checks) {
    var result = check();
    if (result.hand != PokerHand.none) {
      return result;
    }
  }

  final end = _highCard(playerCards);
  return end;
}

int findIndexOfMax(List<Combination> list) {
  if (list.isEmpty) {
    throw ArgumentError('The list is empty');
  }

  Combination max = list[0];
  int maxIndex = 0;

  for (int i = 1; i < list.length; i++) {
    if (list[i] == max) return -1;
    if (list[i] > max) {
      max = list[i];
      maxIndex = i;
    }
  }

  return maxIndex;
}

(int, List<Combination?>) determineWinner(
  List<List<Card?>> playerCards,
  List<Card?> table,
) {
  if (table.contains(null)) {
    return (-1, List.filled(playerCards.length, null));
  }
  final List<Combination?> combinations = [];
  for (var cards in playerCards) {
    if (cards.contains(null)) {
      combinations.add(null);
      continue;
    }
    combinations.add(
      detectCombination(
        cards.map((e) => e!).toList(),
        table.map((e) => e!).toList(),
      ),
    );
  }

  // Сравните комбинации игроков
  if (combinations.contains(null)) return (-1, combinations);
  return (findIndexOfMax(combinations.map((e) => e!).toList()), combinations);
}
