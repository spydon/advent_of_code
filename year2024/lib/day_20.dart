// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:a_star_algorithm/a_star_algorithm.dart';
import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() async {
  final input = readInput(20);
  final barriers = <(int, int)>[];
  late final (int, int) start;
  late final (int, int) end;

  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      if (input[y][x] == '#') {
        barriers.add((x, y));
      }
      if (input[y][x] == 'S') {
        start = (x, y);
      }
      if (input[y][x] == 'E') {
        end = (x, y);
      }
    }
  }

  final baseLength = AStar(
    rows: input.length,
    columns: input[0].length,
    start: start,
    end: end,
    barriers: barriers,
    withDiagonal: false,
  ).findThePath().length;
  print('BaseLine: $baseLength');

  final total = barriers.length;
  var i = 0;
  final streamResult = Stream.fromIterable(barriers)
      .parallel<(int, int)?>(((int, int) barrier) async {
    i++;
    print('$i/$total');
    return Isolate.run(() {
      if (barrier.x == 0 ||
          barrier.y == 0 ||
          barrier.y == input.length - 1 ||
          barrier.x == input[0].length - 1) {
        return null;
      }
      final cheat = barriers.toList()..remove(barrier);
      final path = AStar(
        rows: input.length,
        columns: input[0].length,
        start: start,
        end: end,
        barriers: cheat,
        withDiagonal: false,
      ).findThePath().toList();
      final cheatIndex = path.indexOf(barrier);
      if (cheatIndex == -1) {
        return null;
      }
      final cheatStart = path[cheatIndex - 1];
      if (path.length <= baseLength - 100) {
        return cheatStart;
      }
      return null;
    });
  });
  final result = (await streamResult.toList()).nonNulls.length;
  print(result);
}
