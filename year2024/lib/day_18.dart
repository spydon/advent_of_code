// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';
import 'package:flutter/material.dart';

void main() {
  final input = readInput(18).sublist(0, 1024).map((l) {
    final c = l.split(',').map(int.parse).toList();
    return Point(c[0], c[1]);
  }).toList();

  final result = AStar(
    rows: 71,
    columns: 71,
    start: Point(0, 0),
    end: Point(70, 70),
    barriers: input,
    withDiagonal: false,
  ).findThePath();

  print(result.length);
}
