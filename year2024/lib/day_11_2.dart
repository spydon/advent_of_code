// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final iterations = 75;
  final input = readInput(11)[0].split(' ').map(int.parse).toList();
  var currentStones = Map.fromEntries(input.map((s) => MapEntry(s, 1)));
  for (var i = 0; i < iterations; i++) {
    var nextStones = <int, int>{};
    for (final stone in currentStones.keys) {
      final value = currentStones[stone]!;
      if (stone == 0) {
        nextStones.bump(1, value);
      } else if (stone.toString().length.isEven) {
        final stoneString = stone.toString();
        final first = int.parse(
          stoneString.substring(0, stoneString.length ~/ 2),
        );
        final second = int.parse(
          stoneString.substring(stoneString.length ~/ 2),
        );
        nextStones.bump(first, value);
        nextStones.bump(second, value);
      } else {
        nextStones.bump(stone * 2024, value);
      }
    }
    currentStones = nextStones;
  }
  print(currentStones.values.sum);
}
