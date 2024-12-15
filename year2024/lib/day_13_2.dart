// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInputWithEmpty(13).splitWhere((l) => l.isEmpty);
  final machines = input.map((i) => Machine.fromInput(i));
  final result = machines.map((m) => m.run()).sum;
  print(result);
}

class Machine {
  Machine({
    required this.aMovement,
    required this.bMovement,
    required this.goal,
  });

  final (int, int) aMovement;
  final (int, int) bMovement;
  final int aPrice = 3;
  final int bPrice = 1;
  final (int, int) goal;

  factory Machine.fromInput(List<String> input) {
    (int, int) toTuple(String s, String splitChar) {
      final cleaned = s
          .split(': ')[1]
          .split(', ')
          .map((e) => int.parse(e.split(splitChar)[1]))
          .toList();
      return (cleaned[0], cleaned[1]);
    }

    return Machine(
      aMovement: toTuple(input[0], '+'),
      bMovement: toTuple(input[1], '+'),
      goal: toTuple(input[2], '=') + (10000000000000, 10000000000000),
    );
  }

  int run() {
    // Cramer's rule
    // A*a_x + B*B_x = p_x
    // A*a_y + B*b_y = p_y
    //A = (p_x*b_y - prize_y*b_x) / (a_x*b_y - a_y*b_x)
    //B = (a_x*p_y - a_y*p_x) / (a_x*b_y - a_y*b_x)
    final determinant = (aMovement.x * bMovement.y - aMovement.y * bMovement.x);
    final aPresses =
        (goal.x * bMovement.y - goal.y * bMovement.x) / determinant;
    final bPresses =
        (aMovement.x * goal.y - aMovement.y * goal.x) / determinant;
    if ((aMovement.scale(aPresses.round()) +
            bMovement.scale(bPresses.round())) ==
        goal) {
      return (aPresses * aPrice + bPresses * bPrice).round();
    } else {
      return 0;
    }
  }

  @override
  String toString() => '''
Button A: $aMovement
Button B: $bMovement
Prize: $goal
''';
}
