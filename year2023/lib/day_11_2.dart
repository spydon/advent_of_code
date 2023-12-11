// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('11.txt')
      .readAsStringSync()
      .split('\n')
      .map((l) => l.split('').toList())
      .where((element) => element.isNotEmpty)
      .toList();
  final expanded = input.map((l) => l.toList()).toList();

  for (var i = 0; i < input.length; i++) {
    final line = input[i];
    if (!line.contains('#')) {
      expanded[i] = line.toList().map((_) => 'o').toList();
    }
  }

  final expandedVertical = expanded.map((l) => l.toList()).toList();
  for (var x = 0; x < expanded[0].length; x++) {
    var isEmptyColumn = true;
    for (var y = 0; y < expanded.length; y++) {
      if (expanded[y][x] == '#') {
        isEmptyColumn = false;
        continue;
      }
    }
    if (!isEmptyColumn) {
      isEmptyColumn = false;
      continue;
    }

    for (var y = 0; y < expandedVertical.length; y++) {
      expandedVertical[y][x] = 'o';
    }
  }

  final universe = expandedVertical;
  final galaxies = <(int, int)>[];
  for (var y = 0; y < universe.length; y++) {
    for (var x = 0; x < universe[0].length; x++) {
      if (universe[y][x] == '#') {
        galaxies.add((x, y));
      }
    }
  }

  var sum = 0;
  for (final galaxy1 in galaxies) {
    for (final galaxy2 in galaxies) {
      if (galaxy1 != galaxy2) {
        final length = lengthBetweenGalaxies(galaxy1, galaxy2, universe);
        sum += length;
      }
    }
  }
  print(sum / 2);
}

int lengthBetweenGalaxies(
  (int, int) galaxy1,
  (int, int) galaxy2,
  List<List<String>> universe,
) {
  var extraSpace = 0;
  var length = 0;
  final dy = galaxy2.$2 - galaxy1.$2;
  for (var y = galaxy1.$2 + dy.sign; y != galaxy2.$2 + dy.sign; y += dy.sign) {
    if (universe[y][galaxy1.$1] == 'o') {
      extraSpace++;
    } else {
      length++;
    }
  }
  final dx = galaxy1.$1 - galaxy2.$1;
  for (var x = galaxy2.$1 + dx.sign; x != galaxy1.$1 + dx.sign; x += dx.sign) {
    if (universe[galaxy2.$2][x] == 'o') {
      extraSpace++;
    } else {
      length++;
    }
  }
  return length + extraSpace * 1000000;
}
