// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:meta/meta.dart';
import 'package:year2023/common.dart';

int iteration = 0;
Queue<void Function()> operations = Queue();

void main() {
  final input = readInput(20);
  final modules = <String, Module>{};
  for (var line in input) {
    final split = line.split(' ');
    final id = split[0];
    final name = id.substring(1);
    final destinations = line.split(' -> ')[1].split(', ').toList();
    switch (line[0]) {
      case '%':
        modules[name] = FlipFlop(name, destinations, modules);
      case '&':
        modules[name] = Conjunction(name, destinations, modules);
      default:
        modules[id] = Broadcaster(id, destinations, modules);
    }
  }
  modules['rx'] = Conjunction('rx', [], modules);
  for (final m in modules.values) {
    m.init(
      modules.values
          .where((e) => e.destinations.contains(m.name))
          .map((e) => e.name)
          .toList(),
    );
  }
  final finalModules = (modules['cn'] as Conjunction).memory.keys;

  while (finalModules.any((e) => modules[e]!.history.isEmpty)) {
    iteration++;
    operations.add(() => modules['broadcaster']!.run('', false));
    while (operations.isNotEmpty) {
      operations.removeFirst()();
    }
  }

  final result = finalModules
      .map((e) => modules[e]!.history.toList())
      .toList()
      .flattened
      .fold(1, (sum, e) => sum * e);
  print(result);
}

class Broadcaster extends Module {
  Broadcaster(super.name, super.destinations, super.modules);

  @override
  void run(String fromName, bool isHigh) {
    sendResult(isHigh);
  }
}

class FlipFlop extends Module {
  FlipFlop(super.name, super.destinations, super.modules);

  bool state = false;

  @override
  void run(String fromName, bool isHigh) {
    if (!isHigh) {
      state = !state;
      sendResult(state);
    }
  }

  @override
  String toString() => 'FlipFlop($name)';
}

class Conjunction extends Module {
  Conjunction(super.name, super.destinations, super.modules);

  final Map<String, bool> memory = {};

  @override
  void init(List<String> incoming) {
    memory.addEntries(incoming.map((i) => MapEntry(i, false)));
  }

  @override
  void run(String fromName, bool isHigh) {
    memory[fromName] = isHigh;
    sendResult(!memory.values.all((e) => e));
  }

  @override
  String toString() => 'Conjunction($name)';
}

abstract class Module {
  Module(this.name, this.destinations, this.modules);

  final String name;
  final List<String> destinations;
  final Map<String, Module> modules;
  final List<int> history = [];

  void init(List<String> incoming) {}

  void run(String fromName, bool isHigh);

  @mustCallSuper
  void sendResult(bool isHigh) {
    if (isHigh) history.add(iteration);

    for (var d in destinations) {
      operations.add(() => modules[d]!.run(name, isHigh));
    }
  }
}
