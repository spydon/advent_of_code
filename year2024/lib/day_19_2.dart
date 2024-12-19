// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

final _cache = {'': 1};

void main() {
  final input = readInputWithEmpty(19).splitWhere((line) => line.isEmpty);
  final stripes = input[0][0].split(', ').toList();
  final designs = input[1];
  var sum = 0;
  for (final design in designs) {
    print(
      '(${designs.indexOf(design)}/${designs.length}) $sum $design',
    );
    sum += countWays(design, stripes);
  }

  print(sum);
}

int countWays(String design, List<String> stripes) {
  if (_cache.containsKey(design)) {
    return _cache[design]!;
  } else {
    var count = 0;
    for (final stripe in stripes) {
      if (design.startsWith(stripe)) {
        count += countWays(design.substring(stripe.length), stripes);
      }
    }
    _cache[design] = count;
    return count;
  }
}
