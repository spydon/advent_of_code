import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input = File('3.txt').readAsStringSync().trim().split('\n');
  final answer = input
      .map(
        (l) => [l.substring(0, l.length ~/ 2), l.substring(l.length ~/ 2)],
      )
      .map(sameType)
      .toList()
      .sum;

  print(answer);
}

int sameType(List<String> bag) {
  final c1 = bag[0].codeUnits;
  final c2 = bag[1].codeUnits;

  for (final i in c1) {
    for (final j in c2) {
      if (i == j) {
        return i >= 97 ? i - 96 : i - 64 + 26;
      }
    }
  }
  return 0;
}
