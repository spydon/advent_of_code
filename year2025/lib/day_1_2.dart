// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(1);
  var code = 0;
  var current = 50;
  for (final line in input) {
    final direction = line.substring(0, 1);
    final amount = int.parse(line.substring(1));
    final nextOverflow =
        direction == 'L' ? (current - amount) : (current + amount);
    final extraClicks = nextOverflow ~/ 100;
    final next = nextOverflow % 100;
    code += extraClicks.abs();
    if (next == 0 && nextOverflow < 100) {
      code++;
    } else if (current != 0 && nextOverflow.isNegative) {
      code++;
    }
    current = next;
  }
  print(code);
}
