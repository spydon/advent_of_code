// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(7).map((l) => l.split('')).toList();
  final startPosition = (input[0].indexOf('S'), 0);
  final tree = Node(startPosition, null);
  final cache = <Node>{};
  final queue = Queue<Node>()..add(tree);
  while (queue.isNotEmpty) {
    final node = queue.removeLast();
    node.update(input);
    cache.add(node);
    if (node.children == null || node.children!.isEmpty) {
      bumpAncestors(node, 1);
      node.possibilities = 1;
      continue;
    }

    for (final child in node.children!) {
      final maybeCached = cache.firstWhereOrNull((n) => n == child);
      if (maybeCached != null) {
        bumpAncestors(child, maybeCached.possibilities);
      } else {
        queue.add(child);
      }
    }
  }
  print(tree.possibilities);
}

void bumpAncestors(Node node, int count) {
  var current = node;
  while (current.parent != null) {
    current.parent!.possibilities += count;
    current = current.parent!;
  }
}

class Node {
  Node(this.position, this.parent) : isRoot = parent == null;

  final Node? parent;
  final (int, int) position;
  List<Node>? children;
  int possibilities = 0;

  final bool isRoot;

  void update(List<List<String>> input) {
    var y = position.$2 + 1;
    while (y < input.length) {
      final newPosition = (position.$1, y);
      if (input[newPosition.$2][newPosition.$1] == '^') {
        final west = newPosition.stepWest();
        final east = newPosition.stepEast();
        children = [
          Node(east, this),
          Node(west, this),
        ];
        return;
      }
      y++;
    }
    children = null;
  }

  @override
  bool operator ==(Object other) {
    return other is Node && position == other.position;
  }

  @override
  int get hashCode => 10000 * position.$2 + position.$1;
}
