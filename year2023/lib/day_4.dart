// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final sum = File('4.txt')
      .readAsStringSync()
      .split('\n')
      .map((line) => line.split(': ')[1].split(' | '))
      .map((line) {
    print(line[0]);
    print(line[1]);
    return Card(
      line[0]
          .replaceAll('  ', ' ')
          .split(' ')
          .where((element) => element.isNotEmpty)
          .map((e) {
        return int.parse(e.trim());
      }).toList(),
      line[1]
          .replaceAll('  ', ' ')
          .split(' ')
          .where((element) => element.isNotEmpty)
          .map((e) {
        return int.parse(e.trim());
      }).toList(),
    );
  }).fold(0, (sum, card) => sum + card.value());
  print(sum);
}

class Card {
  final List<int> have;
  final List<int> winning;

  Card(this.have, this.winning);

  int value() {
    var sum = 0;
    for (final number in have) {
      if (winning.contains(number)) {
        sum = sum == 0 ? 1 : sum * 2;
      }
    }
    return sum;
  }
}
