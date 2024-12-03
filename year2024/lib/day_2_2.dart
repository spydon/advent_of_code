// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

void main() {
  final input = File('2.txt')
      .readAsStringSync()
      .split('\n')
      .map((s) => s.split(' '))
      .toList();

  final lists = input.map((l) => l.map(int.parse).toList()).toList();
  int safeNum = 0;
  for (final l in lists) {
    if (isListSafe(l)) {
      safeNum++;
      continue;
    }
    for (int i = 0; i < l.length; i++) {
      if (isListSafe(l.toList()..removeAt(i))) {
        safeNum++;
        break;
      }
    }
  }
  print(safeNum);
}

bool areNumbersSafe(bool increasing, int current, int last) {
  return (increasing && (current - last <= 3 && current - last > 0)) ||
      (!increasing && (last - current <= 3 && last - current > 0));
}

bool isListSafe(List<int> list) {
  if (list.length == 1) {
    return true;
  }
  final increasing = list[0] < list[1];
  for (int i = 1; i < list.length; i++) {
    if (!areNumbersSafe(increasing, list[i], list[i - 1])) {
      return false;
    }
  }
  return true;
}
