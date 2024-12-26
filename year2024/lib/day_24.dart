// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

late final Map<String, bool> values;
final functions = {
  'AND': and,
  'OR': or,
  'XOR': xor,
};

void main() {
  final input = readInputWithEmpty(24).splitWhere((l) => l.isEmpty);
  values = Map.fromEntries(
    input[0].map((l) {
      final split = l.split(': ');
      return MapEntry(split[0], int.parse(split[1]) == 1);
    }),
  );

  final operations = input[1].map((l) {
    final parts = l.split(' ');
    return () {
      final function = functions[parts[1]];
      return function!(parts[0], parts[2], parts[4]);
    };
  }).toList();

  while (operations.isNotEmpty) {
    final toBeRemoved = <bool Function()>[];
    for (final operation in operations) {
      if (operation()) {
        toBeRemoved.add(operation);
      }
    }
    operations.removeWhere(toBeRemoved.contains);
  }

  final binary = values
      .where((k, v) => k.startsWith('z'))
      .toList()
      .sortedBy((e) => e.key)
      .reversed
      .map((e) => e.value ? '1' : '0')
      .join();

  print(int.parse(binary, radix: 2));
}

bool and(String key1, String key2, String output) {
  final value1 = values[key1];
  final value2 = values[key2];
  if (value1 == null || value2 == null) {
    return false;
  }
  values[output] = value1 && value2;
  return true;
}

bool or(String key1, String key2, String output) {
  final value1 = values[key1];
  final value2 = values[key2];
  if (value1 == null || value2 == null) {
    return false;
  }
  values[output] = value1 || value2;
  return true;
}

bool xor(String key1, String key2, String output) {
  final value1 = values[key1];
  final value2 = values[key2];
  if (value1 == null || value2 == null) {
    return false;
  }
  values[output] = value1 ^ value2;
  return true;
}
