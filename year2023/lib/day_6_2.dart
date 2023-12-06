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
      .map((line) => line.replaceAll(RegExp(r'\s+'), ''))
      .map((line) => line.replaceAll('Time:', ''))
      .map((line) => line.replaceAll('Distance:', ''))
      .map(int.parse)
      .toList();
  final time = input[0];
  final record = input[1];

  final inRange = possibleInRange(time, record, 0, double.maxFinite)!;
  final max = findMax(time, record, inRange, double.maxFinite) ?? inRange;
  final min = findMin(time, record, 0, inRange) ?? inRange;
  print(max - min + 1);
}

num? findMax(int time, int record, num startRange, num endRange) {
  final middle = (startRange + endRange) / 2;
  final current = getTime(time, record, middle);
  if (endRange - startRange <= 1) {
    return current;
  }
  if (current != null) {
    return findMax(time, record, middle, endRange) ?? current;
  } else {
    return findMax(time, record, startRange, middle) ?? startRange;
  }
}

num? findMin(int time, int record, num startRange, num endRange) {
  final middle = (startRange + endRange) / 2;
  final current = getTime(time, record, middle);
  if (endRange - startRange <= 1) {
    return current;
  }
  if (current != null) {
    return findMin(time, record, startRange, middle) ?? current;
  } else {
    return findMin(time, record, middle, endRange) ?? endRange;
  }
}

num? possibleInRange(int time, int record, num startRange, num endRange) {
  final middle = (startRange + endRange) / 2;
  final current = getTime(time, record, middle);
  if (current != null) {
    return current.round();
  }
  return possibleInRange(time, record, startRange, middle) ??
      possibleInRange(time, record, middle, endRange);
}

num? getTime(int time, int record, num hold) {
  final timeLeft = time - hold;
  return timeLeft * hold >= record ? hold : null;
}
