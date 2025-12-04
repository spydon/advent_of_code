// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(4).map((l) => l.split('')).toList();
  final accessibleRolls = <(int x, int y)>{};
  var removedRolls = 0;
  do {
    removedRolls = 0;
    for (var y = 0; y < input.length; y++) {
      for (var x = 0; x < input[y].length; x++) {
        if (!input.isRoll(x, y)) {
          continue;
        }
        var adjacentRolls = 0;
        for (final d in allDirections) {
          final position = (x + d.x, y + d.y);
          if (input.isRoll(position.$1, position.$2)) {
            adjacentRolls++;
            if (adjacentRolls > 3) {
              break;
            }
          }
        }
        if (adjacentRolls < 4) {
          accessibleRolls.add((x, y));
          removedRolls++;
          input[y][x] = '.';
        }
      }
    }
  } while (removedRolls != 0);
  print(accessibleRolls.length);
}

extension on List<List<String>> {
  bool isRoll(int x, int y) {
    if (x < 0 || y < 0 || y >= length || x >= this[y].length) {
      return false;
    }
    return this[y][x] == '@';
  }

  void printGrid(Set<(int, int)> rolls) {
    for (var y = 0; y < length; y++) {
      for (var x = 0; x < this[y].length; x++) {
        if (rolls.contains((x, y))) {
          stdout.write('X');
        } else {
          stdout.write(this[y][x]);
        }
      }
      stdout.writeln();
    }
  }
}
