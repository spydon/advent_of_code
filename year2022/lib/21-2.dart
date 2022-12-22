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
    String? operatorSymbol;
    if (value == null) {
      final tokens = split[1].split(' ');
      token1 = Token(tokens[0]);
      token2 = Token(tokens[2]);
      operatorSymbol = tokens[1];
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
        operatorSymbol: operatorSymbol,
      ),
    );
  });
  final solved = <String, Token>{}
    ..addEntries(input)
    ..removeWhere((_, t) => t.value == null);
  solved.remove('humn');
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
      } else if (solved.containsKey(t.token1!.name)) {
        t.token1 = solved[t.token1!.name];
      } else if (solved.containsKey(t.token2!.name)) {
        t.token2 = solved[t.token2!.name];
      }
    });

    final lengthBefore = unsolved.length;
    unsolved.removeWhere((_, t) => t.value != null);
    if (lengthBefore == unsolved.length) {
      break;
    }
  }

  unsolved.forEach((_, t) {
    t.token1 =
        unsolved[t.token1!.name] ?? solved[t.token1!.name] ?? Token('humn');
    t.token2 =
        unsolved[t.token2!.name] ?? solved[t.token2!.name] ?? Token('humn');
  });

  print(unsolved['root']!.token1);
  print(unsolved['root']!.token2);
}

class Token {
  Token(
    this.name, {
    this.value,
    this.token1,
    this.token2,
    this.operator,
    this.operatorSymbol,
  });

  String name;
  Token? token1;
  Token? token2;
  num Function(Token, Token)? operator;
  String? operatorSymbol;
  num? value;

  @override
  String toString() =>
      name == 'humn' ? 'humn' : '${value ?? '($token1$operatorSymbol$token2)'}';
}

// 21718827469549.0 =
// ((((53428542712900.0-((481+(((((2*(241+(9*((((((((864+(((((7*
// (((((((((851.0+(((((((((2*(966+(2*(219.0+((818+((5*(((((((((((((
// (858+((humn-5)/2))*61)-479.0)/3)+556)*2)-428.0)*2)+858.0)/2)+760.0)
// +898)/3)-385))-797.0))/3)))))-707)/3)-382.0)*2)+766)/4)-359.0)*3))/10)-31)*4)
// +777)/5)-665)/2)+448))+108)/8)-501)*41))+637)/2)-791)*2)+842.0)/9)-443.0))))
// -787)/7)-53)/2))*2))*4)+676.0)/4)
