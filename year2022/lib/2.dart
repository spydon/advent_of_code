import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  //1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the
  //outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won
  final scoreMap = {
    'X': 1,
    'Y': 2,
    'Z': 3,
    'A': 1,
    'B': 2,
    'C': 3,
  };
  final loseMap = {
    'A': 'Z',
    'B': 'X',
    'C': 'Y',
  };
  final winMap = {
    'A': 'Y',
    'B': 'Z',
    'C': 'X',
  };
  final opponentMap = {
    'A': 'X',
    'B': 'Y',
    'C': 'Z',
  };
  final input = File('2.txt').readAsStringSync().trim();
  //final answer = input
  //    .split('\n')
  //    .map((l) {
  //  final c = l.split(' ');
  //  return (opponentMap[c[0]] == c[1]
  //      ? 3
  //      : (loseMap[c[0]] == c[1] ? 0 : 6)) +
  //      scoreMap[c[1]]!;
  //})
  //    .toList()
  //    .sum;
  final answer = input
      .split('\n')
      .map((l) {
        final c = l.split(' ');
        final choice = () {
          switch (c[1]) {
            case 'X':
              return loseMap[c[0]];
            case 'Y':
              return opponentMap[c[0]];
            case 'Z':
              return winMap[c[0]];
          }
        }();
        return (opponentMap[c[0]] == choice
                ? 3
                : (loseMap[c[0]] == choice ? 0 : 6)) +
            scoreMap[choice]!;
      })
      .toList()
      .sum;
  print(answer);
}
