// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(12);
  final visited = <(int, int)>{};
  var sum = 0;
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      final c = input[y][x];
      final spot = (x, y);
      if (visited.contains(spot)) {
        continue;
      }
      final result = price(spot, c, input);
      sum += result.$1;
      visited.addAll(result.$2);
    }
  }
  print(sum);
}

(int, Set<(int, int)>) price((int, int) start, String c, List<String> input) {
  final queue = [start];
  final area = {start};
  var current = start;
  while (queue.isNotEmpty) {
    current = queue.removeLast();
    final directions = stepDirections(current);
    final nextSpaces = directions.where(
      (d) =>
          !d.isOutsideString(input) &&
          input[d.y][d.x] == c &&
          !area.contains(d),
    );
    queue.addAll(nextSpaces);
    area.addAll(nextSpaces);
  }

  final perimeter = getPerimeter(area, input, char: c);
  final polygon = perimeterToPolygon(perimeter, area);
  final innerSides = findSidesInside(c, area, polygon, input);

  return ((innerSides + polygon.length) * area.length, area);
}

int findSidesInside(
  String char,
  Set<(int, int)> area,
  List<(int, int)> polygon,
  List<String> input,
) {
  final minX = area.minBy((_, e) => e.x)!.x;
  final minY = area.minBy((_, e) => e.y)!.y;
  final maxX = area.maxBy((_, e) => e.x)!.x;
  final maxY = area.maxBy((_, e) => e.y)!.y;
  final insides = <(int, int)>{};
  for (var y = minY; y < maxY; y++) {
    for (var x = minX; x < maxX; x++) {
      if (input[y][x] != char && isStrictlyInside((x, y), polygon)) {
        insides.add((x, y));
      }
    }
  }
  final areaMap = <Set<(int, int)>>[];

  for (final current in insides) {
    final directions = stepDirections(current);
    var added = false;
    for (final innerArea in areaMap) {
      for (final innerAreaPoint in innerArea) {
        if (directions.contains(innerAreaPoint)) {
          innerArea.add(current);
          added = true;
          break;
        }
      }
      if (added) {
        break;
      }
    }
    if (!added) {
      areaMap.add({current});
    }
  }

  for (var i = 0; i < areaMap.length; i++) {
    final outerMap = areaMap[i];
    for (var j = i + 1; j < areaMap.length; j++) {
      final innerMap = areaMap[j];
      for (final point in innerMap) {
        final directions = stepDirections(point);
        if (outerMap.any(directions.contains)) {
          outerMap.addAll(innerMap);
          innerMap.clear();
          break;
        }
      }
    }
  }

  areaMap.removeWhere((e) => e.isEmpty);

  var sides = 0;
  for (final innerArea in areaMap) {
    final perimeter = getPerimeter(innerArea, input, notChar: char);
    final polygon = perimeterToPolygon(perimeter, innerArea);
    sides += polygon.length;
  }
  return sides;
}

List<(int, int)> getPerimeter(
  Set<(int, int)> area,
  List<String> input, {
  String? char,
  String? notChar,
}) {
  assert(char != null || notChar != null);
  final perimeter = <(int, int)>[];
  for (final spot in area) {
    final directions = stepDirections(spot);
    if (directions.any((s) =>
        s.isOutsideString(input) ||
        ((char != null && input[s.y][s.x] != char) ||
            notChar != null && input[s.y][s.x] == notChar))) {
      perimeter.add(spot);
    }
  }
  return perimeter;
}

List<(int, int)> perimeterToPolygon(
  List<(int, int)> perimeter,
  Set<(int, int)> area,
) {
  if (perimeter.length == 1) {
    final spot = perimeter.first;
    final north = spot.stepNorth();
    final south = spot.stepSouth();
    final northEast = north.stepEast();
    final northWest = north.stepWest();
    final southEast = south.stepEast();
    final southWest = south.stepWest();
    return [northWest, northEast, southWest, southEast];
  }

  (int, int) directionToOutside = (0, -1);
  (int, int) outsidePosition =
      perimeter.minBy((_, p) => p.y)! + directionToOutside;

  final startPosition = outsidePosition;
  var direction = directionToOutside.turnRight();

  final polygon = <(int, int)>[];
  do {
    while (true) {
      final hitWall = perimeter.contains(outsidePosition);
      final passedWall =
          !perimeter.contains(outsidePosition - directionToOutside);
      if (hitWall) {
        polygon.add(outsidePosition - direction);
        outsidePosition -= direction;
        direction = direction.turnLeft();
        directionToOutside = directionToOutside.turnLeft();
        outsidePosition += direction;
        break;
      } else if (passedWall) {
        polygon.add(outsidePosition - direction);
        direction = direction.turnRight();
        directionToOutside = directionToOutside.turnRight();
        outsidePosition += direction;
        break;
      }
      outsidePosition += direction;
    }
  } while (outsidePosition != startPosition);
  return polygon;
}

bool isStrictlyInside((int, int) point, List<(int, int)> polygon) {
  int crossings = 0;

  for (int i = 0; i < polygon.length; i++) {
    final p1 = polygon[i];
    final p2 = polygon[(i + 1) % polygon.length];

    if ((p1.y > point.y) != (p2.y > point.y)) {
      final xIntersect =
          p1.x + (point.y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y);

      if (xIntersect > point.x) {
        crossings++;
      }
    }

    if (isPointOnSegment(point, p1, p2)) {
      return false;
    }
  }

  return crossings.isOdd;
}

bool isPointOnSegment((int, int) point, (int, int) p1, (int, int) p2) {
  return (point.x - p1.x) * (p2.y - p1.y) == (point.y - p1.y) * (p2.x - p1.x) &&
      math.min(p1.x, p2.x) <= point.x &&
      point.x <= math.max(p1.x, p2.x) &&
      math.min(p1.y, p2.y) <= point.y &&
      point.y <= math.max(p1.y, p2.y);
}

List<(int, int)> stepDirections((int, int) step) {
  final north = step.stepNorth();
  final south = step.stepSouth();
  final east = step.stepEast();
  final west = step.stepWest();
  return [north, south, east, west];
}
