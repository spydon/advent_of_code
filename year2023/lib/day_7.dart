// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('7.txt')
      .readAsStringSync()
      .split('\n')
      .map((line) => line.split(" "))
      .where((line) => line.isNotEmpty)
      .sortedByCompare((e) => e[0], compare)
      .mapIndexed((index, element) => int.parse(element[1]) * (index + 1))
      .toList()
      .sum;
  print(input);
}

int getStrength(String hand) {
  final checks = [
    () => isAmount(hand, 5).$1,
    () => isAmount(hand, 4).$1,
    isFullHouse,
    () => isAmount(hand, 3).$1,
    isTwoPair,
    isOnePair,
  ];
  return checks.length - checks.indexWhere((check) => check(hand));
}

int compare(String hand1, String hand2) {
  final d = getStrength(hand1) - getStrength(hand2);
  return d == 0 ? highestCard(hand1, hand2) : d;
}

int highestCard(String hand1, String hand2) {
  final order = [
    'A',
    'K',
    'Q',
    'J',
    'T',
    '9',
    '8',
    '7',
    '6',
    '5',
    '4',
    '3',
    '2',
  ];
  final h1 = hand1.split('');
  final h2 = hand2.split('');
  for (var i = 0; i < hand1.length; i++) {
    final c1 = h1[i];
    final c2 = h2[i];
    final t = order.indexOf(c2) - order.indexOf(c1);
    if (t != 0) {
      return t;
    } else {
      continue;
    }
  }
  return 0;
}

bool isFullHouse(String hand) {
  final three = isAmount(hand, 3);
  if (three.$1) {
    return isAmount(hand, 2, exclude: three.$2).$1;
  }
  return false;
}

bool isTwoPair(String hand) {
  final firstPair = isAmount(hand, 2);
  if (firstPair.$1) {
    return isAmount(hand, 2, exclude: firstPair.$2).$1;
  }
  return false;
}

bool isOnePair(String hand) {
  return isAmount(hand, 2).$1;
}

(bool, String?) isAmount(String hand, int num, {String? exclude}) {
  var amount = 0;
  String? card;
  for (final x in hand.split('')) {
    var current = 0;
    if (x == exclude) {
      continue;
    }
    for (final y in hand.split('')) {
      if (x == y) {
        current++;
      }
      if (current > amount) {
        amount++;
        card = x;
      }
    }
  }
  return (amount == num, card);
}
