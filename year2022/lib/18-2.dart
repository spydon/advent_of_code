import 'dart:io';

import 'package:collection_ext/all.dart';
import 'package:year2022/common.dart';

void main() {
  final input = File('18-1.txt').readAsStringSync().split('\n').map((l) {
    final numbers =
        l.split(',').map((i) => int.parse(i)).toList(growable: false);
    return Cube(numbers[0], numbers[1], numbers[2]);
  }).toList(growable: false);

  var sides = 0;
  final cubes = <Cube>{};
  for (final cube in input) {
    sides += 6;
    for (final other in cubes) {
      for (int i = 0; i < 6; i++) {
        if (cube.fromI(i) == other.fromI(i) + (i >= 3 ? -1 : 1) &&
            cube.fromI(i + 1) == other.fromI(i + 1) &&
            cube.fromI(i + 2) == other.fromI(i + 2)) {
          sides -= 2;
        }
      }
    }
    cubes.add(cube);
  }

  bool isTrappedAlone(Cube cube) {
    int sidesCovered = 0;
    for (final other in cubes) {
      for (int i = 0; i < 6; i++) {
        if (cube.fromI(i) == other.fromI(i) + (i >= 3 ? -1 : 1) &&
            cube.fromI(i + 1) == other.fromI(i + 1) &&
            cube.fromI(i + 2) == other.fromI(i + 2)) {
          sidesCovered += 1;
        }
      }
    }
    return sidesCovered == 6;
  }

  final exterior = <Cube>{};
  final visitedEmpty = <Cube>{};

  Set<Cube> expandAtCube(Cube cube) {
    final expandCubes = <Cube>{};
    bool isValid(Cube testCube) =>
        !cubes.contains(testCube) &&
        !expandCubes.contains(testCube) &&
        !visitedEmpty.contains(testCube);

    final mods = [-1, 1];
    for (final i in mods) {
      final testCube = Cube(cube.x + i, cube.y, cube.z);
      if (isValid(testCube)) {
        expandCubes.add(testCube);
      }
    }
    for (final i in mods) {
      final testCube = Cube(cube.x, cube.y + i, cube.z);
      if (isValid(testCube)) {
        expandCubes.add(testCube);
      }
    }
    for (final i in mods) {
      final testCube = Cube(cube.x, cube.y, cube.z + i);
      if (isValid(testCube)) {
        expandCubes.add(testCube);
      }
    }
    return expandCubes;
  }

  Set<Cube> cubesAround(Cube cube) {
    final neighbourCubes = <Cube>{};
    bool isValid(Cube testCube) => cubes.contains(testCube);

    final mods = [-1, 1];
    for (final i in mods) {
      final testCube = Cube(cube.x + i, cube.y, cube.z);
      if (isValid(testCube)) {
        neighbourCubes.add(testCube);
      }
    }
    for (final i in mods) {
      final testCube = Cube(cube.x, cube.y + i, cube.z);
      if (isValid(testCube)) {
        neighbourCubes.add(testCube);
      }
    }
    for (final i in mods) {
      final testCube = Cube(cube.x, cube.y, cube.z + i);
      if (isValid(testCube)) {
        neighbourCubes.add(testCube);
      }
    }
    return neighbourCubes;
  }

  for (final cube in cubes) {
    exterior.addAll(expandAtCube(cube));
  }

  final trappedAlone = <Cube>[];
  for (final empty in exterior) {
    if (isTrappedAlone(empty)) {
      sides -= 6;
      trappedAlone.add(empty);
    }
  }
  exterior.removeWhere(trappedAlone.contains);

  bool isFree(Cube cube) {
    var xCoveredMin = false;
    var xCoveredMax = false;
    var yCoveredMin = false;
    var yCoveredMax = false;
    var zCoveredMin = false;
    var zCoveredMax = false;
    for (final other in cubes) {
      xCoveredMin = xCoveredMin ||
          (other.x < cube.x && other.y == cube.y && other.z == cube.z);
      xCoveredMax = xCoveredMax ||
          (other.x > cube.x && other.y == cube.y && other.z == cube.z);
      yCoveredMin = yCoveredMin ||
          (other.y < cube.y && other.x == cube.x && other.z == cube.z);
      yCoveredMax = yCoveredMax ||
          (other.y > cube.y && other.x == cube.x && other.z == cube.z);
      zCoveredMin = zCoveredMin ||
          (other.z < cube.z && other.x == cube.x && other.y == cube.y);
      zCoveredMax = zCoveredMax ||
          (other.z > cube.z && other.x == cube.x && other.y == cube.y);
      if (xCoveredMin &&
          xCoveredMax &&
          yCoveredMin &&
          yCoveredMax &&
          zCoveredMin &&
          zCoveredMax) {
        return false;
      }
    }
    return true;
  }

  exterior.removeWhere(isFree);

  Set<Cube>? expand(Cube cube) {
    final nextEmpties = expandAtCube(cube);
    final cubeResult = <Cube>{cube};
    if (nextEmpties.any(isFree)) {
      return null;
    }
    var hasExit = false;
    for (final nextEmpty in nextEmpties) {
      visitedEmpty.add(nextEmpty);
      final nextResult = expand(nextEmpty);
      if (nextResult == null) {
        hasExit = true;
        break;
      }
      cubeResult.addAll(nextResult);
      visitedEmpty.addAll(cubeResult);
    }
    return hasExit ? null : (cubeResult..addAll(nextEmpties));
  }

  final inPockets = <Cube>{};
  while (exterior.isNotEmpty) {
    final cube = exterior.take(1).first;
    exterior.remove(cube);
    visitedEmpty.add(cube);
    final result = expand(cube);
    if (result != null && result.isNotEmpty) {
      exterior.removeAll(result);
      visitedEmpty.addAll(result);
      inPockets.addAll(result);
    }
  }
  final sum = inPockets.map((c) => cubesAround(c).length).sum();
  print(sides - sum);
}

class Cube {
  Cube(this.x, this.y, this.z);
  final int x, y, z;

  int fromI(int i) {
    return [x, y, z][i % 3];
  }

  @override
  bool operator ==(Object other) =>
      other is Cube && x == other.x && y == other.y && z == other.z;

  @override
  int get hashCode => Object.hash(x, y, x);

  @override
  String toString() => '($x, $y, $z)';
}
