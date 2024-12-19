// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInputWithEmpty(19).splitWhere((line) => line.isEmpty);
  final stripes = input[0][0].split(', ').toList();
  final designs = input[1];
  final possible = <String>{};
  for (final design in designs) {
    print(design);
    final possibleStripes =
        stripes.where((stripe) => design.contains(stripe)).toList();
    final queue = <(String, int)>[(design, 0)];
    var iteration = 0;
    while (queue.isNotEmpty && iteration < 100000) {
      iteration++;
      final current = queue.removeLast();
      for (var i = current.$2; i < possibleStripes.length; i++) {
        final stripe = possibleStripes[i];
        if (current.$1 == stripe) {
          possible.add(design);
          queue.clear();
          break;
        }
        if (current.$1.startsWith(stripe)) {
          queue.add((current.$1.substring(stripe.length), 0));
        }
      }
    }
  }

  print(possible.length);
}
