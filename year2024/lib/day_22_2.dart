// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';
import 'package:year2024/day_9_2.dart';

void main() {
  final input = readInput(22).map(int.parse);
  //final input = [123];
  final totals = <String, int>{};
  for (final seed in input) {
    final sequence = Queue<int>();
    var lastResult = (seed, 0);
    final buyerTotals = <String, int>{};
    for (var x = 0; x < 2000; x++) {
      final next = nextNumber(lastResult.$1);
      final lastDigit = next % 10;
      final delta = lastDigit - (lastResult.$1 % 10);
      final nextResult = (next, lastDigit);
      sequence.add(delta);
      if (sequence.length > 4) {
        sequence.removeFirst();
      }
      if (sequence.length == 4) {
        final key = sequence.join(',');
        if (!buyerTotals.containsKey(key)) {
          buyerTotals[key] = lastDigit;
        }
      }
      //print('$nextResult, $delta');
      lastResult = nextResult;
    }
    for (final entry in buyerTotals.entries) {
      final key = entry.key;
      totals[key] = (totals[key] ?? 0) + entry.value;
    }
  }
  // 16772113 - Too high, 22, 2153 -- Too high
  print(totals.values.max);
}

int nextNumber(int secret) {
  final multiplied = prune(mix(secret * 64, secret));
  final divided = prune(mix((multiplied / 32).floor(), multiplied));
  return prune(mix(divided * 2048, divided));
}

int mix(int current, int secret) {
  return current ^ secret;
}

int prune(int current) {
  return current % 16777216;
}
