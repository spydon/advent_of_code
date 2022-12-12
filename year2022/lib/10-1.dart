import 'dart:io';
//import 'common.dart';

void main() {
  final input = File('10-1.txt').readAsStringSync().split('\n').toList();
  var register = 1;
  var sum = 0;
  var i = 0;
  int? next;
  final it = input.iterator;
  bool addedNext = false;
  while (true) {
    i++;
    if (next != null) {
      register += next;
      next = null;
      addedNext = true;
    } else {
      addedNext = false;
    }
    final j = i + 1;
    if (j == 20 || (j - 20) % 40 == 0) {
      sum += register * j;
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
  print(sum);
}
