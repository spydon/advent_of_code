// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(7).map((l) => l.split('')).toList();
  final startPosition = (input[0].indexOf('S'), 0);
  final visited = <(int, int)>{};
  final toVisit = Queue<(int, int)>()..add(startPosition);
  while (toVisit.isNotEmpty) {
    final position = toVisit.removeFirst();
    final split = nextSplitPosition(input, position, visited);
    visited.addAll(split);
    toVisit.addAll(
      split.map((e) => [e.stepEast(), e.stepWest()]).flattenedToList,
    );
  }
  print(visited.length);
}

Set<(int, int)> nextSplitPosition(
  List<List<String>> input,
  (int, int) position,
  Set<(int, int)> visited,
) {
  var y = position.$2 + 1;
  while (y < input.length) {
    final newPosition = (position.$1, y);
    if (input[newPosition.$2][newPosition.$1] == '^') {
      return {if (!visited.contains(newPosition)) newPosition};
    }
    y++;
  }
  return {};
}
