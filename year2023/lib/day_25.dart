// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:dijkstra/dijkstra.dart';
import 'package:directed_graph/directed_graph.dart';
import 'package:year2023/common.dart';
import 'package:year2023/day_12.dart';

void main() {
  final input = readInput(25);
  final graph = <String, List<String>>{};
  final pairList = <List<String>>[];
  for (final line in input) {
    final split = line.split(': ');
    final key = split[0];
    final values = split[1].split(' ').toList();
    if (graph[key] == null) {
      graph[key] = values;
    } else {
      graph[key]!.addAll(values);
    }
    for (final valueKey in values) {
      if (graph[valueKey] == null) {
        graph[valueKey] = [key];
      } else {
        graph[valueKey]!.add(key);
      }
    }
  }
  final keyList = graph.keys.toList();

  final createMermaidDiagram = false;
  if (createMermaidDiagram) {
    print('flowchart TD');
  }
  final visited = [];
  for (final node in graph.entries) {
    final key = node.key;
    for (var value in node.value) {
      final visitedKey = orderKey(key, value);
      if (visited.contains(visitedKey)) {
        continue;
      }
      pairList.add([key, value]);
      visited.add(visitedKey);
      if (createMermaidDiagram) {
        print('    $key --> $value');
      }
    }
  }

  List<String> bfs(
    String node,
    Map<String, List<String>> graph,
    List<String> visited,
  ) {
    visited.add(node);
    final neighbours = graph[node]!;
    for (final n in neighbours) {
      if (!visited.contains(n)) {
        bfs(n, graph, visited);
      }
    }
    return visited;
  }

  final mostUsed = <(String, String), int>{};
  final seed = 0;
  final randomKeys = graph.keys.toList()..shuffle(Random(seed));
  final otherRandomKeys =
      (graph.keys.toList()..shuffle(Random(seed))).take(200);
  var tryAmount = 0;
  for (final node1 in randomKeys) {
    tryAmount++;
    print('Try: $tryAmount');
    for (final node2 in otherRandomKeys) {
      if (node1 == node2) {
        continue;
      }
      final path = Dijkstra.findPathFromPairsList(pairList, node1, node2);
      for (int k = 1; k < path.length; k++) {
        final edge = orderKey(path[k - 1], path[k]);
        mostUsed[edge] = (mostUsed[edge] ?? 0) + 1;
      }
    }

    mostUsed.sortByValue((a, b) => b - a);
    print(mostUsed.entries.take(3));
    final edgesToRemove = mostUsed.entries.take(3).map((e) => e.key);
    final testGraph = Map.of(graph);

    for (final edge in edgesToRemove) {
      testGraph[edge.$1]?.remove(edge.$2);
      testGraph[edge.$2]?.remove(edge.$1);
    }
    final group = bfs(keyList.first, graph, []);
    if (group.length != keyList.length) {
      final groupSize = group.length;
      final otherSize = keyList.length - group.length;
      print('RESULT: ${groupSize * otherSize}');
      break;
    }
  }
}

(String, String) orderKey(String key1, String key2) {
  final c = key1.compareTo(key2);
  return (c > 0 ? key1 : key2, c > 0 ? key2 : key1);
}

List<String>? findPath(
  String node1,
  String node2,
  Map<String, List<String>> graph,
  List<String> visited,
) {
  for (final next in graph[node1]!) {
    if (visited.contains(next)) {
      continue;
    }
    visited.add(next);
    if (next == node2) {
      return visited.toList();
    }
    final maybePath = findPath(next, node2, graph, visited);
    if (maybePath != null) {
      return maybePath;
    }
  }
  return null;
}
