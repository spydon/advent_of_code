// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(7).map((l) => l.split(': ')).toList();
  final results = input.map((l) => int.parse(l.first)).toList();
  final values =
      input.map((l) => l[1].split(' ').map(int.parse).toList()).toList();
  var sum = 0;
  for (var i = 0; i < results.length; i++) {
    sum += testLine(values[i], results[i]);
  }
  print(sum);
}

int add(int a, int b) => a + b;
int mul(int a, int b) => a * b;
int combine(int a, int b) => int.parse('$a$b');

bool test(
  List<int Function(int, int)> operators,
  List<int> values,
  int result,
) {
  var sum = values[0];
  var i = 0;
  for (final op in operators) {
    sum = op(sum, values[i + 1]);
    i++;
  }
  return result == sum;
}

int testLine(
  List<int> values,
  int result,
) {
  final permutations = pow(3, values.length - 1);
  for (var p = 0; p < permutations; p++) {
    final trinary =
        p.toRadixString(3).padLeft(values.length - 1, '0').split('');
    final operators = List.generate(
        values.length - 1,
        (i) => trinary[i] == '1'
            ? mul
            : trinary[i] == '2'
                ? combine
                : add);
    if (test(operators, values, result)) {
      return result;
    }
  }
  return 0;
}
