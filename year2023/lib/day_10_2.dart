// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('10.txt')
      .readAsStringSync()
      .split('\n')
      .map((line) => line.split('').toList())
      .toList();
  late final (int, int, int, bool) startTile;
  for (int y = 0; y < input.length; y++) {
    for (int x = 0; x < input[y].length; x++) {
      if (input[y][x] == 'S') {
        startTile = (x, y, 0, false);
      }
    }
  }

  final directions = <(int, int), List<String>>{
    (0, -1): ['|', 'F', '7'],
    (0, 1): ['|', 'L', 'J'],
    (1, 0): ['-', '7', 'J'],
    (-1, 0): ['-', 'L', 'F'],
  };
  final startTiles = directions.keys
      .map((direction) {
        final tile = (
          startTile.$1 + direction.$1,
          startTile.$2 + direction.$2,
          1,
          false
        );
        final char = input[tile.$2][tile.$1];
        final nextTiles = directions[direction]!;
        if (nextTiles.contains(char)) {
          return tile;
        }
        return null;
      })
      .whereNotNull()
      .toList();

  final loopTileResults = <(int, int, int, bool)>[];
  for (final tile in startTiles.take(1)) {
    //for (final tile in startTiles.drop(1).take(1)) {
    print(tile);
    bool isFinished = false;
    (int, int, int, bool)? lastTile = startTile;
    (int, int, int, bool)? currentTile = tile;
    while (!isFinished && currentTile != null) {
      final nextLastTile = currentTile;
      loopTileResults.add(currentTile);
      currentTile = nextTile(input, currentTile, lastTile!);
      lastTile = nextLastTile;
      isFinished = currentTile?.$4 ?? false;
    }
    if (isFinished) {
      print('Found: $tile half way is: ${(currentTile?.$3 ?? 0) / 2}');
    }
  }

  final loopTiles = loopTileResults.map((e) => (e.$1, e.$2)).toList();
  loopTiles.add((startTile.$1, startTile.$2));
  final enclosedTiles = <(int, int)>{};

  for (var i = 0; i < loopTiles.length; i++) {
    final tile = loopTiles[i];
    final lastTile = loopTiles[(i - 1) % loopTiles.length];
    final nextTile = loopTiles[(i + 1) % loopTiles.length];
    final directions = [
      (tile.$1 - lastTile.$1, tile.$2 - lastTile.$2),
      (nextTile.$1 - tile.$1, nextTile.$2 - tile.$2)
    ];
    for (final direction in directions) {
      var rightTile = (tile.$1 - direction.$2, tile.$2 + direction.$1);
      if (!loopTiles.contains(rightTile)) {
        enclosedTiles.add(rightTile);
      }
    }
  }

  var addedAny = true;
  while (addedAny) {
    addedAny = false;
    for (final tile in enclosedTiles.toList()) {
      final directions = <(int, int)>[
        (0, 1),
        (0, -1),
        (1, 0),
        (-1, 0),
      ];
      final extraTiles = directions
          .map((e) => (tile.$1 + e.$1, tile.$2 + e.$2))
          .where((e) => !loopTiles.contains(e) && !enclosedTiles.contains(e))
          .toList();
      if (extraTiles.isNotEmpty) {
        addedAny = true;
        enclosedTiles.addAll(extraTiles);
      }
    }
  }

  for (var i = 0; i < input.length; i++) {
    for (var j = 0; j < input[i].length; j++) {
      if (input[i][j] == 'S') {
        stdout.write('S');
      } else if (loopTiles.contains((j, i))) {
        stdout.write('.');
        //stdout.write(input[i][j]);
      } else if (enclosedTiles.contains((j, i))) {
        stdout.write('O');
      } else {
        stdout.write(' ');
      }
    }
    stdout.write('\n');
  }

  print(enclosedTiles.length);
}

(int, int, int, bool)? nextTile(
  List<List<String>> input,
  (int, int, int, bool) tile,
  (int, int, int, bool) lastTile,
) {
  final connectors = <String, List<(int, int)>>{
    '|': [(0, 1), (0, -1)],
    '-': [(1, 0), (-1, 0)],
    'L': [(0, -1), (1, 0)],
    'J': [(0, -1), (-1, 0)],
    '7': [(0, 1), (-1, 0)],
    'F': [(0, 1), (1, 0)],
  };
  final char = input[tile.$2][tile.$1];
  final nextTile = connectors[char]
      ?.map((e) => (tile.$1 + e.$1, tile.$2 + e.$2))
      .whereNot((e) => e.$1 == lastTile.$1 && e.$2 == lastTile.$2)
      .firstOrNull;
  if (nextTile == null) {
    return null;
  }
  final isOutOfRange = nextTile.$1 < 0 ||
      nextTile.$1 >= input[0].length ||
      nextTile.$2 < 0 ||
      nextTile.$2 >= input.length;

  if (!isOutOfRange && input[nextTile.$2][nextTile.$1] == 'S') {
    return (nextTile.$1, nextTile.$2, tile.$3 + 1, true);
  }
  return isOutOfRange ? null : (nextTile.$1, nextTile.$2, tile.$3 + 1, false);
}
