import 'dart:io';

import 'package:collection_ext/all.dart';
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
  final result = <List<String>>[];

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
  for (int i = 0; i < 2022; i++) {
    print(i);
    result.addAll(newRows());
    result.addAll(shapes[i % shapes.length]().reversed);
    bool settled = false;

    while (!settled) {
      final direction =
          jets[j % jets.length] == '<' ? Direction.left : Direction.right;
      j++;
      move(direction);
      settled = !move(Direction.down);

      if (settled) {
        for (int y = result.length - 1; y >= 0; y--) {
          final row = result[y];
          for (int x = 0; x < row.length; x++) {
            if (row[x] == '@') {
              result[y][x] = '#';
            }
          }
        }
      }
    }
  }
  //result.reversed.forEach(print);
  print(result.length);
}

enum Direction {
  down(0, -1),
  left(-1, 0),
  right(1, 0);

  const Direction(this.dx, this.dy);
  final int dx;
  final int dy;
}
