import 'dart:io';
import 'dart:math';

import 'package:collection_ext/all.dart';
import 'package:collection/collection.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:year2022/common.dart';

void main() {
  final shapes = [
    () => [
          ['.', '.', '@', '@', '@', '@', '.'],
        ],
    () => [
          ['.', '.', '.', '@', '.', '.', '.'],
          ['.', '.', '@', '@', '@', '.', '.'],
          ['.', '.', '.', '@', '.', '.', '.']
        ],
    () => [
          ['.', '.', '.', '.', '@', '.', '.'],
          ['.', '.', '.', '.', '@', '.', '.'],
          ['.', '.', '@', '@', '@', '.', '.']
        ],
    () => [
          ['.', '.', '@', '.', '.', '.', '.'],
          ['.', '.', '@', '.', '.', '.', '.'],
          ['.', '.', '@', '.', '.', '.', '.'],
          ['.', '.', '@', '.', '.', '.', '.']
        ],
    () => [
          ['.', '.', '@', '@', '.', '.', '.'],
          ['.', '.', '@', '@', '.', '.', '.'],
        ],
  ];

  List<List<String>> newRows() => [
        ['.', '.', '.', '.', '.', '.', '.'],
        ['.', '.', '.', '.', '.', '.', '.'],
        ['.', '.', '.', '.', '.', '.', '.'],
      ];

  final jets = File('17-1.txt').readAsStringSync().split('');
  var result = <List<String>>[];

  bool canMove(Direction direction) {
    for (int y = result.length - 1; y >= 0; y--) {
      final row = result[y];
      for (int x = 0; x < row.length; x++) {
        if (row[x] == '@') {
          switch (direction) {
            case Direction.down:
              if (y == 0 || result[y + direction.dy][x] == '#') {
                return false;
              }
              break;
            case Direction.left:
              if (x == 0 || row[x + direction.dx] == '#') {
                return false;
              }
              break;
            case Direction.right:
              if (x == row.length - 1 || row[x + direction.dx] == '#') {
                return false;
              }
              break;
          }
        }
      }
    }
    return true;
  }

  bool move(Direction direction) {
    final movePossible = canMove(direction);
    if (movePossible) {
      for (int y = 0; y < result.length; y++) {
        final row = result[y];
        bool reachedEnd = false;
        int x = direction == Direction.right ? row.length - 1 : 0;
        while (!reachedEnd) {
          if (row[x] == '@') {
            switch (direction) {
              case Direction.down:
                row[x] = '.';
                result[y - 1][x] = '@';
                break;
              default:
                row[x] = '.';
                row[x + direction.dx] = '@';
                break;
            }
          }
          reachedEnd =
              direction == Direction.right ? x == 0 : x == row.length - 1;
          x += direction.dx * -1;
          x += direction.dx == 0 ? 1 : 0;
        }
      }
    }
    return movePossible;
  }

  int j = 0;
  final shapeLength = BigInt.from(shapes.length);
  var height = BigInt.zero;
  for (BigInt i = BigInt.zero;
      i < BigInt.from(1000000000000);
      i += BigInt.one) {
    if (i % BigInt.from(1000000000) == BigInt.zero) {
      print('Passed ${i / BigInt.from(1000000000000)}');
      print('Iteration: $i');
    }
    result.addAll(newRows());
    result.addAll(shapes[(i % shapeLength).toInt()]().reversed);
    bool settled = false;

    while (!settled) {
      final direction =
          jets[j % jets.length] == '<' ? Direction.left : Direction.right;
      j = (j + 1) % jets.length;
      move(direction);
      settled = !move(Direction.down);
    }

    for (int y = result.length - 1; y >= 0; y--) {
      final row = result[y];
      for (int x = 0; x < row.length; x++) {
        if (row[x] == '@') {
          result[y][x] = '#';
        }
      }
    }

    result.removeWhere((l) => l.all((c) => c == '.'));

    final covered = List.generate(7, (_) => false);
    int takeUntil = 0;
    for (takeUntil; takeUntil < result.length; takeUntil++) {
      int j = 0;
      for (final char in result[result.length - takeUntil - 1]) {
        if (char == '#') {
          covered[j] = true;
        }
        j++;
      }
      if (covered.all((c) => c)) {
        break;
      }
    }
    if (covered.any((c) => c == false)) {
      continue;
    }
    if (result.length > takeUntil + 50) {
      height += BigInt.from(result.length - takeUntil - 50);
      result = result.takeLast(takeUntil + 50);
    }
  }
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
