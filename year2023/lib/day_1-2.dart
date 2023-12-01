// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('1.txt')
      .readAsStringSync()
      .split('\n')
      .map(fixLine)
      .where((list) => list.isNotEmpty)
      .map(
        (numbers) => int.parse('${numbers.first}${numbers.last}'),
      )
      .sum;
  print(input);
}

List<int> fixLine(String line) {
  final numbers = {
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
  };
  final result = <int>[];
  for (var i = 0; i < line.length; i++) {
    final char = line.substring(i, i + 1);
    if (int.tryParse(char) != null) {
      result.add(int.parse(char));
      continue;
    }
    for (final number in numbers.keys) {
      if (line.substring(i).indexOf(number) == 0) {
        result.add(numbers[number]!);
      }
    }
  }
  return result;
}
