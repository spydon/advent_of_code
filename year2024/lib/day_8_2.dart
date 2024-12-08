// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(8);
  final antiNodes = <(int, int)>{};
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      final c = input[y][x];
      if (c != '.') {
        antiNodes.addAll(findAntiNodes(c, (x, y), input));
      }
    }
  }
  antiNodes.removeWhere(isOutside);
  print(antiNodes.length);
}

Set<(int, int)> findAntiNodes(
  String c,
  (int, int) original,
  List<String> input,
) {
  final result = {original};
  int startX = original.x + 1;
  for (var y = original.y; y < input.length; y++) {
    for (var x = startX; x < input[1].length; x++) {
      if (input[y][x] == c) {
        final other = (x, y);
        final delta = other - original;
        var lastOriginal = original;
        var lastOther = other;
        do {
          final antiNode1 = lastOriginal - delta;
          final antiNode2 = lastOther + delta;
          lastOriginal = antiNode1;
          lastOther = antiNode2;
          result.add(antiNode1);
          result.add(antiNode2);
        } while (!isOutside(lastOriginal) || !isOutside(lastOther));
      }
    }
    startX = 0;
  }
  return result;
}

bool isOutside((int, int) n) => n.x < 0 || n.y < 0 || n.x >= 50 || n.y >= 50;
