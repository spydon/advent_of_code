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
  int sum = 0;
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
            if (!char.isNumber() && char != '.') {
              sum += int.parse(number);
              addedNumber = true;
              break;
            }
          }
        }
      }
      x += number.length;
    }
  }
  print(sum);
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
