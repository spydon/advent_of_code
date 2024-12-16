// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

final visited = <(int, int), int>{};
late final List<String> map;
Node? goalNode;

void main() {
  map = readInput(16);
  (int, int)? start;
  for (int y = 0; y < map.length && start == null; y++) {
    for (int x = 0; x < map[0].length && start == null; x++) {
      if (map[y][x] == 'S') {
        start = (x, y);
      }
    }
  }

  final startNodes = [
    Node(start! + (1, 0), 1, 1),
    Node(start + (0, -1), 1001, 1001),
  ];
  findSubPaths(startNodes[0], (1, 0), (1, 0));
  findSubPaths(startNodes[1], (0, -1), (0, -1));
  print(goalNode?.totalCost);
}

Node? findSubPaths(
  Node current,
  (int, int) direction,
  (int, int) previousDirection,
) {
  final intersection =
      findNextIntersection(current, direction, previousDirection);
  if (intersection == null) {
    return null;
  }
  if (isGoal(intersection)) {
    goalNode = intersection;
    return null;
  }
  intersection.children.addAll(
    (directions.toList()..remove(direction.invert()))
        .map(
          (newDirection) => findSubPaths(intersection, newDirection, direction),
        )
        .whereNotNull(),
  );
  return intersection;
}

Node? findNextIntersection(Node previous, (int, int) d, (int, int) previousD) {
  var current = previous.p + d;
  final validTiles = ['.', 'E'];
  while (validTiles.contains(map[current.y][current.x]) &&
      sideOpenings(current, d).isEmpty) {
    current += d;
  }
  final intersection = current;
  final cost =
      previous.p.distanceTo(intersection).round() + (d != previousD ? 1000 : 0);
  final totalCost = previous.totalCost + cost;
  return isDeadEnd(intersection, d, totalCost)
      ? null
      : Node(intersection, cost, totalCost);
}

List<(int, int)> sideOpenings((int, int) p, (int, int) d) {
  final result = <(int, int)>[];
  for (final direction in directions.toList()
    ..remove(d)
    ..remove(d.invert())) {
    final testPosition = p + direction;
    if (map[testPosition.y][testPosition.x] == '.') {
      result.add(direction);
    }
  }
  return result;
}

bool isGoal(Node node) {
  return map[node.p.y][node.p.x] == 'E';
}

bool isDeadEnd((int, int) p, (int, int) d, int totalCost) {
  if (sideOpenings(p, d.invert()).isEmpty) {
    return true;
  }
  final hasLowerTotalCost = (visited[p] ?? maxInt) > totalCost;
  if (!hasLowerTotalCost) {
    return true;
  }
  // Dirty dirty side-effect.
  visited[p] = totalCost;
  return false;
}

class Node {
  Node(this.p, this.cost, this.totalCost);

  final (int, int) p;
  final int cost;
  final int totalCost;
  final children = <Node>[];

  @override
  String toString() {
    return '(Position: $p, cost: $cost, totalCost: $totalCost, children: ${children.length})';
  }
}
