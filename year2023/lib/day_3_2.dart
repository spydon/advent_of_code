// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('3.txt')
      .readAsStringSync()
      .split('\n')
      .map((line) => line.split(''))
      .toList();
  final gears = <String, List<int>>{};
  for (int y = 0; y < input.length; y++) {
    for (int x = 0; x < input[0].length; x++) {
      final number = getNumber(input[y].toList()..removeFront(x));
      if (number == null) {
        continue;
      }
      bool addedNumber = false;
      for (int z = 0; z < number.length && !addedNumber; z++) {
        for (int sy = max(y - 1, 0);
            sy <= y + 1 && sy < input.length && !addedNumber;
            sy++) {
          for (int sx = max(x + z - 1, 0);
              sx <= x + z + 1 && sx < input[0].length;
              sx++) {
            final char = input[sy][sx];
            if (char == '*') {
              if (gears['$sx-$sy'] == null) {
                gears['$sx-$sy'] = [];
              }
              gears['$sx-$sy']!.add(int.parse(number));
              addedNumber = true;
              break;
            }
          }
        }
      }
      x += number.length;
    }
  }
  final result = gears.values
      .where((l) => l.length == 2)
      .map((l) => l.fold(1, (agg, n) => agg * n))
      .sum;
  print(result);
}

String? getNumber(List<String> line) {
  var result = '';
  for (final char in line) {
    if (char.isNumber()) {
      result = result + char;
    } else {
      break;
    }
  }
  return result.isNumber() ? result : null;
}
