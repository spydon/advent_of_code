import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input = File('3-2.txt').readAsStringSync().trim().split('\n');
  final groups = <List<String>>[];
  while (input.isNotEmpty) {
    groups.add(input.take(3).toList());
    input.removeRange(0, 3);
  }

  print(groups.map(sameType).toList().sum);
}

int sameType(List<String> bag) {
  final c1 = bag[0].codeUnits;
  final c2 = bag[1].codeUnits;
  final c3 = bag[2].codeUnits;

  for (final i in c1) {
    for (final j in c2) {
      for (final k in c3) {
        if (i == j && j == k) {
          return i >= 97 ? i - 96 : i - 64 + 26;
        }
      }
    }
  }
  return 0;
}
