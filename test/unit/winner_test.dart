import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_chips/domain/models/cards/card_model.dart';
import 'package:pocket_chips/domain/winner_solver.dart';
import 'package:pocket_chips/utils/logs.dart';

Future<Map<String, dynamic>?> readJsonFromFile(String filePath) async {
  try {
    final file = File(filePath);
    final contents = await file.readAsString();
    final jsonMap = json.decode(contents);
    return jsonMap;
  } catch (e) {
    logs.writeLog('Error reading JSON file: $e');
    return null;
  }
}

Card getCardfromString(String text) {
  final split = text.split('_');
  return Card(mapSuit[split[1]]!, cardText[split[0]]!);
}

void main() async {
  final data = await readJsonFromFile('test/winner_test_data.json');
  group('Test winner solver: ', () {
    for (final testData in data!['data']) {
      test('---------${testData['name']}---------', () {
        final input = testData['input'];
        final result = testData['expected'];

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

        var (int winner, combinations) =
            WinnerSolver.determineWinner([pl1, pl2], table);

        logs.writeLog(
          'Player 1 Cards: ${pl1.map((card) => '$card').join(', ')}  Combination: ${combinations[0]}',
        );
        logs.writeLog(
          'Player 2 Cards: ${pl2.map((card) => '$card').join(', ')}  Combination: ${combinations[1]}',
        );
        logs.writeLog(
            'Table Cards: ${table.map((card) => '$card').join(', ')}');

        if (winner == 0) {
          logs.writeLog('It\'s a tie!');
        } else {
          logs.writeLog('Player $winner wins!');
        }

        expect(winner, result);
      });
    }
  });
}
