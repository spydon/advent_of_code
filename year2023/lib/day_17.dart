// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(17)
      .map((l) => l.split('').map((e) => int.parse(e)).toList())
      .toList();
  final maxValue = (pow(2, 63) - 1).toInt();
  final results = List.generate(
    input.length,
    (_) => List.generate(
      input[0].length,
      (_) => (sum: maxValue, d: (0, 0)),
    ),
  );
  final directions = {(0, 1), (1, 0), (0, -1), (-1, 0)};
  results[0][0] = (
    sum: 0, // "you don't incur that block's heat loss"
    d: (0, 0),
    //dSteps: 0,
    //path: [],
  );
  final checked = <((int, int), (int, int))>{};
  final queue = Queue<((int, int), (int, int))>();
  final maxLength = 3;

  void addToQueue((int, int) start, (int, int) excludeDirection) {
    for (final direction in directions
        .difference({excludeDirection, excludeDirection * (-1, -1)})) {
      //if (checked.contains((start, direction))) {
      //  continue;
      //}
      final newStartPositions = List.generate(
        maxLength,
        (i) => (start + direction * (i + 1, i + 1), direction),
      ).where((e) =>
          e.$1.y >= 0 &&
          e.$1.x >= 0 &&
          e.$1.y < input.length &&
          e.$1.x < input[0].length);
      for (final newStartPosition in newStartPositions) {
        if (!checked.contains(newStartPosition)) {
          checked.add(newStartPosition);
          queue.add(newStartPosition);
        }
      }
    }
  }

  addToQueue((0, 0), (1, 0));
  addToQueue((0, 0), (0, 1));
  while (queue.isNotEmpty) {
    final current = queue.removeFirst();
    final position = current.$1;
    final direction = current.$2;
    addToQueue(current.$1, current.$2);
    final weight = input[position.y][position.x];
    final fromPosition = current.$1 - direction;
    final testSum = results[fromPosition.y][fromPosition.x].sum + weight;
    if (results[position.y][position.x].sum > testSum) {
      results[position.y][position.x] = (sum: testSum, d: direction);
    }
  }
  print('Queue done');
  for (var y = 0; y < input.length; y++) {
    print(results[y]
        .map((e) => (e.d, e.sum == 9223372036854775807 ? -1 : e.sum))
        .toList());
  }

  final path = <(int, int)>[];
  //var position = (0, 1);
  //while (position.x < input[0].length && position.y < input.length) {
  //  path.add(position);
  //  final direction = results[position.y][position.x].d;
  //  position += direction;
  //}
  var position = (input[0].length - 1, input.length - 1);
  while (position.x != 0 || position.y != 0) {
    path.add(position);
    final direction = results[position.y][position.x].d;
    position += direction.invert();
  }
  print(path);

  //for (var i = 0; i < 3; i++) {
  //  for (var y = 0; y < input.length; y++) {
  //    for (var x = 0; x < input[0].length; x++) {
  //      if (y == 0 && x == 0) continue;
  //      int currentMin = maxValue;
  //      var foundNext = false;
  //      late (int, int) bestD;
  //      for (final d in directions) {
  //        if (y + d.y < 0 ||
  //            x + d.x < 0 ||
  //            y + d.y >= input.length ||
  //            x + d.x >= input[0].length) {
  //          continue;
  //        }

  //        final dResult = results[y + d.y][x + d.x];
  //        if (dResult.d != d || dResult.dSteps < 3) {
  //          if (currentMin > dResult.sum) {
  //            foundNext = true;
  //            currentMin = dResult.sum;
  //            bestD = d;
  //            results[y][x] = (
  //              sum: currentMin + input[y][x],
  //              d: bestD,
  //              dSteps: bestD == dResult.d ? dResult.dSteps + 1 : 1,
  //              path: [...dResult.path, (x + d.x, y + d.y)],
  //            );
  //          }
  //        }
  //      }
  //      if (!foundNext) {
  //        //print('Stuck at $x $y');
  //      }
  //    }
  //  }
  //}

  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      if (path.contains((x, y))) {
        stdout.write('\x1B[33m${input[y][x]}\x1B[0m');
      } else {
        stdout.write(input[y][x]);
      }
    }
    stdout.writeln();
  }
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      final dir = results[y][x].d;
      if (path.contains((x, y))) {
        stdout.write('\x1B[33m${dirToChar(dir)}\x1B[0m');
      } else {
        stdout.write(dirToChar(dir));
      }
    }
    stdout.writeln();
  }
  // 1076 - Too high, 5162188
  final result = results[results.length - 1][results[0].length - 1];
  print(result.sum);
}

String dirToChar((int, int) dir) {
  switch (dir) {
    case (1, 0):
      return '>';
    case (-1, 0):
      return '<';
    case (0, -1):
      return '^';
    case (0, 1):
      return 'v';
    default:
      return 'X';
  }
}
