// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInputWithEmpty(15).splitWhere((l) => l.isEmpty);
  final map = extendMap(input[0].map((l) => l.split('')).toList());
  final directions = input[1].join().split('').map(fromChar).toList();
  map.printAll();
  for (final direction in directions) {
    var p = findRobot(map);
    if (direction.x != 0) {
      moveThingHorizontally(p, direction, map);
    } else {
      moveThingVertically(p, direction, map);
    }
  }
  print(sumBoxes(map));
}

bool moveThingHorizontally(
  (int, int) p,
  (int, int) direction,
  List<List<String>> map,
) {
  final newP = p + direction;
  final nextItem = map[newP.y][newP.x];
  if (nextItem == '.') {
    map[newP.y][newP.x] = map[p.y][p.x];
    map[p.y][p.x] = '.';
    return true;
  } else if (nextItem == '#') {
    return false;
  } else {
    if (moveThingHorizontally(newP, direction, map)) {
      map[newP.y][newP.x] = map[p.y][p.x];
      map[p.y][p.x] = '.';
      return true;
    } else {
      return false;
    }
  }
}

bool moveThingVertically(
  (int, int) p,
  (int, int) direction,
  List<List<String>> map,
) {
  final newP = p + direction;
  final nextItem = map[newP.y][newP.x];
  if (nextItem == '.') {
    map[newP.y][newP.x] = map[p.y][p.x];
    map[p.y][p.x] = '.';
    return true;
  } else if (nextItem == '#') {
    return false;
  } else {
    final tree = BoxNode.fromMap(newP, direction, map);
    tree.moveRoot(direction, map);
    final couldMove = tree.canMove;
    if (couldMove) {
      // Move the robot
      map[newP.y][newP.x] = map[p.y][p.x];
      map[p.y][p.x] = '.';
    }
    return couldMove;
  }
}

(int, int) findRobot(List<List<String>> map) {
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[0].length; x++) {
      if (map[y][x] == '@') {
        return (x, y);
      }
    }
  }
  return (-1, -1);
}

int sumBoxes(List<List<String>> map) {
  var result = 0;
  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[0].length; x++) {
      if (map[y][x] == '[') {
        result += (100 * y + x);
      }
    }
  }
  return result;
}

(int, int) fromChar(String char) {
  return switch (char) {
    '^' => (0, -1),
    'v' => (0, 1),
    '>' => (1, 0),
    '<' => (-1, 0),
    _ => throw UnimplementedError(),
  };
}

List<List<String>> extendMap(List<List<String>> map) {
  final newMap = <List<String>>[];

  for (var y = 0; y < map.length; y++) {
    var line = '';
    for (var x = 0; x < map[0].length; x++) {
      final current = map[y][x];
      if (current == '@') {
        line += '@.';
      } else if (current == 'O') {
        line += '[]';
      } else {
        line += current * 2;
      }
    }
    newMap.add(line.split(''));
  }
  return newMap;
}

class BoxNode {
  BoxNode(this.p1, this.p2, this.children, this.free);

  final (int, int) p1;
  final (int, int) p2;
  final List<BoxNode> children;
  final bool? free;

  factory BoxNode.fromMap(
    (int, int) p,
    (int, int) direction,
    List<List<String>> map,
  ) {
    final p1 = map[p.y][p.x] == '[' ? p : (p.x - 1, p.y);
    final p2 = map[p.y][p.x] == '[' ? (p.x + 1, p.y) : p;

    final childrenPositions = [p1 + direction, p2 + direction]
      ..sortBy<num>((e) => e.x);
    final firstChildChar =
        map[childrenPositions.first.y][childrenPositions.first.x];
    if (firstChildChar == '[') {
      childrenPositions.removeLast();
    }
    final free = childrenPositions.all(
      (p) => map[p.y][p.x] == '.',
    );
    final hasWall = childrenPositions.any(
      (p) => map[p.y][p.x] == '#',
    );
    if (free) {
      return BoxNode(p1, p2, [], true);
    } else if (hasWall) {
      return BoxNode(p1, p2, [], false);
    }
    final children = childrenPositions
        .map(
          (p) =>
              map[p.y][p.x] == '.' ? null : BoxNode.fromMap(p, direction, map),
        )
        .whereNotNull()
        .toList();

    return BoxNode(p1, p2, children, null);
  }

  void moveRoot((int, int) direction, List<List<String>> map) {
    if (!canMove) {
      return;
    }
    final queue = Queue<BoxNode>()..add(this);
    final order = <BoxNode>[];

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      order.add(current);
      for (final child in current.children) {
        queue.add(child);
      }
    }
    for (var node in order.reversed) {
      node._move(direction, map);
    }
  }

  void _move((int, int) direction, List<List<String>> map) {
    bool isFirst = true;
    for (final p in [p1, p2]) {
      final char = isFirst ? '[' : ']';
      final newP = p + direction;
      map[newP.y][newP.x] = char;
      map[p.y][p.x] = '.';
      isFirst = false;
    }
  }

  @override
  String toString() {
    return '''
BoxNode(
  $p1, $p2,
  free: $free
  childCount: ${children.length}
  children: $children
''';
  }

  bool get canMove => free ?? children.all((c) => c.canMove);
}
