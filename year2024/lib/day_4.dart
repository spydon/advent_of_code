import 'package:year2024/common.dart';

void main() {
  final input = readInput(4);
  final reversedInput = input.map((l) => l.reversed()).toList();
  var count = 0;
  count += checkXmas(input);
  count += checkXmas(reversedInput);
  count += checkXmas(input.rotate());
  count += checkXmas(input.rotate().map((l) => l.reversed()).toList());
  count += checkDiagonals(input);
  count += checkDiagonals(input, reverse: true);
  count += checkDiagonals(reversedInput);
  count += checkDiagonals(reversedInput, reverse: true);
  print(count);
}

int checkXmas(List<String> input) {
  var count = 0;
  for (final s in input) {
    var current = '';
    for (final c in s.split('')) {
      if ((current.isEmpty && c == 'X') ||
          (current.length == 1 && c == 'M') ||
          (current.length == 2 && c == 'A') ||
          (current.length == 3 && c == 'S')) {
        current = '$current$c';
      } else {
        current = c == 'X' ? c : '';
        continue;
      }
      if (current.length == 4) {
        count++;
        current = '';
      }
    }
  }
  return count;
}

int checkDiagonals(List<String> input, {bool reverse = false}) {
  var count = 0;
  for (var y = 0; y < input.length; y++) {
    for (var x = 0; x < input.length; x++) {
      count += checkDiagonal(input, x, y, reverse: reverse);
    }
  }
  return count;
}

int checkDiagonal(
  List<String> input,
  int startX,
  int startY, {
  bool reverse = false,
}) {
  var current = '';
  var i = 0;
  while (true) {
    final nextX = reverse ? startX - i : startX + i;
    final nextY = reverse ? startY - i : startY + i;
    if (nextX >= input[0].length ||
        nextY >= input.length ||
        nextX < 0 ||
        nextY < 0) {
      return 0;
    }
    final c = input[nextY][nextX];
    if ((current.isEmpty && c == 'X') ||
        (current.length == 1 && c == 'M') ||
        (current.length == 2 && c == 'A') ||
        (current.length == 3 && c == 'S')) {
      current = '$current$c';
    } else {
      return 0;
    }
    if (current == 'XMAS') {
      return 1;
    }
    i++;
  }
}
