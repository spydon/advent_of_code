// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(1);
  var code = 0;
  var current = 50;
  for (final line in input) {
    final direction = line.substring(0, 1);
    final amount = int.parse(line.substring(1));
    current = direction == 'L'
        ? (current - amount) % 100
        : (current + amount) % 100;
    if (current == 0) {
      code++;
    }
  }
  print(code);
}
