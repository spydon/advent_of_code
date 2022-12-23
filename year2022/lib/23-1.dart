import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2022/common.dart';

void main() {
  final input = File('23-1.txt')
      .readAsStringSync()
      .split('\n')
      .mapIndexed(
        (x, line) => line
            .split('')
            .mapIndexed(
              (y, e) => e == '#' ? Elf(y, x) : null,
            )
            .toList(),
      )
      .toList();

  final elves = input.flattened.whereNotNull();
  Set<Position> positions() => elves.map((e) => e.position).toSet();
  Set<Position> currentPositions = positions();

  bool possiblyMove(Elf elf, Direction direction) {
    final nextPosition = elf.position + direction.delta;
    final possible = currentPositions
        .intersection(nextPosition.sidePositions(direction))
        .isEmpty;
    if (possible) {
      elf.nextPosition = nextPosition;
    }
    return possible;
  }

  bool hasGoodPosition(Elf elf) {
    final p = elf.position;
    return {
      p + const Position(1, 0),
      p + const Position(0, 1),
      p + const Position(-1, 0),
      p + const Position(0, -1),
      p + const Position(1, 1),
      p + const Position(-1, -1),
      p + const Position(1, -1),
      p + const Position(-1, 1),
    }.intersection(currentPositions).isEmpty;
  }

  void printMap() {
    final map =
        List.generate(6, (_) => List.generate(5, (_) => '.').toList()).toList();
    for (final p in currentPositions) {
      map[p.y][p.x] = '#';
    }
    map.forEach(print);
  }

  for (int i = 0; i < 10; i++) {
    print(i);
    //printMap();
    for (final elf in elves) {
      if (!hasGoodPosition(elf)) {
        for (final direction in elf.directions) {
          if (possiblyMove(elf, direction)) {
            break;
          }
        }
        elf.nextDirection();
      }
    }

    for (final elf1 in elves) {
      for (final elf2 in elves) {
        if (elf1 == elf2 ||
            elf1.nextPosition == null ||
            elf2.nextPosition == null) {
          continue;
        }
        if (elf1.nextPosition == elf2.nextPosition) {
          elf1.nextPosition = null;
          elf2.nextPosition = null;
          break;
        }
      }
    }

    for (final elf in elves) {
      elf.position = elf.nextPosition ?? elf.position;
    }
    currentPositions = positions();
  }

  int? minX;
  int? minY;
  int? maxX;
  int? maxY;
  for (final p in currentPositions) {
    minX = minX == null ? p.x : min(p.x, minX);
    minY = minY == null ? p.y : min(p.y, minY);
    maxX = maxX == null ? p.x : max(p.x, maxX);
    maxY = maxY == null ? p.y : max(p.y, maxY);
  }
  print((maxX! - minX! + 1) * (maxY! - minY! + 1) - elves.length);
}

class Elf {
  Elf(int x, int y) : position = Position(x, y);

  Position position;
  Position? nextPosition;
  final directions = Direction.values.toList();

  void nextDirection() {
    directions.addAll(directions.removeFront(1));
  }
}

class Position {
  const Position(this.x, this.y);

  final int x;
  final int y;

  Set<Position> sidePositions(Direction direction) {
    switch (direction) {
      case Direction.north:
      case Direction.south:
        return {
          this,
          this + const Position(-1, 0),
          this + const Position(1, 0)
        };
      case Direction.east:
      case Direction.west:
        return {
          this,
          this + const Position(0, -1),
          this + const Position(0, 1)
        };
    }
  }

  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  @override
  bool operator ==(Object other) =>
      other is Position && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}

enum Direction {
  north(Position(0, -1)),
  south(Position(0, 1)),
  west(Position(-1, 0)),
  east(Position(1, 0));

  const Direction(this.delta);

  final Position delta;
}
