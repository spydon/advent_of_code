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
      .mapIndexed(
        (x, line) => line
            .split('')
            .mapIndexed(
              (y, e) => e == '#' ? 'l' : null,
            )
            .toList(),
      )
      .toList();
}
