// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input =
      readInput(10).map((l) => l.split('').map(int.parse).toList()).toList();
  final results = <int>[];
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      final startPosition = (x, y);
      if (input[y][x] == 0) {
        final result = findTrails(startPosition, input, {});
        results.add(result.length);
        print(result);
      }
    }
  }
  print(results.sum);
}

Set<(int, int)> findTrails(
  (int, int) p,
  List<List<int>> input,
  Set<(int, int)> result,
) {
  if (input[p.y][p.x] == 9) {
    result.add(p);
  }
  final currentValue = input[p.y][p.x];
  var next = p.stepNorth();
  if (!next.isOutside(input) && input[next.y][next.x] == currentValue + 1) {
    findTrails(next, input, result);
  }
  next = p.stepEast();
  if (!next.isOutside(input) && input[next.y][next.x] == currentValue + 1) {
    findTrails(next, input, result);
  }
  next = p.stepSouth();
  if (!next.isOutside(input) && input[next.y][next.x] == currentValue + 1) {
    findTrails(next, input, result);
  }
  next = p.stepWest();
  if (!next.isOutside(input) && input[next.y][next.x] == currentValue + 1) {
    findTrails(next, input, result);
  }
  return result;
}
