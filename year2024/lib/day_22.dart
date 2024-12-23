// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(22).map(int.parse);
  var sum = 0;
  for (final seed in input) {
    var last = seed;
    for (var x = 0; x < 2000; x++) {
      last = nextNumber(last);
    }
    sum += last;
  }
  print(sum);
}

int nextNumber(int secret) {
  final multiplied = prune(mix(secret * 64, secret));
  final divided = prune(mix((multiplied / 32).floor(), multiplied));
  return prune(mix(divided * 2048, divided));
}

int mix(int current, int secret) {
  return current ^ secret;
}

int prune(int current) {
  return current % 16777216;
}
