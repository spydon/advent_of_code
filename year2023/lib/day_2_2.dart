// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('2.txt').readAsStringSync().split('\n').map((line) {
    final minColors = {'red': 0, 'green': 0, 'blue': 0};
    final game = line.split(': ')[1].split('; ');
    for (final round in game) {
      for (final play in round.split(', ')) {
        final amount = int.parse(play.split(' ')[0]);
        final color = play.split(' ')[1];
        minColors[color] = max(minColors[color]!, amount);
      }
    }
    return minColors.values.reduce((value, element) => value * element);
  }).sum;
  print(input);
}
