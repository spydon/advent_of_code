// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('2.txt').readAsStringSync().split('\n').map((line) {
    final total = {'red': 12, 'green': 13, 'blue': 14};
    final id = RegExp(r'(\d+)').firstMatch(line)?.group(0)!;
    final game = line.split(': ')[1].split('; ');
    for (final round in game) {
      for (final play in round.split(', ')) {
        final amount = int.parse(play.split(' ')[0]);
        final color = play.split(' ')[1];
        if (total.containsKey(color)) {
          if (total[color]! < amount) {
            return 0;
          }
        } else {
          return 0;
        }
      }
    }
    return int.parse(id!);
  }).sum;
  print(input);
}
