// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(18).map((l) {
    final e = l.split(' ');
    return (e[0], int.parse(e[1]));
  }).toList();
  var position = (0, 0);
  final directions = {
    'U': (0, -1),
    'D': (0, 1),
    'L': (-1, 0),
    'R': (1, 0),
  };
  final map = <(int, int)>{position};
  for (final line in input) {
    for (var i = 0; i < line.$2; i++) {
      position += directions[line.$1]!;
      map.add(position);
    }
  }
  final edges = map.toList();
  final fillers = <(int, int)>{};

  var lastPosition = map.first;
  for (var i = 1; i < edges.length; i++) {
    final position = edges[i];
    final nextPosition = edges[(i + 1) % edges.length];
    for (final checkPosition in [lastPosition, nextPosition]) {
      final right = ((checkPosition == lastPosition)
              ? (position - checkPosition)
              : checkPosition - position)
          .turnRight();
      var fillPosition = position + right;
      while (!map.contains(fillPosition)) {
        fillers.add(fillPosition);
        fillPosition += right;
      }
    }
    lastPosition = position;
  }

  final newFillers = fillers.toSet();

  while (newFillers.isNotEmpty) {
    for (final filler in newFillers.toList()) {
      for (final direction in directions.values) {
        final newFiller = filler + direction;
        if (!fillers.contains(newFiller) && !map.contains(newFiller)) {
          newFillers.add(newFiller);
        }
      }
    }
    fillers.addAll(newFillers);
    newFillers.clear();
  }
  map.addAll(fillers);

  print(map.length);
}
