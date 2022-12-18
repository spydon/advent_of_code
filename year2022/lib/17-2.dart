import 'dart:io';
import 'dart:math';

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
          final staticRow = result[y];
          if (movingRow & first != 0 || staticRow & (movingRow << 4) != 0) {
            return false;
          }
          break;
        case Direction.right:
          final staticRow = result[y];
          if (movingRow & last != 0 || staticRow & (movingRow >> 4) != 0) {
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

  final startTime = DateTime.now();
  int j = 0;
  int shapeIndex = 0;
  int printIndex = 0;
  var height = BigInt.zero;
  final max = BigInt.from(1000000000000);
  //final max = BigInt.from(2022);
  for (BigInt i = BigInt.zero; i < max; i += BigInt.one) {
    if (printIndex == 100000000) {
      printIndex = 0;
      print('Passed ${i / BigInt.from(1000000000000)}');
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
    if (result.length > takeUntil + 2) {
      height += BigInt.from(result.length - takeUntil - 2);
      result = result.takeLast(takeUntil + 2);
      //result.removeRange(result.length - takeUntil - 50, result.length);
    }
  }
  //result.reversed.forEach((l) => print(l.toRadixString(16).padLeft(7, '0')));
  print(result.length);
  print(height);
  print(height + BigInt.from(result.length));
}

enum Direction {
  down(0, -1),
  left(-1, 0),
  right(1, 0);

  const Direction(this.dx, this.dy);
  final int dx;
  final int dy;
}
