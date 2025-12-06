// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(5).splitAt(195); //.splitWhere((l) => l.isEmpty);
  final fresh = input[0]
      .map((l) => l.split('-').map(int.parse).toList())
      .toList();
  final ingredients = input[1].map((int.parse)).toList();
  var sum = 0;
  for (final ingredient in ingredients) {
    for (final range in fresh) {
      if (ingredient >= range[0] && ingredient <= range[1]) {
        sum++;
        break;
      }
    }
  }

  print(sum);
}
