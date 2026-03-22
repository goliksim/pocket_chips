part of '../../winner_solver.dart';

class Combination implements Comparable<Combination> {
  Combination(
    this.hand,
    this.strength,
  );

  final PokerHand hand;
  final int strength;

  @override
  int compareTo(Combination other) {
    // First, we compare the type of combination (hand)
    int handComparison = hand.index.compareTo(other.hand.index);

    if (handComparison != 0) {
      return handComparison;
    }

    // If the force is the same, we compare by strength.
    return strength.compareTo(other.strength);
  }

  bool operator >(Combination other) => compareTo(other) > 0;

  @override
  bool operator ==(Object other) =>
      other is Combination &&
      hand.index == other.hand.index &&
      strength == other.strength;

  @override
  int get hashCode => hand.hashCode ^ strength.hashCode;

  @override
  String toString() {
    final text = '$hand with power $strength';
    return text;
  }
}

/// Possible combinations
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

/// Removing duplicate cards for straights
List<Card> _uniqueKeyList(List<Card> list) {
  Map<int, Card> uniqueCardsMap = {};
  for (var card in list) {
    uniqueCardsMap[card.key] = card;
  }
  return uniqueCardsMap.values.toList();
}

/// Royal Flush
Combination _isRoyalFlush(Map<CardSuit, List<Card>> cardsBySuit) {
  // We check each suit for the presence of a "Straight Flush"
  for (var suit in cardsBySuit.keys) {
    final cardsInSuit = cardsBySuit[suit]!;
    // We check that there are five cards of the same suit.
    if (cardsInSuit.length >= 5) {
      for (int i = 0; i < cardsInSuit.length - 4; i++) {
        if (cardsInSuit[i].key == 14 &&
            cardsInSuit[i + 1].key == 13 &&
            cardsInSuit[i + 2].key == 12 &&
            cardsInSuit[i + 3].key == 11 &&
            cardsInSuit[i + 4].key == 10) {
          return Combination(PokerHand.royalFlush, -1);
        }
      }
    }
  }
  return Combination(PokerHand.none, -1);
}

/// Straight Flush
Combination _isStraightFlush(Map<CardSuit, List<Card>> cardsBySuit) {
  PokerHand result = PokerHand.none;

  // We check each suit for the presence of a "Straight Flush"
  for (var suit in cardsBySuit.keys) {
    // remove duplicate values
    final cardsInSuit = _uniqueKeyList(cardsBySuit[suit]!);

    // If there are less than 5 cards in a suit, there is no "Straight Flush"
    if (cardsInSuit.length < 5) {
      continue;
    }
    // check for an ace (it can be at the beginning)
    if (cardsInSuit.map((e) => e.key).contains(14)) {
      cardsInSuit.add(Card(suit, 1));
    }

    // We are looking for a sequence of five cards
    for (int i = 0; i <= cardsInSuit.length - 5; i++) {
      if (cardsInSuit[i + 4].key - cardsInSuit[i].key == -4) {
        return Combination(PokerHand.straightFlush, cardsInSuit[i].key);
      }
    }
  }
  return Combination(result, -1);
}

/// Four Of A Kind (Карэ)
Combination _isFourOfAKind(Map<int, int> valueCounts) {
  // We check if there are four cards with the same value
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 4) {
      final kickers = valueCounts.keys.where((e) => e != key).toList();
      //kickers.sort((a, b) => b.compareTo(a));
      //kickers.add(0);
      return Combination(
        PokerHand.fourOfAKind,
        key * 100 +
            kickers.first, //one kicker, since 4 cards are already on the table
      );
    }
  }
  return Combination(PokerHand.none, -1);
}

/// FullHouse
Combination _isFullHouse(Map<int, int> valueCounts) {
  bool hasThreeOfAKind = false;
  bool hasPair = false;
  // We check for the presence of a triple and a pair
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
  return Combination(result, value[0]! + value[1]!);
}

/// Flush
Combination _isFlush(Map<CardSuit, List<Card>> cardsBySuit) {
  // We check each suit for the presence of a "Flush"
  for (var suit in cardsBySuit.keys) {
    var cardsInSuit = cardsBySuit[suit]!;
    // If there are less than 5 cards in a suit, there is no "Flush"
    if (cardsInSuit.length < 5) {
      continue;
    }
    //Если есть флеш
    return Combination(
      PokerHand.flush,
      cardsInSuit[0].key * 100000000 +
          cardsInSuit[1].key * 1000000 +
          cardsInSuit[2].key * 10000 +
          cardsInSuit[3].key * 100 +
          cardsInSuit[4].key,
    );
  }

  return Combination(PokerHand.none, -1);
}

/// Straight
Combination _isStraight(List<Card> cards) {
  // remove duplicate
  cards = _uniqueKeyList(cards);

  if (cards.length >= 5) {
    // check for an ace (it can be at the beginning)
    if (cards.map((e) => e.key).contains(14)) {
      cards.add(Card(CardSuit.c, 1));
    }
    // We check that there are five consecutive cards
    PokerHand result = PokerHand.none;
    int maxVal = -1;
    for (int i = 0; i <= cards.length - 5; i++) {
      if (cards[i + 4].key - cards[i].key == -4) {
        result = PokerHand.straight;
        maxVal = cards[i + 4].key;
      }
    }
    return Combination(result, maxVal);
  }

  return Combination(PokerHand.none, -1);
}

/// ThreeOfAKind (Тройка)
Combination _isThreeOfAKind(Map<int, int> valueCounts) {
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 3) {
      var kickers = valueCounts.keys.where((e) => e != key).toList();

      return Combination(
        PokerHand.threeOfAKind,
        key * 10000 + kickers[0] * 100 + kickers[1],
      ); //we use two kickers since there are already 3 cards on the table
    }
  }
  return Combination(PokerHand.none, -1);
}

/// TwoPair
Combination _isTwoPair(Map<int, int> valueCounts) {
  List<int> pairNumbers = [];

  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 2) {
      pairNumbers.add(key);
    }
  }
  final kickers =
      valueCounts.keys.where((e) => !pairNumbers.contains(e)).toList();

  if (pairNumbers.length >= 2) {
    return Combination(
      PokerHand.twoPair,
      pairNumbers.first * 10000 + pairNumbers[1] * 100 + kickers.first,
    ); //we use 1 kicker since 4 cards are already on the table
  }
  return Combination(PokerHand.none, -1);
}

/// Pair
Combination _isPair(Map<int, int> valueCounts) {
  // Проверяем наличие пары
  for (var key in valueCounts.keys) {
    if (valueCounts[key] == 2) {
      final kickers = valueCounts.keys.where((e) => e != key).toList();
      return Combination(
        PokerHand.pair,
        key * 1000000 + kickers.first * 10000 + kickers[1] * 100 + kickers[2],
      ); //we use 3 kickers since there are only 2 cards on the table
    }
  }
  return Combination(PokerHand.none, -1);
}

/// Additional features for comparing high cards
Combination _highCard(List<Card> playerCards) {
  playerCards.sort((b, a) => a.key.compareTo(b.key));
  return Combination(
    PokerHand.highCard,
    playerCards.first.key * 100 + playerCards[1].key,
  );
}
