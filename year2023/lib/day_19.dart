// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(19);
  final machines = Map.fromEntries(
    input.takeWhile((l) => !l.startsWith('{')).map((l) {
      final m = l.replaceAll('}', '').split('{');
      return MapEntry(m[0], m[1].split(',').map(Condition.new));
    }),
  );
  final things = input.reversed
      .takeWhile((l) => l.startsWith('{'))
      .toList()
      .reversed
      .map(Thing.new);
  final startMachine = 'in';
  final accepted = <Thing>[];

  // Returns whether the machine accepted a condition
  bool machineRun(Thing thing, Iterable<Condition> conditions) {
    for (final condition in conditions) {
      final result = condition.run(thing);
      if (result == 'A') {
        accepted.add(thing);
        return true;
      } else if (result == 'R') {
        return true;
      } else if (result != null) {
        return machineRun(thing, machines[result]!);
      }
    }
    return false;
  }

  for (final thing in things) {
    print('\nStarting $thing');
    final result = machineRun(thing, machines[startMachine]!);
    if (!result) {
      accepted.add(thing);
    }
  }
  print(accepted.map((e) => e.sum).sum);
}

class Condition {
  Condition(this.statement);

  final String statement;

  String? run(Thing thing) {
    if (statement == 'A') {
      return 'A';
    } else if (statement == 'R') {
      return 'R';
    } else if (statement.contains(':')) {
      final split = statement.split(':');
      final condition = split[0];
      final pile = split[1];
      final conditionSplit = condition.split(RegExp(r'(<|>)'));
      final variable = conditionSplit[0];
      final value = int.parse(conditionSplit[1]);
      if (condition.contains('<')) {
        return thing.get(variable) < value ? pile : null;
      } else {
        return thing.get(variable) > value ? pile : null;
      }
    } else {
      return statement;
    }
  }
}

class Thing {
  Thing(String input)
      : properties = Map.fromEntries(
          input.replaceAll(RegExp(r'({|})'), '').split(',').map(
            (l) {
              final split = l.split('=');
              return MapEntry(split[0], int.parse(split[1]));
            },
          ),
        );

  int get(String variable) => properties[variable]!;
  final Map<String, int> properties;

  int get sum => properties.values.sum;

  @override
  String toString() => properties.toString();
}
