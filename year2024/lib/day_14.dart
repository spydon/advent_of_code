// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final size = (101, 103);
  final robots = readInput(14).map(Robot.fromLine).toList();
  // 5000 too low
  robots.forEach((r) => r.step(size, steps: 5000));
  var i = 0;
  while (i < 2000) {
    final positions = robots.map((r) => r.position);
    print(i);
    for (var y = 0; y < size.y; y++) {
      for (var x = 0; x < size.x; x++) {
        stdout.write(positions.contains((x, y)) ? 'x' : '.');
      }
      stdout.writeln();
    }
    for (var r in robots) {
      r.step(size);
    }
    sleep(Duration(milliseconds: 200));
    i++;
  }
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

  void step((int, int) size, {int steps = 1}) =>
      position = (position + velocity.scale(steps)) % size;
}
