part of 'winner_gpt.dart';

//Возможные комбинации
enum PokerHand {
  highCard,
  pair,
  twoPair,
  threeOfAKind,
  straight,
  flush,
  fullHouse,
  fourOfAKind,
  straightFlush,
  royalFlush,
  none
}

//Удаление повторяющихся кард для стритов
List<Card> _uniqueKeyList(List<Card> list) {
  Map<int, Card> uniqueCardsMap = {};
  for (var card in list) {
    uniqueCardsMap[card.key] = card;
  }
  return uniqueCardsMap.values.toList();
}

//Флеш-Рояль
(PokerHand, int) _isRoyalFlush(Map<CardSuit, List<Card>> cardsBySuit) {
  // Проверяем каждую масть на наличие "Straight Flush"
  for (var suit in cardsBySuit.keys) {
    final cardsInSuit = cardsBySuit[suit]!;
    // Проверяем, что есть пять карт одной масти
    if (cardsInSuit.length >= 5) {
      for (int i = 0; i < cardsInSuit.length - 4; i++) {
        if (cardsInSuit[i].key == 14 &&
            cardsInSuit[i + 1].key == 13 &&
            cardsInSuit[i + 2].key == 12 &&
            cardsInSuit[i + 3].key == 11 &&
            cardsInSuit[i + 4].key == 10) {
          return (PokerHand.royalFlush, -1);
        }
      }
    }
  }
  return (PokerHand.none, -1);
}

//Стрит-Флеш
(PokerHand, int) _isStraightFlush(Map<CardSuit, List<Card>> cardsBySuit) {
  PokerHand result = PokerHand.none;

  // Проверяем каждую масть на наличие "Straight Flush"
  for (var suit in cardsBySuit.keys) {
    //удаляем повторения значений
    final cardsInSuit = _uniqueKeyList(cardsBySuit[suit]!);

    // Если в масти меньше 5 карт, нет "Straight Flush"
    if (cardsInSuit.length < 5) {
      continue;
    }
    //проверка на туз (он может быть и в начале)
    if (cardsInSuit.map((e) => e.key).contains(14)) {
      cardsInSuit.add(Card(suit, 1));
    }

    // Ищем последовательность пяти карт
    for (int i = 0; i <= cardsInSuit.length - 5; i++) {
      if (cardsInSuit[i + 4].key - cardsInSuit[i].key == -4) {
        return (PokerHand.straightFlush, cardsInSuit[i].key);
      }
    }
  }
  return (result, -1);
}

//Карэ
(PokerHand, int) _isFourOfAKind(Map<int, int> valueCounts) {
  // Проверяем, есть ли четыре карты с одинаковым значением
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 4) {
      final kickers = valueCounts.keys.where((e) => e != key).toList();
      //kickers.sort((a, b) => b.compareTo(a));
      //kickers.add(0);
      return (
        PokerHand.fourOfAKind,
        key * 100 + kickers.first //один кикер, так как 4 карты уже на столе
      );
    }
  }
  return (PokerHand.none, -1);
}

//ФулХаус
(PokerHand, int) _isFullHouse(Map<int, int> valueCounts) {
  bool hasThreeOfAKind = false;
  bool hasPair = false;
  // Проверяем наличие тройки и пары
  Map<int, int> value = {0: 0, 1: 0};
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 3) {
      hasThreeOfAKind = true;
      value[0] = 100 * key;
    } else if (valueCounts[key] == 2) {
      hasPair = true;
      value[1] = key;
    }
  }
  PokerHand result =
      (hasThreeOfAKind && hasPair) ? PokerHand.fullHouse : PokerHand.none;
  return (result, value[0]! + value[1]!);
}

//Флеш
(PokerHand, int) _isFlush(Map<CardSuit, List<Card>> cardsBySuit) {
  // Проверяем каждую масть на наличие "Straight Flush"
  for (var suit in cardsBySuit.keys) {
    var cardsInSuit = cardsBySuit[suit]!;
    // Если в масти меньше 5 карт, нет "Straight Flush"
    if (cardsInSuit.length < 5) {
      continue;
    }
    //Если есть флеш
    return (
      PokerHand.flush,
      cardsInSuit[0].key * 100000000 +
          cardsInSuit[1].key * 1000000 +
          cardsInSuit[2].key * 10000 +
          cardsInSuit[3].key * 100 +
          cardsInSuit[4].key
    );
  }

  return (PokerHand.none, -1);
}

//Стрит
(PokerHand, int) _isStraight(List<Card> cards) {
  //удаляем повторения
  cards = _uniqueKeyList(cards);

  if (cards.length >= 5) {
    //проверка на туз (он может быть и в начале)
    if (cards.map((e) => e.key).contains(14)) {
      cards.add(Card(CardSuit.c, 1));
    }
    // Проверяем, что есть пять последовательных карт
    PokerHand result = PokerHand.none;
    int maxVal = -1;
    for (int i = 0; i <= cards.length - 5; i++) {
      if (cards[i + 4].key - cards[i].key == -4) {
        result = PokerHand.straight;
        maxVal = cards[i + 4].key;
      }
    }
    return (result, maxVal);
  }

  return (PokerHand.none, -1);
}

//Тройка
(PokerHand, int) _isThreeOfAKind(Map<int, int> valueCounts) {
  // Проверяем наличие тройки
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 3) {
      var kickers = valueCounts.keys.where((e) => e != key).toList();

      return (
        PokerHand.threeOfAKind,
        key * 10000 + kickers[0] * 100 + kickers[1]
      ); //используем два кикера, так как 3 карты уже на столе
    }
  }
  return (PokerHand.none, -1);
}

//Две пары
(PokerHand, int) _isTwoPair(Map<int, int> valueCounts) {
  List<int> pairNumbers = [];
  // Проверяем наличие двух пар
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 2) {
      pairNumbers.add(key);
    }
  }
  final kickers =
      valueCounts.keys.where((e) => !pairNumbers.contains(e)).toList();

  if (pairNumbers.length >= 2) {
    return (
      PokerHand.twoPair,
      pairNumbers.first * 10000 + pairNumbers[1] * 100 + kickers.first
    ); //используем 1 кикер, так как 4 карты уже на столе
  }
  return (PokerHand.none, -1);
}

//Пара
(PokerHand, int) _isPair(Map<int, int> valueCounts) {
  // Проверяем наличие пары
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 2) {
      final kickers = valueCounts.keys.where((e) => e != key).toList();
      return (
        PokerHand.pair,
        key * 1000000 + kickers.first * 10000 + kickers[1] * 100 + kickers[2]
      ); //используем 3 кикер, так как на столе всего 2 карты
    }
  }
  return (PokerHand.none, -1);
}

// Дополнительные функции для сравнения старших карт
(PokerHand, int) _highCard(List<Card> playerCards) {
  playerCards.sort((b, a) => a.key.compareTo(b.key));
  return (PokerHand.highCard, playerCards.first.key * 100 + playerCards[1].key);
}
