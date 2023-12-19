// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(19);
  final machines = Map.fromEntries(
    input.takeWhile((l) => !l.startsWith('{')).map((l) {
      final m = l.replaceAll('}', '').split('{');
      return MapEntry(m[0], m[1].split(',').map(Condition.new).toList());
    }),
  );
  final startMachine = 'in';
  final rejectedRuns = <Run>[];

  void machineRun(String name, Run run, List<Condition> conditions) {
    for (var i = 0; i < conditions.length; i++) {
      final condition = conditions[i];
      if (condition.isAccepted) {
        return;
      } else if (condition.isRejected) {
        final endRun = run.copy();
        endRun.conditions.addAll(
          conditions.take(conditions.length - 1).map((c) => c.inverted()),
        );
        rejectedRuns.add(endRun);
        return;
      } else if (condition.isPointer) {
        final next = condition.next!;
        run.visited.add(next);
        if (i > 0) {
          run.conditions
              .addAll(conditions.splitAt(i - 1)[0].map((c) => c.inverted()));
        }
        return machineRun(next, run, machines[next]!);
      } else {
        // This should continue and the other should fork
        final leftRun = run.copy();
        run.conditions.add(condition.inverted());

        leftRun.conditions.add(condition);
        final next = condition.next!;
        leftRun.visited.add(next);
        if (next == 'A') {
          continue;
        } else if (next == 'R') {
          rejectedRuns.add(leftRun);
        } else {
          machineRun(next, leftRun, machines[next]!);
        }
      }
    }
  }

  machineRun(startMachine, Run([], [startMachine]), machines[startMachine]!);
  print(math.pow(4000, 4) - rejectedRuns.map((e) => e.combinations()).sum);
}

class Run {
  Run([this.conditions = const [], this.visited = const []]);

  final List<Condition> conditions;
  final List<String> visited;

  Run copy() => Run(conditions.toList(), visited.toList());

  @override
  String toString() {
    return IterableZip([visited, conditions]).toString();
  }

  int combinations() {
    final ranges = {
      'x': (1, 4000),
      'm': (1, 4000),
      'a': (1, 4000),
      's': (1, 4000),
    };
    for (final condition in conditions) {
      final v = condition.variable!;
      final min = condition.operator == '>' ? condition.value! + 1 : 1;
      final max = condition.operator == '<' ? condition.value! - 1 : 4000;
      final range = ranges[v]!;
      ranges[v] = (math.max(range.$1, min), math.min(range.$2, max));
    }
    return ranges.values
        .map((e) => e.$2 - e.$1 + 1)
        .fold(1, (sum, e) => sum * e);
  }
}

class Condition {
  Condition(String statement)
      : isRejected = statement == 'R',
        isAccepted = statement == 'A' {
    if (statement.contains(':')) {
      final split = statement.split(':');
      final condition = split[0];
      next = split[1]; // Check A & R
      final conditionSplit = condition.split(RegExp(r'(<|>)'));
      variable = conditionSplit[0];
      value = int.parse(conditionSplit[1]);
      operator = statement[1];
    } else {
      next = statement;
    }
  }

  Condition.invert(Condition other)
      : isRejected = false,
        isAccepted = false {
    next = null;
    variable = other.variable;
    operator = other.operator == '>' ? '<' : '>';
    value = other.operator == '>' ? other.value! + 1 : other.value! - 1;
    isRejected;
    isAccepted;
  }

  String? next;
  String? variable;
  String? operator;
  int? value;
  final bool isRejected;
  final bool isAccepted;

  bool get isPointer => next != null && operator == null;

  Condition inverted() => Condition.invert(this);

  @override
  String toString() {
    if (operator != null) {
      return '$variable $operator $value -> $next';
    } else {
      return '-> $next';
    }
  }
}
