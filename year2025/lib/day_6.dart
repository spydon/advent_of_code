// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(6)
      .map(
        (l) => l.trim().split(RegExp(r'\s+')).toList(),
      )
      .toList();

  final operators = input[input.length - 1].map((e) => e.toOperator()).toList();
  var sum = 0;
  for (var i = 0; i < operators.length; i++) {
    final op = operators[i];
    var rowSum = int.parse(input[0][i]);
    for (var j = 1; j < input.length - 1; j++) {
      rowSum = op(rowSum, int.parse(input[j][i]));
    }
    sum += rowSum;
  }

  print(sum);
}

extension on String {
  int Function(int, int) toOperator() {
    switch (this) {
      case '+':
        return (a, b) => a + b;
      case '-':
        return (a, b) => a - b;
      case '*':
        return (a, b) => a * b;
      default:
        throw UnimplementedError('Operator $this is not implemented');
    }
  }
}
