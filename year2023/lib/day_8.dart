// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('8.txt')
      .readAsStringSync()
      .split('\n')
      .where((e) => e.isNotEmpty)
      .toList();
  final directions = input.first.split('');
  final map = Map.fromEntries(
    input.drop(1).map((line) {
      final key = line.split(' = ')[0];
      final value = line
          .split(' = ')[1]
          .replaceAll('(', '')
          .replaceAll(')', '')
          .split(', ')
          .toList();
      return MapEntry(key, value);
    }),
  );

  var last = map['AAA']!;
  int steps = 0;
  for (var i = 0; true; i = (i + 1) % directions.length) {
    steps++;
    final d = directions[i];
    final nextKey = d == 'L' ? last[0] : last[1];
    if (nextKey == 'ZZZ') {
      print(steps);
      return;
    }
    final next = map[nextKey]!;
    last = next;
  }
}
