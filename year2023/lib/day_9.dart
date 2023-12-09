// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('9.txt')
      .readAsStringSync()
      .split('\n')
      .where((element) => element.isNotEmpty)
      .map((line) => line.split(' ').map((l) => int.parse(l)).toList())
      .map(
        (line) => addDiffOnLasts(diffTrace(line, [line]).toList()).first.last,
      )
      .toList()
      .sum;
  print(input);
}

List<int> nextDiff(List<int> input) {
  return [
    for (var i = 0; i < input.length - 1; i++) input[i + 1] - input[i],
  ].toList();
}

List<List<int>> diffTrace(List<int> current, List<List<int>> trace) {
  final next = nextDiff(current);
  return next.all((e) => e == 0)
      ? addSameOnLast(trace)
      : diffTrace(next, trace..add(next));
}

List<List<int>> addSameOnLast(List<List<int>> trace) {
  trace.last.add(trace.last.last);
  return trace;
}

List<List<int>> addDiffOnLasts(List<List<int>> trace) {
  final reversedTrace = trace.reversed.toList();
  for (var i = 1; i < reversedTrace.length; i++) {
    reversedTrace[i] = [
      ...reversedTrace[i],
      reversedTrace[i].last + reversedTrace[i - 1].last,
    ];
  }
  return reversedTrace.reversed.toList();
}
