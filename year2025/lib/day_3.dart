// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(3);
  final sum = input.map((l) {
    final ints = l.split('').map(int.parse).toList();
    var c = <int?>[null, null];
    for (var i = 0; i < ints.length; i++) {
      if (c[0] == null) {
        c = [ints[i], c[1]];
      } else if (ints[i] > c[0]! && i != ints.length - 1) {
        c = [ints[i], null];
      } else if (c[1] == null) {
        c = [c[0], ints[i]];
      } else if (ints[i] > c[1]!) {
        c = [c[0], ints[i]];
      }
    }
    print(c);
    return int.parse('${c[0]}${c[1]}');
  }).sum;
  print(sum); // 3093, 17061, 17246, 17454
}
