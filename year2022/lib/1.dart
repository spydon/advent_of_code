import 'dart:io';

void main() {
  final input = File('1.txt').readAsStringSync().trim();
  final answer = (input
          .split('\n\n')
          .map((l) => l.split('\n'))
          .map((s) => s.map(int.parse).reduce((a, b) => a + b))
          .toList()
        ..sort())
      .reversed
      .take(3)
      .reduce((a, b) => a + b);
  print(answer);
}
