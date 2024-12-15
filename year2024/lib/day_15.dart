// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(15).splitAt(50);
  print(input);
  final map = input[0].map((l) => l.split('')).toList();
  final directions = input[1].join().split('').map(fromChar).toList();
  for (final direction in directions) {
    var p = findRobot(map);
    moveThing(p, direction, map);
  }
  print(sumBoxes(map));
}

bool moveThing((int, int) p, (int, int) direction, List<List<String>> map) {
  final newP = p + direction;
  final nextItem = map[newP.y][newP.x];
  if (nextItem == '.') {
    map[newP.y][newP.x] = map[p.y][p.x];
    map[p.y][p.x] = '.';
    return true;
  } else if (nextItem == '#') {
    return false;
  } else {
    if (moveThing(newP, direction, map)) {
      map[newP.y][newP.x] = map[p.y][p.x];
      map[p.y][p.x] = '.';
      return true;
    } else {
      return false;
    }
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
      if (map[y][x] == 'O') {
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
