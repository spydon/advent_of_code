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
  final result = machines.map((m) => m.run()).nonNulls.sum;
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
      goal: toTuple(input[2], '='),
    );
  }

  int? run() {
    return stupid2();
  }

  int? stupid2() {
    int? lowestPrice;
    for (var x = 0; x <= 100; x++) {
      for (var y = 0; y <= 100; y++) {
        if (bMovement.scale(x) + aMovement.scale(y) == goal) {
          final newPrice = x * bPrice + y * aPrice;
          lowestPrice ??= newPrice;
          lowestPrice = min(lowestPrice, newPrice);
        }
      }
    }
    return lowestPrice;
  }

  @override
  String toString() => '''
Button A: $aMovement
Button B: $bMovement
Prize: $goal
''';
}
