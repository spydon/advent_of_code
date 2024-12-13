// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() async {
  final input = readInputWithEmpty(13).splitWhere((l) => l.isEmpty);
  final machines = input.map((i) => Machine.fromInput(i)).toList();
  //final result = machines.map((m) => m.run()).whereNotNull().sum;
  var result = 0;
  var i = 0;
  while (i < machines.length) {
    final subresults = List.generate(
      32,
      (isolateIndex) => Isolate.run<int>(() {
        if (i + isolateIndex > machines.length - 1) {
          return 0;
        }
        return machines[i + isolateIndex].run() ?? 0;
      }),
    );
    result = (await Future.wait(subresults)).sum;
    i += 32;
  }
  print(result);
}

var i = 1;

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
      //goal: toTuple(input[2], '='),
      goal: toTuple(input[2], '=') + (10000000000000, 10000000000000),
    );
  }

  int? run() {
    print('Run: $i');
    final gcd = aMovement.gcd(bMovement);
    //if (i == 3) {
    //  print('gcd of $aMovement and $bMovement is $gcd and goal is at $goal');
    //  print('goal % gcd = ${goal % gcd}');
    //}
    i++;
    final hasSolution = (goal % gcd).isZero();
    print(hasSolution);
    if (!hasSolution) {
      return null;
    }
    final bSteps = goal ~/ bMovement;
    // x * bMovement + y * aMovement = goal
    // x * bPrice + y * aPrice = total
    //return stupid(100, null);
    return stupid(bSteps);
  }

  int? stupid(int startBPresses) {
    for (var bPresses = startBPresses; bPresses >= 0; bPresses--) {
      final bCurrent = bMovement.scale(bPresses);
      final delta = goal - bCurrent;
      final reachedPrize = (delta % aMovement).isZero();
      if (reachedPrize) {
        final aPresses = delta ~/ aMovement;
        return aPresses * aPrice + bPresses * bPrice;
      }
    }
    return null;
  }

  @override
  String toString() => '''
Button A: $aMovement
Button B: $bMovement
Prize: $goal
''';
}
