// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(6);
  final splitIndices = input.last
      .split(RegExp(r'\+|\*'))
      .map((e) => e.length)
      .toList()
      .sublist(1);
  splitIndices[splitIndices.length - 1] = splitIndices.last + 1;

  final columns = <List<String>>[];
  for (var i = 0; i < input.length - 1; i++) {
    var line = input[i];
    var splitI = 0;
    final lineNumbers = <String>[];
    while (line.isNotEmpty && splitI < splitIndices.length) {
      if (splitI >= splitIndices.length) {
        print(i);
        print(splitI);
        print(line);
      }
      final splitIndex = splitIndices[splitI];
      late String number;
      try {
        number = line.substring(0, splitIndex);
      } catch (e) {
        break;
      } finally {
        line = line.substring(min(line.length, splitIndex + 1));
      }
      lineNumbers.add(number);
      splitI++;
    }
    columns.add(lineNumbers);
  }

  final numbers = <List<String>>[];
  for (var y = 0; y < columns.length; y++) {
    for (var x = 0; x < columns[y].length; x++) {
      final number = columns[y][x];
      for (var i = 0; i < number.length; i++) {
        if (numbers.length <= i) {
          numbers.add([]);
        }
        while (numbers[i].length <= x) {
          numbers[i].add('');
        }
        print('i: $i, x: $x, ${number[i]}');
        numbers[i][x] += number[i];
      }
    }
  }

  final operators = (input.last.split(
    RegExp(r'\s'),
  )..removeWhere((e) => e.isEmpty)).map((e) => e.toOperator()).toList();
  numbers.forEach(print);

  var sum = 0;
  for (var x = 0; x < numbers[0].length; x++) {
    final op = operators[x];
    int? columnSum;
    for (var y = 0; y < numbers.length; y++) {
      try {
        if (columnSum == null) {
          columnSum = int.parse(numbers[y][x].trim());
          continue;
        }
        columnSum = op(columnSum, int.parse(numbers[y][x].trim()));
      } catch (_) {
        continue;
      }
    }
    sum += columnSum!;
  }

  print(sum);
}

extension on String {
  int Function(int, int) toOperator() {
    switch (this) {
      case '+':
        return (a, b) => a + b;
      case '*':
        return (a, b) => a * b;
      default:
        throw UnimplementedError('Operator $this is not implemented');
    }
  }
}
