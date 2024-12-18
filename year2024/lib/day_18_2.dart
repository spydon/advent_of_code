// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';
import 'package:flutter/material.dart';

void main() async {
  final input = readInput(18).map((l) {
    final c = l.split(',').map(int.parse).toList();
    return Point(c[0], c[1]);
  }).toList();

  final lastBarrier = await Stream.fromIterable(
    List.generate(input.length - 1024, (i) => i + 1024),
  ).parallel<(int, Point<int>)?>(
    (i) async {
      final barriers = input.sublist(0, i);
      final result = AStar(
        rows: 71,
        columns: 71,
        start: Point(0, 0),
        end: Point(70, 70),
        barriers: barriers,
        withDiagonal: false,
      ).findThePath();

      if (result.isEmpty) {
        final firstPoint = (i, barriers[i]);
        print(firstPoint);
        return firstPoint;
      }
      return null;
    },
  ).fold<(int, Point<int>)?>(
    null,
    (best, next) {
      if (next == null) {
        return best;
      }
      if (best == null) {
        return next;
      }
      return next.$1 < best.$1 ? next : best;
    },
  );
  print(lastBarrier);
}
