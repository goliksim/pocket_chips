
import 'dart:math';

List<String> cardText = ["2","3","4","5","6","7","8","9","10","J","Q","K","A"];
List<Card> table = [];


class Card{
  Card(this.suit, this.key);
  String suit;
  int key;
}


//List find

List findHighCard(player){
  int playerCardsRate = player.map((e)=> e.key).reduce((a, b) => a + b);
  print(playerCardsRate);
  List<int> tableCards3max = table.map((e)=> e.key).toList();
  tableCards3max.sort();
  int tableMaxRate = tableCards3max.sublist(2,5).reduce((a, b) => a + b);
  print(tableMaxRate);
  return [0, playerCardsRate + tableMaxRate, 'High card'];
}

List findPair(player){
  List allCards = player + table;
  List notPair = [];
  List<int> pair = [0];
  allCards.forEach((u){
    if (notPair.contains(u.key)) pair.add(u.key);
    else notPair.add(u.key);
  });
  int element = 0;
  int rate = 0;
  int kicker = 0;
  element += pair.reduce(max); //подразумевается, что пара одна
  print(element);
  if (element!=0) {
    kicker = player.map((e)=> e.key).toList().lastWhere((e) => e!=rate);
    rate += element*20 + kicker;
  }

  return [1, rate, 'Pair on $element, kicker $kicker'];
}

List  calculatePlayerRate(player){
  List tmp = [];
  //tmp = findHighCard(player);

  //returns type, rate, message
  tmp = findPair(player);

  return tmp;
}


void main() {
  List<Card> playerOne = [Card('p',4),Card('p',5)];
  List<Card> playerTwo = [Card('c',4),Card('c',4)];
  table = [Card('c',4),Card('c',5),Card('c',6),Card('c',8),Card('c',9)];

  playerOne.sort((a,b) => a.key.compareTo(b.key));
  playerTwo.sort((a,b) => a.key.compareTo(b.key));

  print(findHighCard(playerOne));
  print(findHighCard(playerTwo));
  //int playerOneRate = calculatePlayerRate(playerOne)
  //int playerTwoRate = calculatePlayerRate(playerTwo)
}