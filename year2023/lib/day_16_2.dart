// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(16).map((l) => l.split('')).toList();
  var max = 0;
  for (int x = 0; x < input[0].length; x++) {
    max = math.max(max, runFromStart((x, -1), (0, 1), input));
    max = math.max(max, runFromStart((x, input.length), (0, -1), input));
  }
  for (int y = 0; y < input.length; y++) {
    max = math.max(max, runFromStart((-1, y), (1, 0), input));
    max = math.max(max, runFromStart((input[0].length, y), (-1, 0), input));
  }
  print(max);
}

int runFromStart(
  (int, int) start,
  (int, int) direction,
  List<List<String>> input,
) {
  final result = <((int, int), (int, int))>{};
  final operations = <void Function()>[];
  followPath(start, direction, input, result, operations);
  while (operations.isNotEmpty) {
    operations.removeLast()();
  }
  final sum = result.map((e) => e.$1).toSet().length;
  print(sum);
  return sum;
}

void followPath(
  (int, int) position,
  (int, int) direction,
  List<List<String>> input,
  Set<((int, int), (int, int))> result,
  List<void Function()> operations,
) {
  final newPosition = position + direction;
  if (newPosition.x < 0 ||
      newPosition.y < 0 ||
      newPosition.x >= input[0].length ||
      newPosition.y >= input.length) {
    return;
  }

  final ground = input[newPosition.y][newPosition.x];
  if (result.contains((newPosition, direction))) {
    return;
  }
  result.add((newPosition, direction));
  //print('$ground $position + $direction = $newPosition');
  switch (ground) {
    case '.':
      return followPath(newPosition, direction, input, result, operations);
    case '/':
      final newDirection = (direction.y * -1, direction.x * -1);
      return followPath(newPosition, newDirection, input, result, operations);
    case '\\':
      final newDirection = (direction.y, direction.x);
      return followPath(newPosition, newDirection, input, result, operations);
    case '-':
      if (direction.x != 0) {
        return followPath(newPosition, direction, input, result, operations);
      } else {
        final westDirection = (-1, 0);
        final eastDirection = (1, 0);
        operations.add(
          () =>
              followPath(newPosition, westDirection, input, result, operations),
        );
        operations.add(
          () =>
              followPath(newPosition, eastDirection, input, result, operations),
        );
        return;
      }
    case '|':
      if (direction.y != 0) {
        return followPath(newPosition, direction, input, result, operations);
      } else {
        final northDirection = (0, -1);
        final southDirection = (0, 1);
        operations.add(
          () => followPath(
              newPosition, northDirection, input, result, operations),
        );
        operations.add(
          () => followPath(
              newPosition, southDirection, input, result, operations),
        );
        return;
      }
  }
}
