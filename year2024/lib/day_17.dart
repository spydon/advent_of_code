// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2024/common.dart';

late final List<int> registers;
var pointer = 0;
bool hasJumped = false;

void main() {
  final input = readInputWithEmpty(17).splitWhere((l) => l.isEmpty);
  registers = input[0]
      .map((l) => int.parse(l.replaceAll(RegExp(r'Register .: '), '')))
      .toList();
  final program = input[1]
      .first
      .replaceAll('Program: ', '')
      .split(',')
      .map(int.parse)
      .toList();
  final instructions = [adv, bxl, bst, jnz, bxc, out, bdv, cdv];
  while (pointer < program.length) {
    instructions[program[pointer]](program[pointer + 1]);
    if (!hasJumped) {
      pointer += 2;
    }
    hasJumped = false;
  }
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
  registers[0] =
      (BigInt.from(registers[0]) / BigInt.from(2).pow(combo)).floor();
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
  registers[1] = registers[1] ^ registers[2];
}

// opcode 5
void out(int input) {
  final combo = toCombo(input);
  stdout.write('${combo % 8},');
}

// opcode 6
void bdv(int input) {
  final combo = toCombo(input);
  registers[1] =
      (BigInt.from(registers[0]) / BigInt.from(2).pow(combo)).floor();
}

// opcode 7
void cdv(int input) {
  final combo = toCombo(input);
  registers[2] =
      (BigInt.from(registers[0]) / BigInt.from(2).pow(combo)).floor();
}
