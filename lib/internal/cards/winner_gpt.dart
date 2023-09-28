import 'card_model.dart';
part 'combination_gpt.dart';

// Функция для определения комбинации карт на столе
(PokerHand, int) detectCombination(List<Card> playerCards, List<Card> table) {
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

  List<(PokerHand, int) Function()> checks = [
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
    if (result.$1 != PokerHand.none) {
      return (result.$1, result.$2);
    }
  }

  final end = _highCard(playerCards);
  return (end.$1, end.$2);
}

int determineWinner(
  List<Card> player1Cards,
  List<Card> player2Cards,
  List<Card> table,
) {
  var (PokerHand player1Combination, int pl1Key) =
      detectCombination(player1Cards, table);
  var (PokerHand player2Combination, int pl2Key) =
      detectCombination(player2Cards, table);

  // Сравните комбинации игроков
  if (player1Combination.index > player2Combination.index) {
    return 1; // Победил первый игрок
  } else if (player1Combination.index < player2Combination.index) {
    return 2; // Победил второй игрок
  } else if (pl1Key > pl2Key) {
    return 1;
  } else if (pl1Key < pl2Key) {
    return 2;
  } else {
    return 0;
  }
}
