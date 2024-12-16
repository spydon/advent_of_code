// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

final visited = <((int, int), (int, int)), int>{};
late final List<String> map;
final goalNodes = <Node>[];

void main() {
  map = readInput(16);
  (int, int)? start;
  (int, int)? end;
  for (int y = 0; y < map.length && (start == null || end == null); y++) {
    for (int x = 0; x < map[0].length && (start == null || end == null); x++) {
      if (map[y][x] == 'S') {
        start = (x, y);
      } else if (map[y][x] == 'E') {
        end = (x, y);
      }
    }
  }

  final startNodes = [
    Node(start! + (1, 0), 1, 1, null, [start]),
    Node(start + (0, -1), 1001, 1001, null, [start]),
  ];
  findSubPaths(startNodes[0], (1, 0), (1, 0));
  findSubPaths(startNodes[1], (0, -1), (0, -1));
  final bestSpots = <(int, int)>{start, end!};
  for (final goalNode in goalNodes) {
    Node? current = goalNode;
    do {
      bestSpots.addAll(current!.steps);
      current = current.parent;
    } while (current!.parent != null);
  }
  print(goalNodes.length);
  print(bestSpots.length);
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
    goalNodes.add(intersection);
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
  final steps = <(int, int)>[previous.p];
  final validTiles = ['.', 'E'];
  while (validTiles.contains(map[current.y][current.x]) &&
      sideOpenings(current, d).isEmpty) {
    steps.add(current);
    current += d;
  }
  final intersection = current;
  final cost =
      previous.p.distanceTo(intersection).round() + (d != previousD ? 1000 : 0);
  final totalCost = previous.totalCost + cost;
  return isDeadEnd(intersection, d, totalCost, previous)
      ? null
      : Node(intersection, cost, totalCost, previous, steps);
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
  return map[node.p.y][node.p.x] == 'E' && node.totalCost == 123540;
}

bool isDeadEnd((int, int) p, (int, int) d, int totalCost, Node parent) {
  if (totalCost > 123540 || sideOpenings(p, d.invert()).isEmpty) {
    return true;
  }
  final hasLowerTotalCost = (visited[(p, d)] ?? maxInt) >= totalCost;
  if (!hasLowerTotalCost) {
    return true;
  }
  // Dirty dirty side-effect.
  visited[(p, d)] = totalCost;
  Node? currentParent = parent;
  while (currentParent != null) {
    if (currentParent.p == p) {
      // Loop
      return true;
    }
    currentParent = currentParent.parent;
  }
  return false;
}

class Node {
  Node(this.p, this.cost, this.totalCost, this.parent, this.steps);

  final (int, int) p;
  final List<(int, int)> steps;
  final int cost;
  final int totalCost;
  final Node? parent;
  final children = <Node>[];

  @override
  String toString() {
    return '(Position: $p, cost: $cost, totalCost: $totalCost, children: ${children.length})';
  }
}
