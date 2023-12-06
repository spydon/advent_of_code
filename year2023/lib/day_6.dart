// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('6.txt')
      .readAsStringSync()
      .split('\n')
      .where((element) => element.isNotEmpty)
      .map((line) => line.replaceAll(RegExp(r'\s+'), ' '))
      .map((line) => line.replaceAll('Time: ', ''))
      .map((line) => line.replaceAll('Distance: ', ''))
      .map((line) => line.split(' '))
      .map((line) => line.map(int.parse).toList())
      .toList();
  final times = input[0];
  final distance = input[1];

  final margins = <int>[];
  for (var i = 0; i < times.length; i++) {
    final time = times[i];
    final record = distance[i];
    int? last;
    int margin = 0;
    var currentHold = 0;

    while ((last != null || margin == 0) && currentHold <= time) {
      last = getTime(time, record, currentHold);
      currentHold++;
      if (last != null) {
        margin++;
      }
    }
    margins.add(margin);
  }
  print(margins.fold<int>(1, (prev, e) => prev * e));
}

int? getTime(int time, int record, int hold) {
  final timeLeft = time - hold;
  return timeLeft * hold >= record ? hold : null;
}
