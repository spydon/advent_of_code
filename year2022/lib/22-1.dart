import 'dart:io';

import 'package:collection_ext/all.dart';

void main() {
  final input = File('22-1.txt').readAsStringSync();
  final splitAt = input.lastIndexOf('.');
  final map = input
      .substring(0, splitAt + 1)
      .split('\n')
      .map((line) => line.padRight(150, ' ').split('').toList(growable: false))
      .toList();
  final path = input.substring(splitAt + 3).split('');
  var direction = Direction.right;
  var p = Position(map.first.indexWhere((c) => c == '.'), 0);

  bool tryNextStep() {
    switch (direction) {
      case Direction.right:
        final row = map[p.y];
        final nextStep = row[(p.x + 1) % row.length];
        if (nextStep == '.') {
          p.x = (p.x + 1) % row.length;
          return true;
        } else if (nextStep == '#') {
          return false;
        } else {
          p.x = (p.x + 1) % row.length;
          return tryNextStep();
        }
      case Direction.left:
        final row = map[p.y];
        final nextStep = row[(p.x - 1) % row.length];
        if (nextStep == '.') {
          p.x = (p.x - 1) % row.length;
          return true;
        } else if (nextStep == '#') {
          return false;
        } else {
          p.x = (p.x - 1) % row.length;
          return tryNextStep();
        }
      case Direction.up:
        final nextStep = map[(p.y - 1) % map.length][p.x];
        if (nextStep == '.') {
          p.y = (p.y - 1) % map.length;
          return true;
        } else if (nextStep == '#') {
          return false;
        } else {
          p.y = (p.y - 1) % map.length;
          return tryNextStep();
        }
      case Direction.down:
        final nextStep = map[(p.y + 1) % map.length][p.x];
        if (nextStep == '.') {
          p.y = (p.y + 1) % map.length;
          return true;
        } else if (nextStep == '#') {
          return false;
        } else {
          p.y = (p.y + 1) % map.length;
          return tryNextStep();
        }
    }
  }

  void handleMovement(int steps) {
    for (var i = 0; i < steps; i++) {
      final startPosition = p.clone();
      final couldMove = tryNextStep();
      if (!couldMove) {
        p = startPosition;
        break;
      }
    }
  }

  var lastNumber = '';
  for (final char in path) {
    if (char == 'R') {
      print('Going $lastNumber and then turning right');
      handleMovement(int.parse(lastNumber));
      direction = direction.turnRight();
      lastNumber = '';
      continue;
    } else if (char == 'L') {
      print('Going $lastNumber and then turning left');
      handleMovement(int.parse(lastNumber));
      direction = direction.turnLeft();
      lastNumber = '';
      continue;
    } else {
      lastNumber += char;
    }
  }
  if (lastNumber != '') {
    handleMovement(int.parse(lastNumber));
    lastNumber = '';
  }

  print((p.y + 1) * 1000 + (p.x + 1) * 4 + Direction.values.indexOf(direction));
}

class Position {
  Position(this.x, this.y);

  int x;
  int y;

  Position clone() => Position(x, y);
}

enum Direction {
  right,
  down,
  left,
  up;

  Direction turnRight() => values[(values.indexOf(this) + 1) % values.length];
  Direction turnLeft() => values[(values.indexOf(this) - 1) % values.length];
}
