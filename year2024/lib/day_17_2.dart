// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

final List<int> registers = List.generate(3, (_) => 0);
var pointer = 0;
bool hasJumped = false;
bool shouldBreak = false;
late final List<int> program;
var output = <int>[];

void main() {
  final input = readInputWithEmpty(17).splitWhere((l) => l.isEmpty);
  final programString = input[1].first.replaceAll('Program: ', '');
  program = programString.split(',').map(int.parse).toList();
  final instructions = [adv, bxl, bst, jnz, bxc, out, bdv, cdv];

  var i = pow(8, 15).toInt() - 1;
  do {
    i += 1024;
    output = <int>[];
    pointer = 0;
    hasJumped = false;
    shouldBreak = false;
    registers[0] = i;
    registers[1] = 0;
    registers[2] = 0;
    while (!shouldBreak && output.length < program.length) {
      instructions[program[pointer]](program[pointer + 1]);
      if (!hasJumped) {
        pointer += 2;
      }
      hasJumped = false;
    }
  } while (output.length != program.length);
  print(i);
}

String toState() {
  return '$pointer,$registers';
}

int toCombo(int input) {
  return switch (input) {
    >= 0 && <= 3 => input,
    >= 4 && <= 6 => registers[input - 4],
    _ => throw UnimplementedError(),
  };
}

// opcode 0
void adv(int input) {
  final combo = toCombo(input);
  registers[0] = (registers[0] / pow(2, combo.toInt())).floor();
}

// opcode 1
void bxl(int input) {
  registers[1] = registers[1] ^ input;
}

// opcode 2
void bst(int input) {
  final combo = toCombo(input);
  registers[1] = combo % 8;
}

// opcode 3
void jnz(int input) {
  if (registers[0] == 0) {
    return;
  }
  pointer = input;
  hasJumped = true;
}

// opcode 4
void bxc(int input) {
  registers[1] ^= registers[2];
}

// opcode 5
void out(int input) {
  final out = toCombo(input) % 8;
  if (program[output.length] != out) {
    shouldBreak = true;
  } else {
    output.add(out);
  }
}

// opcode 6
void bdv(int input) {
  final combo = toCombo(input);
  registers[1] = (registers[0] / pow(2, combo.toInt())).floor();
}

// opcode 7
void cdv(int input) {
  final combo = toCombo(input);
  registers[2] = (registers[0] / pow(2, combo.toInt())).floor();
}
