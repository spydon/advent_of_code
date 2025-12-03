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
    var result = List<int?>.generate(12, (_) => null);
    for (var i = 0; i < ints.length; i++) {
      final leftInList = ints.length - i;
      result = nextResult(
        result,
        ints[i],
        max(0, result.length - leftInList),
        12,
      );
    }
    return int.parse(result.fold('', (prev, e) => '$prev$e'));
  }).sum;
  print(sum);
}

List<int?> nextResult(
  List<int?> list,
  int n,
  int startIndex,
  int resultLength,
) {
  var result = list.toList();
  var addedInFront = false;
  for (var i = startIndex; i < list.length; i++) {
    if (addedInFront) {
      result[i] = null;
    } else if (list[i] == null || n > list[i]!) {
      result[i] = n;
      addedInFront = true;
    }
  }
  return result;
}
