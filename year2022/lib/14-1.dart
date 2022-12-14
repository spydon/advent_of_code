import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

void main() {
  var width = 0;
  var height = 0;
  final lines = File('14-1.txt').readAsStringSync().split('\n');
  final List<Iterable<Wall>> wallLines = [];
  for (final line in lines) {
    final List<Wall> wallLine = [];
    for (final wallInput in line.split(' -> ')) {
      final numbers = wallInput.split(',').map(int.parse);
      final x = numbers.first;
      final y = numbers.last;
      width = max(x, width);
      height = max(y, height);
      wallLine.add(Wall(x, y));
    }
    wallLines.add(wallLine);
  }

  final map = List.generate(
          height + 1, (_) => List.generate(width + 1, (_) => '.').toList())
      .toList();

  void fillBetween(Wall w1, Wall w2) {
    var x = w1.x;
    var y = w1.y;
    final xDirection = (w2.x - w1.x).sign;
    final yDirection = (w2.y - w1.y).sign;
    while (x != w2.x || y != w2.y) {
      map[y][x] = Wall.symbol;
      x += xDirection;
      y += yDirection;
    }
    map[w2.y][w2.x] = Wall.symbol;
  }

  for (final line in wallLines) {
    var current = line.first;
    for (final next in line) {
      if (current == next) {
        if (line.length == 1) {
          map[current.y][current.x] = Wall.symbol;
        }
        continue;
      }
      fillBetween(current, next);
      current = next;
    }
  }

  int settled = 0;
  try {
    while (true) {
      var sand = Sand(500, 0);
      while (true) {
        if (map[sand.y + 1][sand.x] == '.') {
          sand.y += 1;
        } else if (map[sand.y + 1][sand.x - 1] == '.') {
          sand.y += 1;
          sand.x -= 1;
        } else if (map[sand.y + 1][sand.x + 1] == '.') {
          sand.y += 1;
          sand.x += 1;
        } else {
          map[sand.y][sand.x] = 'o';
          settled += 1;
          break;
        }
      }
    }
  } on RangeError {
    print(settled);
  }

  for (final row in map) {
    print(row);
  }
}

class Wall {
  Wall(this.x, this.y);
  int x, y;

  static String get symbol => '#';

  @override
  String toString() => '($x, $y)';
}

class Sand extends Wall {
  Sand(super.x, super.y);

  static String get symbol => 'o';
}
