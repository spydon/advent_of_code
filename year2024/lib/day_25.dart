// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInputWithEmpty(25).splitWhere((l) => l.isEmpty);
  final keys = <List<int>>[];
  final locks = <List<int>>[];
  for (final block in input) {
    final values = List.generate(block.first.length, (_) => 0);
    for (var y = 0; y < block.length; y++) {
      for (var x = 0; x < block[0].length; x++) {
        values[x] += block[y][x] == '#' ? 1 : 0;
      }
    }
    if (block.first == '#' * block.first.length) {
      locks.add(values);
    } else {
      keys.add(values);
    }
  }

  var sum = 0;
  for (final key in keys) {
    for (final lock in locks) {
      if (fits(key, lock)) {
        sum++;
      }
    }
  }

  print(sum);
}

bool fits(List<int> key, List<int> lock) {
  for (var y = 0; y < key.length; y++) {
    if (key[y] + lock[y] > 7) {
      return false;
    }
  }
  return true;
}
