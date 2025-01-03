// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:async';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:year2024/common.dart';

final List<(int, int)> grid = [];

void main() async {
  final input = readInput(20);
  late final (int, int) start;

  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      final char = input[y][x];
      if (char != '#') {
        grid.add((x, y));
      }
      if (char == 'S') {
        start = (x, y);
      }
    }
  }

  print(countCheats(start, grid));
}

int countCheats((int, int) start, List<(int, int)> grid) {
  final path = [start];
  final visited = {start};
  final toVisit = [start];

  while (toVisit.isNotEmpty) {
    final current = toVisit.removeAt(0);
    for (final direction in directions) {
      final neighbour = current + direction;
      if (!grid.contains(neighbour) || visited.contains(neighbour)) {
        continue;
      }
      toVisit.add(neighbour);
      visited.add(neighbour);
      path.add(neighbour);
    }
  }

  return calculateSum(path);
}

int calculateSum(List<(int, int)> path) {
  var sum = 0;
  for (var i = 0; i < path.length; i++) {
    for (var j = i + 100; j < path.length; j++) {
      final d = path[i].manhattanDistanceTo(path[j]);
      if (d <= 20 && j - i - d >= 100) {
        sum++;
      }
    }
  }
  return sum;
}
