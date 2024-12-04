import 'package:year2024/common.dart';

final centers = <(int, int), int>{};

void main() {
  final input = readInput(4);
  final reversedInput = input.map((l) => l.reversed()).toList();
  print(reversedInput);
  addDiagonalResults(input);
  addDiagonalResults(input.reversed.toList(), isVerticallyReversed: true);
  addDiagonalResults(reversedInput, isHorizontallyReversed: true);
  addDiagonalResults(
    reversedInput.reversed.toList(),
    isHorizontallyReversed: true,
    isVerticallyReversed: true,
  );
  print(centers.values.where((c) => c == 2).length);
}

void addDiagonalResults(
  List<String> input, {
  bool isVerticallyReversed = false,
  bool isHorizontallyReversed = false,
}) {
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input.length; x++) {
      final result = checkDiagonal(input, x, y);
      if (result == null) {
        continue;
      }
      final rotatedResult = (
        isHorizontallyReversed ? input[0].length - 1 - result.$1 : result.$1,
        isVerticallyReversed ? input.length - 1 - result.$2 : result.$2
      );
      centers[rotatedResult] =
          centers[rotatedResult] == null ? 1 : centers[rotatedResult]! + 1;
    }
  }
}

(int, int)? checkDiagonal(
  List<String> input,
  int startX,
  int startY,
) {
  var current = '';
  var i = 0;
  while (true) {
    final nextX = startX + i;
    final nextY = startY + i;
    if (nextX >= input[0].length ||
        nextY >= input.length ||
        nextX < 0 ||
        nextY < 0) {
      return null;
    }
    final c = input[nextY][nextX];
    if ((current.isEmpty && c == 'M') ||
        (current.length == 1 && c == 'A') ||
        (current.length == 2 && c == 'S')) {
      current = '$current$c';
    } else {
      return null;
    }
    if (current == 'MAS') {
      return (startX + 1, startY + 1);
    }
    i++;
  }
}
