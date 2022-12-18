import 'dart:io';

import 'package:collection_ext/all.dart';
import 'package:year2022/common.dart';

void main() {
  final input = File('18-1.txt')
      .readAsStringSync()
      .split('\n')
      .map((l) => l.split(',').map((i) => int.parse(i)).toList(growable: false))
      .toList(growable: false);

  var sides = 0;
  final cubes = <List<int>>[];
  for (final cube in input) {
    sides += 6;
    for (final other in cubes) {
      for (int i = 0; i < 6; i++) {
        if (cube[i % 3] == other[i % 3] + (i >= 3 ? -1 : 1) &&
            cube[(i + 1) % 3] == other[(i + 1) % 3] &&
            cube[(i + 2) % 3] == other[(i + 2) % 3]) {
          sides -= 2;
        }
      }
    }
    cubes.add(cube);
  }
  print(sides);
}
