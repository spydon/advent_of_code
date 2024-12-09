// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(9)[0];
  var formatted = <int>[];
  for (var i = 0; i < input.length; i++) {
    final id = i.isEven ? (i / 2).round() : -1;
    formatted.addAll(List.generate(int.parse(input[i]), (_) => id));
  }
  int lastOccupied = lastIndexOf(formatted);
  for (var i = formatted.indexOf(-1);
      i < formatted.length && i < lastOccupied;
      i = formatted.indexOf(-1)) {
    if (i % 1000 == 0) {
      print(i);
    }
    formatted = formatted..swap(i, lastOccupied);
    lastOccupied = lastIndexOf(formatted);
  }

  final minusOneIndex = formatted.indexOf(-1);
  final result = formatted.sublist(0, minusOneIndex).foldIndexed(
      BigInt.zero, (i, sum, e) => sum + BigInt.from(i) * BigInt.from(e));
  print(result);
}

int lastIndexOf(List<int> s) {
  for (var i = s.length - 1; i > 0; i--) {
    if (s[i] != -1) {
      return i;
    }
  }
  return -1;
}
