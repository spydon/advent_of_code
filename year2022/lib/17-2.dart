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

  int j = 0;
  int shapeIndex = 0;
  final max = 20000;
  int shapesInCycle = 0;
  int shapesFlyingBy = 0;

  for (var i = 0; i < max; i++) {
    if (i % 1000 == 0) {
      print('Iteration: $i');
    }

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

    if (i >= 5000) {
      final index = moving.indexWhere((l) => l != 0);
      bool inRange = true;
      if (index > 11000) {
        for (int j = index; j < shape.length; j++) {
          if (moving[j] == 0) {
            inRange = false;
          }
        }
      }
      //final loopLength = 53;
      final loopLength = 2711;
      if (inRange && index >= 10000 && index <= 10000 + loopLength - 1) {
        if (shapesInCycle == 0) {
          print('Rocks before hit cycle: $i height: ${result.length}');
        }
        shapesInCycle++;
        if (shapesInCycle == 630) {
          print('Rocks for modulo: $i height: ${result.length}');
        }
      } else if (!inRange && index < 10000 + 15) {
        shapesFlyingBy++;
        print('Shapes flying by');
      }
    }
  }
  print(result.length);
  print('Shapes in cycle: $shapesInCycle');
  print('Shapes flying by: $shapesFlyingBy');

  // Find cycles
  final bestWindow = <int>[];
  final settled = result.sublist(10000, result.length - 2000);
  var loopStart = 0;
  bool loopFound = false;
  for (int i = 20; i < settled.length / 2 && !loopFound; i++) {
    if (i % 1000 == 0) {
      print('Finding repetitions $i');
    }
    final start = settled.sublist(0, i + 1);
    final possible =
        settled.sublist(i + 1, settled.length - (settled.length - 2 * i) + 2);
    for (int i = 0; i < start.length; i++) {
      if (start[i] != possible[i]) {
        break;
      }
      if (i == start.length - 1) {
        print('Found loop!');
        loopFound = true;
        loopStart = i + 1;
        bestWindow.addAll(start);
      }
    }
  }
  print(settled.sublist(0, 300));
  print(bestWindow);
  print(bestWindow.length);
  print(loopStart);
}

enum Direction {
  down(0, -1),
  left(-1, 0),
  right(1, 0);

  const Direction(this.dx, this.dy);
  final int dx;
  final int dy;
}

//>>> ((1000000000000-6450-630)/1735)*2711+(10975-10002)+10000
