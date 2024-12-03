// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(3).join();
  var cleanString = '';
  var i = 0;
  while (i < input.length) {
    final current = input.substring(i);
    final s = current.split("don't()");
    cleanString = '$cleanString${s[0]}';
    print(s[0]);
    if (s.length == 1) {
      break;
    }
    final nextIndex = current.indexOf('do()', current.indexOf("don't()"));
    if (nextIndex == -1) {
      break;
    }
    i += nextIndex;
  }

  final sum = cleanString.split('mul(').fold(0, (sum, s) {
    final parts = s.substring(0, min(8, s.length)).split(',');
    if (parts.length < 2) {
      return sum;
    }
    final first = int.tryParse(parts[0]);
    final p2 = parts[1];
    int? second;
    int i = 4;
    while (second == null && i > 0) {
      i--;
      second = int.tryParse(p2.substring(0, min(i, p2.length)));
    }
    final lastChar = p2.length > i - 1 ? p2[i] : null;
    if (first == null || second == null || lastChar != ')') {
      return sum;
    }
    return sum + first * second;
  });
  print(sum);
}
