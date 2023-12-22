// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final cubes = <Cube>[];
  final input = readInput(22).mapIndexed((i, l) {
    final corners = l
        .split('~')
        .map((e) => e.split(',').map((e) => int.parse(e)).toList())
        .toList();
    return Cube(
      (corners[0][0], corners[0][1], corners[0][2]),
      (corners[1][0], corners[1][1], corners[1][2]),
      cubes,
      i,
    );
  });
  cubes.addAll(input);

  var anyMoved = true;
  while (anyMoved) {
    anyMoved = false;
    for (final cube in cubes) {
      final moveDown = cube.moveDown();
      anyMoved = anyMoved || moveDown;
    }
  }

  var removableCubes = 0;
  for (final cube in cubes) {
    final cubesWithout = (cubes.toList()..remove(cube)).map((c) => c.clone());
    var anyMoved = cubesWithout.any((c) => c.moveDown(cubesWithout));
    if (!anyMoved) {
      removableCubes++;
    }
  }
  print(removableCubes);
}

class Cube {
  Cube(this.corner1, this.corner2, this.cubes, this.id);

  (int, int, int) corner1;
  (int, int, int) corner2;
  final Iterable<Cube> cubes;
  int id;

  bool moveDown([Iterable<Cube>? replacementCubes]) {
    if (corner1.z == 1 || corner2.z == 1) {
      return false;
    }
    final down = (0, 0, -1);
    corner1 = corner1 + down;
    corner2 = corner2 + down;
    if ((replacementCubes ?? cubes).any((c) => intersects(c))) {
      corner1 = corner1 + down.invert();
      corner2 = corner2 + down.invert();
      return false;
    }
    return true;
  }

  bool intersects(Cube other) {
    if (id == other.id) {
      return false;
    }

    final xOverlap =
        (corner1.x <= other.corner2.x && corner2.x >= other.corner1.x) ||
            (other.corner1.x <= corner2.x && other.corner2.x >= corner1.x);

    final yOverlap =
        (corner1.y <= other.corner2.y && corner2.y >= other.corner1.y) ||
            (other.corner1.y <= corner2.y && other.corner2.y >= corner1.y);

    final zOverlap =
        (corner1.z <= other.corner2.z && corner2.z >= other.corner1.z) ||
            (other.corner1.z <= corner2.z && other.corner2.z >= corner1.z);

    return xOverlap && yOverlap && zOverlap;
  }

  Cube clone() => Cube(corner1, corner2, cubes, id);

  @override
  String toString() => '$corner1 ~ $corner2';
}
