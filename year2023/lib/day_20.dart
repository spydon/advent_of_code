// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:meta/meta.dart';
import 'package:year2023/common.dart';

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
  for (final m in modules.values) {
    m.init(
      modules.values
          .where((e) => e.destinations.contains(m.name))
          .map((e) => e.name)
          .toList(),
    );
  }

  final runs = 1000;
  for (var i = 0; i < runs; i++) {
    modules['broadcaster']!.run('', false);
  }
  final lowTotal = modules.values.fold(0, (sum, e) => sum + e.lowPulses) + runs;
  final highTotal = modules.values.fold(0, (sum, e) => sum + e.highPulses);
  print(lowTotal * highTotal);
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

  int lowPulses = 0;
  int highPulses = 0;

  void init(List<String> incoming) {}

  void run(String fromName, bool isHigh);

  void sendResult(bool isHigh) {
    for (var d in destinations) {
      if (isHigh) {
        highPulses++;
      } else {
        lowPulses++;
      }
      modules[d]?.run(name, isHigh);
    }
  }
}
