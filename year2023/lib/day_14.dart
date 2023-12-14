// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(14).map((l) => l.split('').toList()).toList();
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

  var weight = 0;
  for (var x = 0; x < input[0].length; x++) {
    for (var y = 0; y < input.length; y++) {
      if (input[y][x] == 'O') {
        weight += (input.length - y);
      }
    }
  }

  print(weight);
}
