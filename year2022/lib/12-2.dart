import 'dart:io';

import 'package:directed_graph/directed_graph.dart';

void main() {
  final input = File('12-1.txt')
      .readAsStringSync()
      .split('\n')
      .map((s) => s.split('').toList())
      .toList();
  final starts = <int>[];
  late int end;

  final length = input[0].length;
  int id(int x, int y) {
    return y * length + x;
  }

  final map = <List<int>>[];
  for (var y = 0; y < input.length; y++) {
    final line = <int>[];
    map.add(line);
    for (var x = 0; x < input[y].length; x++) {
      final letter = input[y][x];
      final int height;
      if (letter == 'S') {
        height = 1;
      } else if (letter == 'E') {
        end = id(x, y);
        height = 'z'.codeUnits[0] - 96;
      } else {
        height = letter.codeUnits[0] - 96;
      }
      line.add(height);
      if (height == 1) {
        starts.add(id(x, y));
      }
    }
  }

  final graph = DirectedGraph<int>(
    {},
    comparator: (int a, int b) => a.compareTo(b),
  );

  void maybeAdd(int current, int next, int nextPosition, Set<int> edges) {
    if (next <= current + 1) {
      edges.add(nextPosition);
    }
  }

  for (var y = 0; y < map.length; y++) {
    for (var x = 0; x < map[y].length; x++) {
      final current = map[y][x];
      final edges = <int>{};
      if (y > 0) {
        final up = map[y - 1][x];
        maybeAdd(current, up, id(x, y - 1), edges);
      }
      if (y < map.length - 1) {
        final down = map[y + 1][x];
        maybeAdd(current, down, id(x, y + 1), edges);
      }
      if (x > 0) {
        final left = map[y][x - 1];
        maybeAdd(current, left, id(x - 1, y), edges);
      }
      if (x < map[y].length - 1) {
        final right = map[y][x + 1];
        maybeAdd(current, right, id(x + 1, y), edges);
      }

      if (edges.isNotEmpty) {
        graph.addEdges(id(x, y), edges);
      }
    }
  }
  print('Starting to calculate paths');
  int? shortestLength;
  for (final start in starts) {
    final result = graph.shortestPath(start, end).length - 1;
    if ((shortestLength == null || result < shortestLength) && result != 0) {
      shortestLength = result;
    }
  }
  print(shortestLength);
}
