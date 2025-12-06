// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2025/common.dart';

void main() {
  final input = readInput(5).splitAt(195);
  final ranges =
      input[0].map((l) => l.split('-').map(int.parse).toList()).toList()
        ..sortByStart();
  final resultingRanges = <List<int>>[];
  for (final currentRange in ranges) {
    var merged = false;
    for (final range in resultingRanges) {
      merged = range.maybeMergeRange(currentRange);
      if (merged) {
        break;
      }
    }
    if (!merged) {
      resultingRanges.add(currentRange);
    }
  }

  var sum = 0;
  for (final range in resultingRanges) {
    sum += range[1] - range[0] + 1;
  }

  print(sum);
}

extension on List<List<int>> {
  void sortByStart() {
    sort((a, b) => a[0].compareTo(b[0]));
  }
}

extension on List<int> {
  bool maybeMergeRange(List<int> other) {
    if ((other[0] >= this[0] && other[0] <= this[1] + 1) ||
        (other[1] >= this[0] && other[1] <= this[1])) {
      this[0] = min(this[0], other[0]);
      this[1] = max(this[1], other[1]);
      return true;
    }
    return false;
  }
}
