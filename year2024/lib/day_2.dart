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
  bool isSafe = true;
  int safeNum = 0;
  for (final l in lists) {
    int? last;
    bool? increasing;
    for (final i in l) {
      if (last == null) {
        last = i;
        continue;
      }
      increasing ??= last < i;
      if (increasing && (i - last <= 3 && i - last > 0)) {
        increasing = true;
      } else if (!increasing && (last - i <= 3 && last - i > 0)) {
        increasing = false;
      } else {
        isSafe = false;
        break;
      }
      last = i;
    }
    if (isSafe) {
      safeNum++;
    }
    isSafe = true;
  }
  print(safeNum);
}
