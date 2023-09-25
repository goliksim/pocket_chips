part of 'winner_gpt.dart';

enum CardSuit { c, s, h, d }

Map<String, int> cardText = {
  '2': 2,
  '3': 3,
  '4': 4,
  '5': 5,
  '6': 6,
  '7': 7,
  '8': 8,
  '9': 9,
  '10': 10,
  'J': 11,
  'Q': 12,
  'K': 13,
  'A': 14,
};

Map<int, String> cardTextReversed = {
  1: 'A',
  2: '2',
  3: '3',
  4: '4',
  5: '5',
  6: '6',
  7: '7',
  8: '8',
  9: '9',
  10: '10',
  11: 'J',
  12: 'Q',
  13: 'K',
  14: 'A'
};

Map<String, CardSuit> mapSuit = {
  '♠': CardSuit.s,
  '♣': CardSuit.c,
  '♦': CardSuit.d,
  '♥': CardSuit.h
};

Map<CardSuit, String> mapSuitReversed = {
  CardSuit.s: '♠',
  CardSuit.c: '♣',
  CardSuit.d: '♦',
  CardSuit.h: '♥'
};

class Card {
  Card(this.suit, this.key);
  CardSuit suit;
  int key;

  @override
  String toString() {
    final text = '${cardTextReversed[key]}${mapSuitReversed[suit]}';
    return text;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Card &&
          runtimeType == other.runtimeType &&
          suit == other.suit &&
          key == other.key;

  @override
  int get hashCode => suit.hashCode ^ key.hashCode;
}
