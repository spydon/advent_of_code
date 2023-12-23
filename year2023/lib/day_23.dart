// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(23).map((l) => l.split('').toList()).toList();
  final startPosition = (input[0].indexOf('.'), 0);
  final endPosition = (input.last.indexOf('.'), input.length - 1);
  final paths = <List<(int, int)>>[];
  final directions = <(int, int)>[
    (0, 1),
    (0, -1),
    (1, 0),
    (-1, 0),
  ];
  final slides = ['v', '^', '>', '<'];

  void continuePath(
    (int, int) current,
    (int, int) last,
    List<(int, int)> path,
  ) {
    for (final d in directions) {
      final next = current + d;
      if (next == last || path.contains(next)) {
        continue;
      }
      if (next.x < 0 ||
          next.y < 0 ||
          next.x >= input[0].length ||
          next.y >= input.length) {
        continue;
      }
      if (next == endPosition) {
        paths.add(path.toList()..add(next));
        continue;
      }

      var isSlideStep = false;
      final tile = input.get(next);
      final slideIndex = slides.indexOf(tile);
      late (int, int) slideDirection = directions[slideIndex];
      if (slideIndex != -1) {
        if (slideDirection == d) {
          isSlideStep = true;
        } else {
          continue;
        }
      }

      if (tile != '#') {
        final nextPath = path.toList();

        if (isSlideStep) {
          final afterSlide = next + slideDirection;
          nextPath.add(next);
          nextPath.add(afterSlide);
          continuePath(afterSlide, next, nextPath);
        } else {
          continuePath(next, current, nextPath..add(next));
        }
      }
    }
  }

  continuePath(startPosition, (-1, -1), []);
  print(paths.map((p) => p.length).max);
}
