// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

List<String> readInput(int day) {
  return File('inputs/$day.txt').readAsStringSync().split('\n').toList();
}

void main() {
  final input = readInput(5).splitWhere((l) => l.isEmpty);
  final rules =
      input[0].map((l) => l.split('|').map(int.parse).toList()).toList();
  final updates =
      input[1].map((l) => l.split(',').map(int.parse).toList()).toList();
  var sum = 0;
  for (final update in updates) {
    var legal = true;
    for (var i = update.length - 1; i >= 0 && legal; i--) {
      final updateI = update[i];
      for (var j = i - 1; j >= 0 && legal; j--) {
        final updateJ = update[j];
        for (final rule in rules) {
          if (rule[0] == updateI && rule[1] == updateJ) {
            legal = false;
            break;
          }
        }
      }
    }
    if (legal) {
      sum += update[(update.length / 2).floor()];
    }
  }
  print(sum);
}
