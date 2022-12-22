import 'dart:io';

import 'package:collection_ext/all.dart';

void main() {
  final input = File('21-1.txt').readAsStringSync().split('\n').map((e) {
    final split = e.split(': ');
    final name = split[0];
    final value = int.tryParse(split[1]);
    Token? token1;
    Token? token2;
    num Function(Token, Token)? operator;
    if (value == null) {
      final tokens = split[1].split(' ');
      token1 = Token(tokens[0]);
      token2 = Token(tokens[2]);
      switch (tokens[1]) {
        case '+':
          operator = (Token t1, Token t2) => t1.value! + t2.value!;
          break;
        case '-':
          operator = (Token t1, Token t2) => t1.value! - t2.value!;
          break;
        case '/':
          operator = (Token t1, Token t2) => t1.value! / t2.value!;
          break;
        case '*':
          operator = (Token t1, Token t2) => t1.value! * t2.value!;
          break;
      }
    }

    return MapEntry(
      name,
      Token(
        name,
        value: value,
        token1: token1,
        token2: token2,
        operator: operator,
      ),
    );
  });
  final solved = <String, Token>{}
    ..addEntries(input)
    ..removeWhere((_, t) => t.value == null);
  final unsolved = <String, Token>{}
    ..addEntries(input)
    ..removeWhere((_, t) => t.value != null);
  while (unsolved.isNotEmpty) {
    unsolved.forEach((_, t) {
      if (solved.containsKey(t.token1!.name) &&
          solved.containsKey(t.token2!.name)) {
        t.value = t.operator!(
          solved[t.token1!.name]!,
          solved[t.token2!.name]!,
        );
        solved[t.name] = t;
      }
    });
    unsolved.removeWhere((_, t) => t.value != null);
  }
  print(solved['root']!.value);
}

class Token {
  Token(this.name, {this.value, this.token1, this.token2, this.operator});

  String name;
  Token? token1;
  Token? token2;
  num Function(Token, Token)? operator;
  num? value;
}
