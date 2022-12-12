import 'dart:io';

import 'package:collection_ext/all.dart';
//import 'common.dart';

void main() {
  final input = File('10-1.txt').readAsStringSync().split('\n').toList();
  var register = 1;
  var i = 0;
  int? next;
  final crt = List<String>.generate(6 * 40, (_) => '', growable: false);
  final it = input.iterator;
  bool addedNext = false;
  while (true) {
    crt[i % crt.length] = (register - i % 40).abs() <= 1 ? '#' : '.';
    i++;
    if (next != null) {
      register += next;
      next = null;
      addedNext = true;
    } else {
      addedNext = false;
    }
    if (addedNext) {
      continue;
    }
    if (!it.moveNext()) {
      break;
    }
    final line = it.current;
    if (line != "noop") {
      next = int.parse(line.split(' ')[1]);
    }
  }
  crt.forEachIndexed((i, c) {
    if (i % 40 == 0) {
      stdout.write('\n');
    }
    stdout.write(c);
  });
}
