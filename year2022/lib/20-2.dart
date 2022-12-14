import 'dart:io';

import 'package:collection_ext/all.dart';

void main() {
  final input = File('20-1.txt')
      .readAsStringSync()
      .split('\n')
      .mapIndexed((i, e) => MapEntry(i + 1, int.parse(e) * 811589153))
      .toList();
  for (int x = 0; x < 10; x++) {
    for (int i = 1; i <= input.length; i++) {
      final position = input.indexWhere((e) => e.key == i);
      final line = input.firstWhere((e) => e.key == i);
      final moves = line.value;
      input.removeAt(position);
      var newPosition = (position + moves) % input.length;
      if (newPosition == 0) {
        newPosition = input.length;
      }
      input.insert(newPosition, line);
    }
  }
  final zeroPosition = input.indexWhere((e) => e.value == 0);
  final result = [1000, 2000, 3000].map(
    (i) => input[(zeroPosition + i) % input.length].value,
  );
  print(result.sum());
}
