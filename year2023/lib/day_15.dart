// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(15)[0]
      .split(',')
      .fold(0, (sum, s) => sum + stringToHolidayNumber(s));
  print(input);
}

int stringToHolidayNumber(String s) {
  return s
      .trim()
      .split('')
      .fold(0, (sum, c) => ((sum + c.codeUnitAt(0)) * 17 % 256));
}
