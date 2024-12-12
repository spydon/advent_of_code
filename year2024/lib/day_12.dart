// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(12);
  final visited = <(int, int)>{};
  var sum = 0;
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      final c = input[y][x];
      final spot = (x, y);
      if (visited.contains(spot)) {
        continue;
      }
      final result = price(spot, c, input);
      sum += result.$1;
      visited.addAll(result.$2);
    }
  }
  // 1433844
  print(sum);
}

(int, Set<(int, int)>) price((int, int) start, String c, List<String> input) {
  final queue = [start];
  final visited = {start};
  var current = start;
  while (queue.isNotEmpty) {
    current = queue.removeLast();
    final north = current.stepNorth();
    final south = current.stepSouth();
    final east = current.stepEast();
    final west = current.stepWest();
    final directions = [north, south, east, west];
    final nextSpaces = directions.where(
      (d) =>
          !d.isOutsideString(input) &&
          input[d.y][d.x] == c &&
          !visited.contains(d),
    );
    queue.addAll(nextSpaces);
    visited.addAll(nextSpaces);
  }

  var perimiter = 0;
  for (final spot in visited) {
    final north = spot.stepNorth();
    final south = spot.stepSouth();
    final east = spot.stepEast();
    final west = spot.stepWest();
    final directions = [north, south, east, west];
    perimiter += directions.fold(
      0,
      (sum, s) =>
          sum + (s.isOutsideString(input) || input[s.y][s.x] != c ? 1 : 0),
    );
  }
  return (perimiter * visited.length, visited);
}
