// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

void main() {
  final input = readInput(9)[0];
  var formatted = <int>[];
  for (var i = 0; i < input.length; i++) {
    final id = i.isEven ? (i / 2).round() : -1;
    formatted.addAll(List.generate(int.parse(input[i]), (_) => id));
  }
  int lastOccupied = lastIndexOf(formatted, formatted.length - 1);
  while (lastOccupied != -1) {
    final blockLength = moveBlock(formatted, lastOccupied);
    lastOccupied = lastIndexOf(formatted, lastOccupied - blockLength);
  }

  final result = formatted.foldIndexed(
    BigInt.zero,
    (i, sum, e) => e < 0 ? sum : sum + BigInt.from(i) * BigInt.from(e),
  );
  print(result);
}

int lastIndexOf(List<int> s, int max) {
  for (var i = max; i > 0; i--) {
    if (s[i] != -1) {
      return i;
    }
  }
  return -1;
}

int moveBlock(List<int> formatted, int index) {
  var length = 0;
  final id = formatted[index];
  for (int i = index; i > 0; i--) {
    if (formatted[i] == id) {
      length++;
    } else {
      break;
    }
  }
  final startIndex = findSpaceOfLength(formatted, length, max: index);
  if (startIndex == -1) {
    return length;
  }
  for (int i = 0; i < length; i++) {
    formatted.swap(startIndex + i + 1, index - i);
  }
  return length;
}

int findSpaceOfLength(List<int> formatted, int size, {int? max}) {
  int currentSize = 0;
  for (var i = 0; i < (max ?? formatted.length); i++) {
    if (formatted[i] != -1) {
      currentSize = 0;
      continue;
    }
    currentSize++;
    if (currentSize == size) {
      return i - size;
    }
  }
  return -1;
}

void printFormatted(List<int> formatted) {
  print(formatted.map((i) => i == -1 ? '.' : '$i').join());
}
