// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(6).map((l) => l.split('')).toList();
  late (int, int) currentPosition = findStartPosition(input);
  var direction = (0, -1);
  var hitX = 0;
  do {
    input[currentPosition.y][currentPosition.x] = 'X';
    final next = nextPosition(currentPosition, direction, input);
    if (next.$1 == null) {
      break;
    }
    if (input[next.$1!.y][next.$1!.x] == 'X') {
      hitX++;
    }
    currentPosition = next.$1!;
    direction = next.$2;
  } while (hitX < input.length * input.length);

  print(countX(input));
}

((int, int)?, (int, int)) nextPosition(
  (int, int) current,
  (int, int) direction,
  List<List<String>> input,
) {
  final nextPotential = (current.x + direction.x, current.y + direction.y);
  if (nextPotential.y < 0 ||
      nextPotential.x < 0 ||
      nextPotential.y >= input.length ||
      nextPotential.x >= input[0].length) {
    return (null, direction);
  }
  if (input[nextPotential.y][nextPotential.x] == '#') {
    return nextPosition(current, direction.turnRight(), input);
  }
  return (nextPotential, direction);
}

(int, int) findStartPosition(List<List<String>> input) {
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      if (input[y][x] == '^') {
        return (x, y);
      }
    }
  }
  return (-1, -1);
}

int countX(List<List<String>> input) {
  var count = 0;
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      if (input[y][x] == 'X') {
        count++;
      }
    }
  }
  return count;
}
