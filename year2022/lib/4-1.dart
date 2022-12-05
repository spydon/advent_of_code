import 'dart:io';

import 'package:collection_ext/all.dart';

void main() {
  final input = File('4-1.txt')
      .readAsStringSync()
      .trim()
      .split('\n')
      .map((l) => l.split(','))
      .map((l) => l.map((l) => l.split('-')).toList())
      .map((l) => l
          .map((l) => IntRange(int.parse(l[0]), int.parse(l[1])).toSet())
          .toList())
      .map((l) => l[0].any((e) => l[1].contains(e)))
      .where((b) => b);
  print(input.length);
}
