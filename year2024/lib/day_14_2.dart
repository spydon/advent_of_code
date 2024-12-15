// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final size = (101, 103);
  final positions =
      readInput(14).map(Robot.fromLine).map((r) => r.step(100, size));
  final quadrants = <(int, int), int>{};
  for (final p in positions) {
    final q = quadrant(p, size);
    if (q == null) {
      continue;
    }
    quadrants[q] ??= 0;
    quadrants[q] = quadrants[q]! + 1;
  }
  positions.forEach(print);
  print(quadrants);
  print(positions);
  // 8192
  print(quadrants.values.fold<int>(1, (int sum, int e) => sum * e));

  //final t = Robot((2, 2), (3, 3));
  //final tSize = (11,7);
  //print(t.step(1, size));
  //print(quadrant(t.step(1, size), size));
}

(int, int)? quadrant((int, int) position, (int, int) size) {
  if (position.x == (size.x / 2).floor() ||
      position.y == (size.y / 2).floor()) {
    return null;
  }
  return (
    (position.x < size.x / 2) ? -1 : 1,
    (position.y < size.y / 2) ? -1 : 1
  );
}

class Robot {
  Robot(this.position, this.velocity);

  (int, int) position;
  final (int, int) velocity;

  factory Robot.fromLine(String l) {
    final parts = l.split(' ');
    final p = parts[0].replaceAll('p=', '').split(',').map(int.parse).toList();
    final v = parts[1].replaceAll('v=', '').split(',').map(int.parse).toList();
    return Robot((p[0], p[1]), (v[0], v[1]));
  }

  (int, int) step(int num, (int, int) size) =>
      (position + velocity.scale(num)) % size;
}
