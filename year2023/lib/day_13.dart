// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('13.txt')
      .readAsStringSync()
      .split('\n')
      .splitWhere((element) => element.isEmpty);

  final result = input.fold<int>(
    0,
    (sum, map) {
      for (var i = 1; i < map.length; i++) {
        if (checkMirror(i - 1, i, map)) {
          print('Found horizontal mirror at $i');
          return sum + i * 100;
        }
      }

      //map.forEach(print);
      final rotated = mirrorMatrix(map);
      //rotated.forEach(print);

      for (var i = 1; i < rotated.length; i++) {
        if (checkMirror(i - 1, i, rotated)) {
          print('Found vertical mirror at $i');
          return sum + i;
        }
      }
      print('didn\'t find mirror');
      return sum;
    },
  );

  // 37113
  print(result);
}

bool checkMirror(int i, int j, List<String> map) {
  if (map[i] == map[j]) {
    if (i - 1 < 0 || j + 1 == map.length) {
      return true;
    }
    return checkMirror(i - 1, j + 1, map);
  }
  return false;
}

List<String> mirrorMatrix(List<String> matrix) {
  int rowLength = matrix.length;
  int columnLength = matrix[0].length;

  List<String> mirroredMatrix = List<String>.filled(columnLength, '');

  for (int row = 0; row < rowLength; row++) {
    for (int column = 0; column < columnLength; column++) {
      mirroredMatrix[column] += matrix[row][column];
    }
  }

  return mirroredMatrix;
}
