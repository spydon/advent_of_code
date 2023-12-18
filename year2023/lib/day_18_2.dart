// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(18).map((l) {
    final e = l
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('#', '')
        .split(' ')[2];
    final steps = int.parse(e.substring(0, 5), radix: 16);
    final direction = int.parse(e.substring(5));
    return (direction, steps);
  }).toList();
  final directions = {
    0: Vector2(1, 0),
    1: Vector2(0, 1),
    2: Vector2(-1, 0),
    3: Vector2(0, -1),
  };
  final position = Vector2.zero();
  final points = <Vector2>[position];
  var circumference = 0;
  for (final line in input) {
    position.add(directions[line.$1]! * line.$2.toDouble());
    points.add(position.clone());
    circumference += line.$2;
  }

  // Shoe-lace algorithm
  final matrices = <Matrix2>[];
  for (var i = 1; i <= points.length; i++) {
    final p1 = points[i - 1];
    final p2 = points[i % points.length];
    matrices.add(Matrix2.columns(p1, p2));
  }
  final determinants = matrices.map((m) => m.determinant());

  print(determinants.sum / 2 + circumference / 2 + 1);
}
