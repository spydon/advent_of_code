// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(2);
  final ranges = input[0].split(',').map((e) {
    final parts = e.split('-');
    return (int.parse(parts[0]), int.parse(parts[1]));
  }).toList();
  var sum = 0;
  for (final (start, end) in ranges) {
    for (var i = start; i <= end; i++) {
      final s = i.toString();
      for (var splitLength = 1; splitLength <= s.length / 2; splitLength++) {
        if (s.length % splitLength != 0) continue;
        final left = s.substring(0, splitLength);
        var rest = s;
        while (rest.isNotEmpty) {
          final part = rest.substring(0, splitLength);
          if (part != left) {
            break;
          }
          rest = rest.substring(splitLength);
        }
        if (rest.isEmpty) {
          sum += i;
          break;
        }
      }
    }
  }
  print(sum);
}
