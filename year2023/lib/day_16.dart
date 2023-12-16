// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(16).map((l) => l.split('')).toList();
  final (int, int) position = (-1, 0);
  final (int, int) direction = (1, 0);
  final result = <((int, int), (int, int))>{};
  final operations = <void Function()>[];
  followPath(position, direction, input, result, operations);
  while (operations.isNotEmpty) {
    operations.removeLast()();
  }
  print(result.map((e) => e.$1).toSet().length);
}

void followPath(
  (int, int) position,
  (int, int) direction,
  List<List<String>> input,
  Set<((int, int), (int, int))> result,
  List<void Function()> operations,
) {
  final newPosition = position.add(direction);
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

extension on (int, int) {
  int get x => $1;

  int get y => $2;

  (int, int) add((int, int) other) => (x + other.x, y + other.y);
}
