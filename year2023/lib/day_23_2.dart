// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(23).map((l) => l.split('').toList()).toList();
  final startPosition = (input[0].indexOf('.'), 0);
  final endPosition = (input.last.indexOf('.'), input.length - 1);
  final operations = <void Function()>[];
  final paths = <int>[];
  final directions = <(int, int)>[
    (0, 1),
    (0, -1),
    (1, 0),
    (-1, 0),
  ];

  final intersections = {startPosition, endPosition};
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      final tile = (x, y);
      final current = input.get(tile);
      if (current == '#') {
        continue;
      }
      var connections = 0;
      for (final d in directions) {
        final next = (x, y) + d;

        if (next.x < 0 ||
            next.y < 0 ||
            next.x >= input[0].length ||
            next.y >= input.length) {
          continue;
        }
        if (input.get(next) != '#') {
          connections++;
        }
      }
      if (connections >= 3) {
        intersections.add((x, y));
      }
    }
  }
  final graph = <(int, int), Map<(int, int), int>>{};

  for (final intersection in intersections) {
    graph[intersection] = {};
  }

  final graphOperations = <void Function()>[];

  void buildGraph(
    (int, int) current,
    (int, int) last,
    (int, int) from,
    List<(int, int)> path,
  ) {
    final nextOperations = <void Function()>[];
    var hasContinued = false;
    for (final d in directions) {
      final next = current + d;
      if (next == from || next == last || path.contains(next)) {
        continue;
      }
      if (next.x < 0 ||
          next.y < 0 ||
          next.x >= input[0].length ||
          next.y >= input.length) {
        continue;
      }

      if (intersections.contains(next)) {
        final newPath = path.toList()..add(next);
        final previousResult = graph[from]![next];
        if ((previousResult ?? 0) < newPath.length) {
          graph[from]![next] = newPath.length;
        }
        continue;
      }

      final tile = input.get(next);

      if (tile != '#') {
        final nextPath = hasContinued ? path.toList() : path;
        nextOperations.add(
          () => buildGraph(next, current, from, nextPath..add(next)),
        );
        hasContinued = true;
      }
    }
    graphOperations.addAll(nextOperations.reversed);
  }

  for (final intersection in intersections) {
    if (intersection != endPosition) {
      buildGraph(intersection, (-1, -1), intersection, []);
      while (graphOperations.isNotEmpty) {
        graphOperations.removeLast()();
      }
    }
  }
  graph.forEach((key, value) {
    print('$key - $value');
  });

  void continuePath(
    (int, int) current,
    (int, int) last,
    List<(int, int)> path,
    int currentLength,
  ) {
    final nextOperations = <void Function()>[];
    var hasContinued = false;
    for (final next in graph[current]!.keys) {
      if (next == last || path.contains(next)) {
        continue;
      }

      final nextLength = currentLength + graph[current]![next]!;
      if (next == endPosition) {
        paths.add(nextLength);
        if (nextLength > 6200) {
          print(nextLength);
        }
        continue;
      }

      final nextPath = hasContinued ? path.toList() : path;
      nextOperations.add(
        () => continuePath(
          next,
          current,
          nextPath..add(next),
          nextLength,
        ),
      );
      hasContinued = true;
    }
    operations.addAll(nextOperations.reversed);
  }

  operations.add(() => continuePath(startPosition, (0, 0), [], 0));
  while (operations.isNotEmpty) {
    operations.removeLast()();
  }
  print(paths.max);
}
