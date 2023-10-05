// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:pocket_chips/internal/cards/card_model.dart';
import 'package:pocket_chips/internal/cards/winner_gpt.dart';

Future<Map<String, dynamic>?> readJsonFromFile(String filePath) async {
  try {
    final file = File(filePath);
    final contents = await file.readAsString();
    final jsonMap = json.decode(contents);
    return jsonMap;
  } catch (e) {
    print('Error reading JSON file: $e');
    return null;
  }
}

Card getCardfromString(String text) {
  final split = text.split('_');
  return Card(mapSuit[split[1]]!, cardText[split[0]]!);
}

void main() async {
  final data = await readJsonFromFile('winner_test_data.json');

  for (var test in data!['data']) {
    final input = test['input'];
    final result = test['expected'];

    final pl1 = [
      getCardfromString(input['pl1'][0]),
      getCardfromString(input['pl1'][1]),
    ];

    final pl2 = [
      getCardfromString(input['pl2'][0]),
      getCardfromString(input['pl2'][1]),
    ];

    final table = [
      getCardfromString(input['tbl'][0]),
      getCardfromString(input['tbl'][1]),
      getCardfromString(input['tbl'][2]),
      getCardfromString(input['tbl'][3]),
      getCardfromString(input['tbl'][4]),
    ];

    print('-------- Test ${test['name']}---------');

    final player1Combination = detectCombination(pl1, table);
    final player2Combination = detectCombination(pl2, table);

    var (int winner, _) = determineWinner([pl1, pl2], table);

    print(
      'Player 1 Cards: ${pl1.map((card) => '$card').join(', ')}  Combination: $player1Combination',
    );
    print(
      'Player 2 Cards: ${pl2.map((card) => '$card').join(', ')}  Combination: $player2Combination',
    );
    print('Table Cards: ${table.map((card) => '$card').join(', ')}');

    if (winner == 0) {
      print('It\'s a tie!');
    } else {
      print('Player $winner wins!');
    }

    if (winner != result) throw Exception('Not correct answer');
  }

  print('All tests COMPLETE');
}
