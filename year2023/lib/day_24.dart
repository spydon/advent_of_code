// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:vector_math/vector_math.dart';
import 'package:year2023/common.dart';

import 'line.dart';

void main() {
  final min = 200000000000000;
  final max = 400000000000000;
  final input = readInput(24).map((l) {
    final split = l.split(' @ ');
    final position = split[0].split(', ').map((e) => double.parse(e)).toList();
    final velocity = split[1].split(', ').map((e) => double.parse(e)).toList();
    return (
      (position[0], position[1]),
      (velocity[0], velocity[1]),
    );
  }).toList();
  final lines = input.map((l) => Line.fromPoints(l.$1, l.$1 + l.$2)).toList();
  var crossings = 0;
  for (var i = 0; i < lines.length - 1; i++) {
    final line1Start = input[i].$1;
    final line1Point = input[i].$1 + input[i].$2;
    for (var j = i + 1; j < lines.length; j++) {
      final line2Start = input[j].$1;
      final line2Point = input[j].$1 + input[j].$2;

      final intersection =
          intersections(line1Start, line1Point, line2Start, line2Point);
      if (intersection != null) {
        if (intersection.x >= min &&
            intersection.y >= min &&
            intersection.x <= max &&
            intersection.y <= max) {
          if (line1Start.distanceToSquared(intersection) >=
                  line1Point.distanceToSquared(intersection) &&
              line2Start.distanceToSquared(intersection) >=
                  line2Point.distanceToSquared(intersection)) {
            crossings++;
          }
        }
      }
    }
  }
  print(crossings);
}

(double, double)? intersections(
  (double, double) line1p1,
  (double, double) line1p2,
  (double, double) line2p1,
  (double, double) line2p2,
) {
  double epsilon = 1e-10; // Small epsilon value

  double dx1 = line1p2.x - line1p1.x;
  double dy1 = line1p2.y - line1p1.y;
  double dx2 = line2p2.x - line2p1.x;
  double dy2 = line2p2.y - line2p1.y;

  double det = dx1 * dy2 - dy1 * dx2;

  if ((det.abs()) < epsilon) {
    // Lines are nearly parallel, consider them as parallel
    return null;
  }

  double t =
      ((line2p1.x - line1p1.x) * dy2 - (line2p1.y - line1p1.y) * dx2) / det;

  double x = line1p1.x + t * dx1;
  double y = line1p1.y + t * dy1;

  return (x, y);
}
