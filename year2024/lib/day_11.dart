// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(11)[0].split(' ').map(int.parse).toList();
  var result = input;
  final iterations = 25;
  for (var i = 0; i < iterations; i++) {
    print(i);
    final nextResult = <int>[];
    for (final stone in result) {
      if (stone == 0) {
        nextResult.add(1);
      } else if (stone.toString().length.isEven) {
        final stoneString = stone.toString();
        final first = stoneString.substring(0, stoneString.length ~/ 2);
        final second = stoneString.substring(stoneString.length ~/ 2);
        nextResult.add(int.parse(first));
        nextResult.add(int.parse(second));
      } else {
        nextResult.add(stone * 2024);
      }
    }
    result = nextResult;
  }
  // 379993
  print(result.length);
}
