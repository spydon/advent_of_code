// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(21).map((l) => l.split('')).toList();
  (int, int)? start;
  for (var y = 0; y < input.length && start == null; y++) {
    for (var x = 0; x < input.length && start == null; x++) {
      if (input[y][x] == 'S') {
        start = (x, y);
      }
    }
  }

  final directions = <(int, int)>[
    (0, 1),
    (0, -1),
    (1, 0),
    (-1, 0),
  ];
  final positions = {start!};
  for (int i = 0; i < 64; i++) {
    final currentPositions = positions.toList();
    positions.clear();
    while (currentPositions.isNotEmpty) {
      final position = currentPositions.removeLast();
      for (final direction in directions) {
        final potential = position + direction;
        final tile = input[potential.y][potential.x];
        if (tile == '.' || tile == 'S') {
          positions.add(potential);
        }
      }
    }
  }
  print(positions.length);
}
