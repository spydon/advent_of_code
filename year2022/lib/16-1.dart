import 'dart:collection';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:directed_graph/directed_graph.dart';

void main() {
  final input = File('16-1.txt')
      .readAsStringSync()
      .replaceAll('Valve ', '')
      .replaceAll('has flow rate=', '')
      .replaceAll('; tunnels lead to valves', '')
      .replaceAll('; tunnel leads to valve', '')
      .replaceAll(',', '')
      .split('\n')
      .map((s) => s.split(' ').toList())
      .map((l) => MapEntry(l[0], Valve(l[0], int.parse(l[1]), l.sublist(2))));

  final map = Map.fromEntries(input);
  map.forEach(
    (k, v) => v.edges.addAll(v.out.map((e) => map[e]!)),
  );

  final graphInput = map.map(
    (k, v) => MapEntry<Valve, Set<Valve>>(map[k]!, map[k]!.edges),
  );
  final bestValves = Queue<Valve>.from(
      graphInput.keys.sorted((v1, v2) => v2.flow.compareTo(v1.flow))
        ..removeWhere((v) => v.flow == 0));

  final weightedGraphInput = graphInput.map(
    (k, v) => MapEntry(
      k,
      Map.fromEntries(k.edges.map((v) => MapEntry(v, v.flow))),
    ),
  );
  final graph = WeightedDirectedGraph<Valve, int>(
    weightedGraphInput,
    zero: 0,
    summation: (a, b) => a + b,
    //comparator: (Valve a, Valve b) => a.id.compareTo(b.id),
  );

  int total = 0;
  int currentRelease = 0;
  Valve current = map['AA']!;

  int i = 0;
  while (i < 30) {
    MapEntry<List<Valve>, int>? best;
    List<Valve> via = [];
    while (bestValves.isNotEmpty) {
      final target = bestValves.removeFirst();
      List<List<Valve>> paths = graph.paths(current, target);
      for (final currentPath in paths) {
        List<Valve> currentVia = [];
        int addedFlow = 0;
        int flowSum = 0;
        for (int x = currentPath.length - 1; x >= 0; x--) {
          final valve = currentPath[x];
          final value = valve.flow / (30 - (i + x + 1));
          if (currentRelease + addedFlow <= value) {
            flowSum += valve.flow * (x + currentVia.length);
            addedFlow += valve.flow;
            currentVia.add(valve);
          }
        }

        int timeSteps = currentPath.length + currentVia.length + 1;
        double flowSumPerStep = flowSum / timeSteps;
        if (flowSumPerStep > (best?.value ?? 0) / timeSteps) {
          best = MapEntry(currentPath, flowSum);
          via.clear();
          via.addAll(currentVia);
        }
      }
    }

    if (best != null) {
      final timeStepsForward = best.key.length + via.length + 1;
      total += currentRelease * timeStepsForward;
      current = best.key.last;
      print('$via $current');
      currentRelease += current.flow;
      bestValves.remove(current);
      via.forEach((v) => bestValves.remove(v));
      total += best.value;
      i += best.key.length + via.length;
    } else {
      i++;
      total += currentRelease;
    }
  }

  print(total);
}

class Valve {
  Valve(this.id, this.flow, this.out);

  final String id;
  final int flow;
  final List<String> out;
  final Set<Valve> edges = {};

  @override
  String toString() => '$id $flow $out';
}
