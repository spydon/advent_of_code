// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final cards = File('4.txt').readAsStringSync().split('\n').map((line) {
    final id = int.parse(RegExp(r'(\d+)').firstMatch(line)!.group(0)!);
    final numbers = line.split(': ')[1].split(' | ');
    return Card(
      id,
      numbers[0]
          .replaceAll('  ', ' ')
          .split(' ')
          .where((element) => element.isNotEmpty)
          .map((e) {
        return int.parse(e.trim());
      }).toList(),
      numbers[1]
          .replaceAll('  ', ' ')
          .split(' ')
          .where((element) => element.isNotEmpty)
          .map((e) {
        return int.parse(e.trim());
      }).toList(),
    );
  }).toList();
  final result = checkCards(cards, cards).length;
  print(result + cards.length);
}

List<Card> checkCards(List<Card> cards, List<Card> allCards) {
  final wonCards = <Card>[];
  for (final card in cards) {
    final newCards = card.winCalculation(allCards);
    wonCards.addAll(newCards);
    wonCards.addAll(checkCards(newCards, allCards));
  }
  return wonCards;
}

class Card {
  final int id;
  final List<int> have;
  final List<int> winning;

  Card(this.id, this.have, this.winning);

  List<Card> winCalculation(List<Card> allCards) {
    final amount = winning.toSet().intersection(have.toSet()).toList();
    return List.generate(amount.length, (i) => allCards[id + i]);
  }

  @override
  String toString() => 'Card $id';
}
