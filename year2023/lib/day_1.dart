// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('1.txt')
      .readAsStringSync()
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[A-Za-z]'), ''))
      .where((element) => element.isNotEmpty)
      .map((line) => int.parse(
          '${line.substring(0, 1)}${line.substring(line.length - 1)}'))
      .sum;
  print(input);
}
