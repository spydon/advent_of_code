// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

bool equalLists(List<List<String>> l1, List<List<String>> l2) {
  for (var y = 0; y < l1.length; y++) {
    for (var x = 0; x < l1[0].length; x++) {
      if (l1[y][x] != l2[y][x]) {
        return false;
      }
    }
  }
  return true;
}

bool contains(List<List<String>> l, List<List<List<String>>> previous) {
  for (final p in previous) {
    if (equalLists(l, p)) {
      return true;
    }
  }
  return false;
}

void main() {
  final input = readInput(14).map((l) => l.split('').toList()).toList();
  int calculateWeight() {
    var weight = 0;
    for (var x = 0; x < input[0].length; x++) {
      for (var y = 0; y < input.length; y++) {
        if (input[y][x] == 'O') {
          weight += (input.length - y);
        }
      }
    }
    return weight;
  }

  final previous = <int>[];
  final cycle = <(int, int)>[];
  var cyclesInCycle = 1;
  var ending = 1000000000;
  final possibilities = <int>{};
  for (var i = 0; i < ending; i++) {
    for (final _ in Direction.values) {
      rollRocks(input);
      rotateMatrix(input);
    }
    final newWeight = calculateWeight();
    if (cycle.isEmpty) {
      if (previous.contains(newWeight)) {
        cycle.add((previous.lastIndexOf(newWeight), newWeight));
      }
    } else if (cycle.isNotEmpty && cycle.last.$1 + 1 != i) {
      if (previous[cycle.last.$1 + 1] == newWeight) {
        cycle.add((cycle.last.$1 + 1, newWeight));
        if (hasFullCycle(cycle.map((e) => e.$2).toList())) {
          cyclesInCycle++;
        }
      } else {
        cyclesInCycle = 0;
        cycle.clear();
      }
    }

    previous.add(newWeight);
    if (newWeight > 88674 && newWeight < 88711 && i > ending) {
      possibilities.add(newWeight);
      print(newWeight);
    }

    if (cyclesInCycle == 10) {
      var cycleLength = cycle.length / cyclesInCycle ~/ 2;
      final firstStart = cycle.first.$1;
      ending = firstStart + ((ending - firstStart) % cycleLength) + 1;
      i = cycle.first.$1;
      previous.clear();
      cycle.clear();
      cyclesInCycle = 0;
    }
  }

  print(previous.last);
}

bool hasFullCycle(List<int> cycle) {
  if (cycle.length.isOdd) {
    return false;
  }
  final splitIndex = cycle.length ~/ 2;
  final potentialCycles = cycle.splitAt(splitIndex);
  return potentialCycles[0].equals(potentialCycles[1]);
}

enum Direction { north, west, south, east }

void rollRocks(List<List<String>> input) {
  for (var y = 1; y < input.length; y++) {
    for (var x = 0; x < input[0].length; x++) {
      if (input[y][x] != 'O') {
        continue;
      }
      var currentY = y;
      while (true) {
        if (currentY == 0 || input[currentY - 1][x] != '.') {
          break;
        }
        currentY--;
        input[currentY][x] = 'O';
        input[currentY + 1][x] = '.';
      }
    }
  }
}

void rotateMatrix(List<List<String>> matrix) {
  int n = matrix.length;

  // Transpose the matrix
  for (int y = 0; y < n; y++) {
    for (int x = y + 1; x < n; x++) {
      String temp = matrix[y][x];
      matrix[y][x] = matrix[x][y];
      matrix[x][y] = temp;
    }
  }

  // Reverse each row
  for (int i = 0; i < n; i++) {
    matrix[i] = List.from(matrix[i].reversed);
  }
}
