import 'dart:io';

//void main() {
//  final input = File('22-1.txt').readAsStringSync().split('\n');
//  final front = input.take(50).map((l) => l.trim().substring(0, 50)).toList();
//  final right = input.take(50).map((l) => l.trim().substring(50)).toList();
//  final down = input.take(100).skip(50).map((l) => l.trim()).toList();
//  final back =
//      input.take(150).skip(100).map((l) => l.trim().substring(0, 50)).toList();
//  final left =
//      input.take(150).skip(100).map((l) => l.trim().substring(50)).toList();
//  final up = input.take(200).skip(150).map((l) => l.trim()).toList();
//
//  //  FR
//  //  D
//  // LB
//  // U
//  final map = {
//    CubeSide.front: {
//      Direction.right: {CubeSide.right: Direction.right},
//      Direction.down: {CubeSide.down: Direction.down},
//      Direction.left: {CubeSide.left: Direction.down},
//      Direction.up: {CubeSide.up: Direction.left},
//    },
//    CubeSide.right: {
//      Direction.left: {CubeSide.front: Direction.left},
//      Direction.down: {CubeSide.down: Direction.left},
//      Direction.right: {CubeSide.back: Direction.left},
//      Direction.up: {CubeSide.up: Direction.down},
//    },
//    CubeSide.down: {
//      Direction.up: {CubeSide.front: Direction.up},
//      Direction.down: {CubeSide.back: Direction.down},
//      Direction.left: {CubeSide.left: Direction.down},
//      Direction.right: {CubeSide.right: Direction.up},
//    },
//    CubeSide.back: {
//      Direction.up: {CubeSide.down: Direction.up},
//      Direction.left: {CubeSide.left: Direction.left},
//      Direction.down: {CubeSide.up: Direction.left},
//      Direction.right: {CubeSide.right: Direction.left},
//    },
//    CubeSide.left: {
//      Direction.right: {CubeSide.back: Direction.right},
//      Direction.down: {CubeSide.up: Direction.down},
//      Direction.up: {CubeSide.down: Direction.right},
//      Direction.left: {CubeSide.front: Direction.right},
//    },
//    CubeSide.up: {
//      Direction.up: {CubeSide.left: Direction.up},
//      Direction.right: {CubeSide.back: Direction.up},
//      Direction.down: {CubeSide.right: Direction.left},
//      Direction.left: {CubeSide.front: Direction.down},
//    },
//  };
//  //  FR
//  //  D
//  // LB
//  // U
//  final path = input.last.split('');
//  var direction = Direction.right;
//  var p = Position(map.first.indexWhere((c) => c == '.'), 0);
//
//  bool tryNextStep() {
//    switch (direction) {
//      case Direction.right:
//        final row = map[p.y];
//        final nextStep = row[(p.x + 1) % row.length];
//        if (nextStep == '.') {
//          p.x = (p.x + 1) % row.length;
//          return true;
//        } else if (nextStep == '#') {
//          return false;
//        } else {
//          p.x = (p.x + 1) % row.length;
//          return tryNextStep();
//        }
//      case Direction.left:
//        final row = map[p.y];
//        final nextStep = row[(p.x - 1) % row.length];
//        if (nextStep == '.') {
//          p.x = (p.x - 1) % row.length;
//          return true;
//        } else if (nextStep == '#') {
//          return false;
//        } else {
//          p.x = (p.x - 1) % row.length;
//          return tryNextStep();
//        }
//      case Direction.up:
//        final nextStep = map[(p.y - 1) % map.length][p.x];
//        if (nextStep == '.') {
//          p.y = (p.y - 1) % map.length;
//          return true;
//        } else if (nextStep == '#') {
//          return false;
//        } else {
//          p.y = (p.y - 1) % map.length;
//          return tryNextStep();
//        }
//      case Direction.down:
//        final nextStep = map[(p.y + 1) % map.length][p.x];
//        if (nextStep == '.') {
//          p.y = (p.y + 1) % map.length;
//          return true;
//        } else if (nextStep == '#') {
//          return false;
//        } else {
//          p.y = (p.y + 1) % map.length;
//          return tryNextStep();
//        }
//    }
//  }
//
//  void handleMovement(int steps) {
//    for (var i = 0; i < steps; i++) {
//      final startPosition = p.clone();
//      final couldMove = tryNextStep();
//      if (!couldMove) {
//        p = startPosition;
//        break;
//      }
//    }
//  }
//
//  var lastNumber = '';
//  for (final char in path) {
//    if (char == 'R') {
//      print('Going $lastNumber and then turning right');
//      handleMovement(int.parse(lastNumber));
//      direction = direction.turnRight();
//      lastNumber = '';
//      continue;
//    } else if (char == 'L') {
//      print('Going $lastNumber and then turning left');
//      handleMovement(int.parse(lastNumber));
//      direction = direction.turnLeft();
//      lastNumber = '';
//      continue;
//    } else {
//      lastNumber += char;
//    }
//  }
//  if (lastNumber != '') {
//    handleMovement(int.parse(lastNumber));
//    lastNumber = '';
//  }
//
//  print((p.y + 1) * 1000 + (p.x + 1) * 4 + Direction.values.indexOf(direction));
//}
//
//class Position {
//  Position(this.x, this.y);
//
//  int x;
//  int y;
//
//  Position clone() => Position(x, y);
//}
//
//enum Direction {
//  right,
//  down,
//  left,
//  up;
//
//  Direction turnRight() => values[(values.indexOf(this) + 1) % values.length];
//  Direction turnLeft() => values[(values.indexOf(this) - 1) % values.length];
//}
//
//enum CubeSide {
//  front,
//  right,
//  down,
//  back,
//  left,
//  up;
//}
