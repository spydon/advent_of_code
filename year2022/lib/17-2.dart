import 'dart:io';
import 'dart:math' as math;

import 'package:collection_ext/all.dart';
import 'package:collection/collection.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:year2022/common.dart';

void main() {
  const shapes = [
    [
      0x0011110,
    ],
    [
      0x0001000,
      0x0011100,
      0x0001000,
    ],
    [
      0x0011100,
      0x0000100,
      0x0000100,
    ],
    [
      0x0010000,
      0x0010000,
      0x0010000,
      0x0010000,
    ],
    [
      0x0011000,
      0x0011000,
    ],
  ];

  const newRows = [
    0x0000000,
    0x0000000,
    0x0000000,
  ];

  final jets = File('17-1.txt').readAsStringSync().split('');
  var result = <int>[];
  final moving = <int>[];
  const first = 0x1000000;
  const last = 0x0000001;

  bool canMove(Direction direction) {
    bool hasSeenBlock = false;
    for (int y = result.length - 1; y >= 0; y--) {
      final movingRow = moving[y];
      if (movingRow == 0) {
        if (hasSeenBlock) {
          break;
        } else {
          continue;
        }
      } else {
        hasSeenBlock = true;
      }
      switch (direction) {
        case Direction.down:
          if (y == 0 || (result[y + direction.dy] & movingRow) != 0) {
            return false;
          }
          break;
        case Direction.left:
          if (movingRow & first != 0 || result[y] & (movingRow << 4) != 0) {
            return false;
          }
          break;
        case Direction.right:
          if (movingRow & last != 0 || result[y] & (movingRow >> 4) != 0) {
            return false;
          }
          break;
      }
    }
    return true;
  }

  bool move(Direction direction) {
    final movePossible = canMove(direction);
    if (movePossible) {
      switch (direction) {
        case Direction.down:
          moving.removeAt(0);
          moving.add(0);
          break;
        default:
          for (int y = 0; y < moving.length; y++) {
            final row = moving[y];
            if (row == 0) {
              continue;
            }
            moving[y] = direction == Direction.left ? row << 4 : row >> 4;
          }
      }
    }
    return movePossible;
  }

  final states = <int, List<int>>{};
  final startTime = DateTime.now();
  int j = 0;
  int shapeIndex = 0;
  int printIndex = 0;
  var height = 0;
  final max = 1000000000000;
  //final max = 2022;
  for (var i = 0; i < max; i++) {
    if (printIndex == 10000000) {
      printIndex = 0;
      print('Passed ${i / 1000000000000}');
      print('Iteration: $i');
      final time = DateTime.now().difference(startTime);
      print('Running for: $time');
    }
    printIndex++;

    result.addAll(newRows);
    moving.clear();
    moving.addAll(List.filled(result.length, 0));
    final shape = shapes[shapeIndex];
    shapeIndex = (shapeIndex + 1) % shapes.length;
    result.addAll(List.filled(shape.length, 0));
    moving.addAll(shape);

    bool settled = false;
    while (!settled) {
      //if (shapeIndex - 1 == j) {
      //  //print('\nAFTER: $i\n');
      //  final state = result.toList(growable: false);
      //  final matching = states.where((k, v) =>
      //      v.whereIndexed((i, p1) => p1 == state[i]).length == state.length);
      //  if (matching.isNotEmpty) {
      //    print(matching);
      //  }

      //  states[i];
      //}
      final direction =
          jets[j % jets.length] == '<' ? Direction.left : Direction.right;
      j = (j + 1) % jets.length;
      move(direction);
      settled = !move(Direction.down);
    }

    for (int i = 0; i < result.length; i++) {
      result[i] = result[i] | moving[i];
    }

    result.removeWhere((l) => l == 0);

    var covered = 0x0;
    int takeUntil = 0;
    for (takeUntil; takeUntil < result.length; takeUntil++) {
      covered |= result[result.length - takeUntil - 1];
      if (covered == 0x1111111) {
        break;
      }
    }
    if (covered != 0x1111111) {
      continue;
    }
    if (result.length > takeUntil + 10) {
      height += (result.length - takeUntil - 10);
      result = result.takeLast(takeUntil + 10);
      //result.removeRange(0, result.length - takeUntil - 10);
    }
  }
  print(result.length);
  print(height);
  print(height + result.length);
}

enum Direction {
  down(0, -1),
  left(-1, 0),
  right(1, 0);

  const Direction(this.dx, this.dy);
  final int dx;
  final int dy;
}
