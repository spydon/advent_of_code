// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';
import 'package:calc/calc.dart';

void main() {
  final input = readInput(23).map((l) => l.split('-')).toList();
  final connections = <String, List<String>>{};
  for (final line in input) {
    if (connections.containsKey(line[0])) {
      connections[line[0]]!.add(line[1]);
    } else {
      connections[line[0]] = [line[1]];
    }

    if (connections.containsKey(line[1])) {
      connections[line[1]]!.add(line[0]);
    } else {
      connections[line[1]] = [line[0]];
    }
  }

  final tKeys =
      connections.where((k, _) => k.startsWith('t')).map((e) => e.key);
  final sets = tKeys
      .map((k) => connections[k]!.map((other) => {k, other}))
      .flattened
      .toList();
  for (final tKey in tKeys) {
    for (final other in connections[tKey]!) {
      for (final set in sets) {
        if (connections[other]!.containsAll(set.toSet()..remove(other))) {
          set.add(other);
        }
      }
    }
  }
  final cleanedSets = deduplicateSets(sets);
  final combinedSets = cleanedSets
      .where((s) => s.length >= 3)
      .map(
        (s) => generateCombinations(s, 3).where(
          (s2) => s2.any((e) => e.startsWith('t')),
        ),
      )
      .flattened;
  final resultSets = deduplicateSets(combinedSets.toList());
  print(resultSets.length);
}

int threeCombos(int size) {
  return (factorial(size) / (factorial(3) / factorial(size - 3))).toInt();
}

List<Set<String>> generateCombinations(Set<String> set, int length) {
  final result = <Set<String>>[];
  final setList = set.toList();

  void helper(List<String> current, int start) {
    if (current.length == length) {
      result.add(current.toSet());
      return;
    }

    for (int i = start; i < set.length; i++) {
      current.add(setList[i]);
      helper(current, i + 1);
      current.removeLast();
    }
  }

  helper([], 0);
  return result;
}

List<Set<String>> deduplicateSets(List<Set<String>> sets) {
  final cleanedSets = <Set<String>>[];
  for (final set in sets) {
    var containsSet = false;
    for (final cleanSet in cleanedSets) {
      if (setEquals(set, cleanSet)) {
        containsSet = true;
        break;
      }
    }
    if (!containsSet) {
      cleanedSets.add(set);
    }
  }
  return cleanedSets;
}
