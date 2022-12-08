import 'dart:io';
import 'dart:math';

import 'package:collection_ext/all.dart';
import 'package:year2022/common.dart';
//import 'common.dart';

void main() {
  final input = File('8-1.txt')
      .readAsStringSync()
      .split('\n')
      .map((l) => l.split('').map(int.parse).toList())
      .toList();
  int score = 1;
  for (var x = 1; x < input[x].length - 1; x++) {
    for (var y = 1; y < column(y, input).length - 1; y++) {
      final xAxis = input[x];
      final yAxis = column(y, input);
      final xSplit = xAxis.splitAroundIndex(y);
      final ySplit = yAxis.splitAroundIndex(x);
      final left = xSplit[0];
      final right = xSplit[1];
      final top = ySplit[0];
      final bottom = ySplit[1];
      final tree = input[x][y];
      int currentScore = 1;
      for (final l in [left.reversed, right, top.reversed, bottom]) {
        int j = 0;
        for (final i in l) {
          j++;
          if (i >= tree || l.length == j) {
            currentScore *= j;
            break;
          }
        }
      }
      score = max(score, currentScore);
    }
  }
  print('Score: $score');
}

bool treeVisible(int height, List<int> trees) {
  return trees.all((t) => t < height);
}

List<int> column(int y, List<List<int>> input) {
  final result = <int>[];
  for (var x = 0; x < input.length; x++) {
    result.add(input[x][y]);
  }
  return result;
}
