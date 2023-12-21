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
  final mapSize = (input[0].length, input.length);
  final positions = {((0, 0), start!)};
  final steps = 26501365;
  final history = <int>[];
  for (int i = 1; i < steps; i++) {
    final currentPositions = positions.toList();
    positions.clear();
    while (currentPositions.isNotEmpty) {
      final position = currentPositions.removeLast();
      for (final direction in directions) {
        final newPosition = position.$2 + direction;
        final potential = newPosition % mapSize;
        final inMap = position.$1 + (newPosition - potential).normalize();
        final tile = input[potential.y][potential.x];
        if (tile == '.' || tile == 'S') {
          positions.add((inMap, potential));
        }
      }
    }

    // It takes 65 steps to walk from the center to the edge, it's on an edge
    // that the solution stops. We store how many tiles we occupy at those
    // iterations to later use as parts of the polynomial function.
    if (i % input.length == steps % input.length) {
      history.add(positions.length);
    }
    if (history.length == 3) {
      break;
    }
  }

  /// [n] is the n:th time we have reached the center.
  int quadratic(int n) {
    final a0 = history[0];
    final a1 = history[1] - history[0];
    final a2 = history[2] - history[1];
    return a0 + a1 * n + (n * (n - 1) ~/ 2) * (a2 - a1);
  }

  print(quadratic(steps ~/ input.length));
}
