// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

void main() {
  final input = File('1.txt')
      .readAsStringSync()
      .split('\n')
      .map((s) => s.split('   '))
      .toList();

  final l1 = input.map((l) => l.first).map(int.parse).toList()..sort();
  final l2 = input.map((l) => l[1]).map(int.parse).toList()..sort();
  int sum = 0;
  for (int i = 0; i < l1.length; i++) {
    sum += (l1[i] - l2[i]).abs();
  }
  print(sum);
}
