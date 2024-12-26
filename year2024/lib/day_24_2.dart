// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';
import 'package:z3/z3.dart';

typedef Operation = ({
  OperationType type,
  String key1,
  String key2,
  String output,
});
late Map<String, bool> values;
late final List<Operation> operations;

final functions = {};

void main() {
  final input = readInputWithEmpty(24).splitWhere((l) => l.isEmpty);
  values = Map.fromEntries(
    input[0].map((l) {
      final split = l.split(': ');
      return MapEntry(split[0], int.parse(split[1]) == 1);
    }),
  );
  final xBinary = int.parse(toBinary('x'), radix: 2);
  final yBinary = int.parse(toBinary('y'), radix: 2);
  final expected = (xBinary & yBinary).toRadixString(2);
  print('Expected: $expected');

  operations = input[1].map((l) {
    final parts = l.split(' ');
    return (
      type: OperationType.fromString(parts[1]),
      key1: parts[0],
      key2: parts[2],
      output: parts[4],
    );
  }).toList();

  // all XOR gates must have either x## and y## as input
  // OR z## as an output.
  // So x## AND carry## would be valid,
  // but x## was always ANDed with y##)
  final faultyWires = <String>[];
  for (final operation in operations) {
    final xOrY = r'[xy]';
    switch (operation.type) {
      case OperationType.xor:
        if (!operation.key1.startsWith(xOrY) &&
            !operation.key2.startsWith(xOrY)) {
          faultyWires.addAll([operation.key1, operation.key2]);
        }
      case OperationType.and:
      // Do nothing
      case OperationType.or:
        if (!operation.output.startsWith('z')) {
          faultyWires.add(operation.output);
        }
    }
  }
  print(faultyWires.length);
  print(faultyWires);

  //final binary = toBinary('z');
  //print('Result:   $binary');
}

/// Add overrides and input values
//String runOperations(Map<String, String> overrides) {
//  while (operations.isNotEmpty) {
//    final toBeRemoved = <(String, bool Function())>[];
//    for (final operation in operations) {
//      if (operation.$2(overrides[operation.$1])) {
//        toBeRemoved.add(operation);
//      }
//    }
//    operations.removeWhere(toBeRemoved.contains);
//  }
//  return toBinary('z');
//}

String toBinary(String id) {
  return values
      .where((k, v) => k.startsWith(id))
      .toList()
      .sortedBy((e) => e.key)
      .reversed
      .map((e) => e.value ? '1' : '0')
      .join();
}

enum OperationType {
  and,
  or,
  xor;

  static OperationType fromString(String input) {
    return switch (input) {
      'AND' => OperationType.and,
      'OR' => OperationType.or,
      'XOR' => OperationType.xor,
      String() => throw UnimplementedError(),
    };
  }
}
