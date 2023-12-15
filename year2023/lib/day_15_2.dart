// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(15)[0].split(',');
  final boxes = <int, Map<String, Lens>>{};
  final bag = <String, Lens>{};
  for (String current in input) {
    if (current.contains('=')) {
      final lens = stringToLens(current);
      final box = boxes[lens.box];
      if (box == null) {
        boxes[lens.box] = {lens.label: lens};
      } else {
        if (box.containsKey(lens.label)) {
          final oldLens = box[lens.label];
          bag[lens.label] = oldLens!;
        }
        box[lens.label] = lens;
      }
    } else if (current.contains('-')) {
      final label = current.split('-')[0];
      final focalLength = stringToHolidayNumber(label);
      boxes[focalLength]?.removeWhere((key, value) => key == label);
    }
  }
  var sum = 0;
  for (final boxNumber in boxes.keys) {
    final box = boxes[boxNumber];
    final lenses = box!.values.toList();
    for (int i = 0; i < lenses.length; i++) {
      sum += (boxNumber + 1) * (i + 1) * lenses[i].focalLength;
    }
  }
  print(sum);
}

int stringToHolidayNumber(String s) {
  return s
      .trim()
      .split('')
      .fold(0, (sum, c) => ((sum + c.codeUnitAt(0)) * 17 % 256));
}

Lens stringToLens(String s) {
  final hasFocal = s.contains('=');
  final ss = hasFocal ? s.split('=') : s.split('-');
  return Lens(ss[0], stringToHolidayNumber(ss[0]), int.parse(ss[1]));
}

class Lens {
  Lens(this.label, this.box, this.focalLength);

  final String label;
  final int box;
  final int focalLength;

  @override
  String toString() => '$label $focalLength';
}
