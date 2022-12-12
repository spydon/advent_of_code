import 'dart:io';

import 'package:collection/collection.dart'; //import 'common.dart';

void main() {
  final input = File('11-1.txt').readAsStringSync().split('\n').toList();
  final List<Monkey> monkeys = [];
  for (int i = 0; i < input.length; i += 7) {
    monkeys.add(Monkey.parse(input.sublist(i, i + 6)));
  }
  final mod = monkeys.map((m) => m.divisor).reduce((a, b) => a * b);
  for (int i = 0; i < 10000; i++) {
    for (final monkey in monkeys) {
      monkey.inspections += monkey.items.length;
      for (final item in monkey.items) {
        final newItem = monkey.operation(item) % mod;
        final passTest = monkey.test(newItem);
        monkeys[passTest ? monkey.ifTrue : monkey.ifFalse].items.add(newItem);
      }
      monkey.items.clear();
    }
  }
  final sorted = monkeys
      .sorted((m1, m2) => m2.inspections.compareTo(m1.inspections))
      .toList();
  print(sorted.map((m) => m.inspections));
  print('${sorted[0].inspections * sorted[1].inspections}');
}

class Monkey {
  Monkey({
    required this.id,
    required this.items,
    required this.operation,
    required this.divisor,
    required this.ifTrue,
    required this.ifFalse,
  });

  factory Monkey.parse(List<String> lines) {
    final id = int.parse(
      RegExp(r'^.*([0-9]+):$').firstMatch(lines[0])!.group(1)!,
    );
    final items = RegExp(r'^ {2}Starting items: (.*$)')
        .firstMatch(lines[1])!
        .group(1)!
        .split(', ')
        .map((e) => int.parse(e))
        .toList();
    final operationItems = RegExp(r'^ {2}Operation: new = (.*$)')
        .firstMatch(lines[2])!
        .group(1)!
        .split(' ');
    final maybeFirst = int.tryParse(operationItems.first);
    final maybeLast = int.tryParse(operationItems.last);
    final op = operationItems[1];
    final divisor = int.parse(lines[3].split(' ').last);
    final ifTrue = int.parse(lines[4].split(' ').last);
    final ifFalse = int.parse(lines[5].split(' ').last);
    return Monkey(
      id: id,
      items: items,
      operation: (old) => operationFun(maybeFirst, maybeLast, op, old),
      divisor: divisor,
      ifTrue: ifTrue,
      ifFalse: ifFalse,
    );
  }

  final int id;
  final List<int> items;
  final int Function(int old) operation;
  final int divisor;
  final int ifTrue;
  final int ifFalse;
  int inspections = 0;

  bool test(int item) => item % divisor == 0;

  @override
  String toString() => '$id $inspections $items';
}

int operationFun(
  int? maybeFirst,
  int? maybeLast,
  String op,
  int old,
) {
  final first = maybeFirst ?? old;
  final last = maybeLast ?? old;
  switch (op) {
    case '+':
      return first + last;
    case '*':
      return first * last;
    default:
      throw (Exception('Faulty operator $op'));
  }
}
