import 'dart:io';

import 'package:collection/collection.dart';
//import 'package:collection_ext/all.dart';
//import 'package:collection/collection.dart';

void main() {
  final input = File('5-1.txt')
      .readAsStringSync()
      .replaceAll('[', '')
      .replaceAll(']', '')
      .replaceAll('    ', '- ')
      .split('\n\n');
  var s = List.generate(9, (_) => <String>[]).toList();
  final i = input[0].split(' 1')[0].split('\n');
  print(i);
  i.forEach((l) => l.split(' ').forEachIndexed((i, c) {
        if (c != '-' && c != '') s[i].add(c);
      }));
  s = s.map((l) => l.reversed.toList()).toList();
  final moves = input[1]
      .replaceAll('move ', '')
      .replaceAll(' from', '')
      .replaceAll(' to', '')
      .split('\n')
      .map((l) => l.split(' '))
      .toList();
  print(s);
  for (final m in moves) {
    final to = int.parse(m[2]) - 1;
    final from = int.parse(m[1]) - 1;
    final amount = int.parse(m[0]);
    s[to].addAll(
      s[from].sublist(s[from].length - amount, s[from].length).reversed,
    );
    for (var i = 0; i < amount; i++) {
      s[from].removeLast();
    }
    print(s);
  }

  print(s.map((l) => l.last));
}
