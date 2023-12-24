import 'dart:math';

import 'package:year2023/common.dart';

/// An infinite line on the 2D Cartesian space, represented in the form
/// of ax + by = c.
///
/// If you just want to represent a part of a line, look into LineSegment.
class Line {
  final double a;
  final double b;
  final double c;
  final double slope;

  const Line(this.a, this.b, this.c)
      : slope = (b != 0) ? -a / b : double.infinity;

  Line.fromPoints((double, double) p1, (double, double) p2)
      : this(
          p2.y - p1.y,
          p1.x - p2.x,
          p2.y * p1.x - p1.y * p2.x,
        );

  /// Returns an empty list if there is no intersection
  /// If the lines are concurrent it returns one point in the list.
  /// If they coincide it returns an empty list as well
  //List<(double, double)> intersections(Line otherLine) {
  //  final determinant = a * otherLine.b - otherLine.a * b;
  //  if (determinant == 0) {
  //    //The lines are parallel (potentially coincides) and have no intersection
  //    return [];
  //  }
  //  return [
  //    (
  //      (otherLine.b * c - b * otherLine.c) / determinant,
  //      (a * otherLine.c - otherLine.a * c) / determinant,
  //    ),
  //  ];
  //}

  /// The angle of this line in relation to the x-axis
  double get angle => atan2(-a, b);

  @override
  String toString() {
    final ax = '${a}x';
    final by = b.isNegative ? '${b}y' : '+${b}y';
    return '$ax$by=$c';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Line &&
          runtimeType == other.runtimeType &&
          a == other.a &&
          b == other.b &&
          c == other.c;

  @override
  int get hashCode => a.hashCode ^ b.hashCode ^ c.hashCode;
}
