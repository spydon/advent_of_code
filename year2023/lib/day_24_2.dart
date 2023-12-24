// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:vector_math/vector_math.dart';
import 'package:year2023/common.dart';
import 'package:z3/z3.dart';

import 'line.dart';

void main() {
  final input = readInput(24).map((l) {
    final split = l.split(' @ ');
    final position = split[0].split(', ').map((e) => int.parse(e)).toList();
    final velocity = split[1].split(', ').map((e) => int.parse(e)).toList();
    return (
      (position[0], position[1], position[2]),
      (velocity[0], velocity[1], velocity[2]),
    );
  }).toList();

  final s = solver();
  final a = constVar('a', intSort);
  final b = constVar('b', intSort);
  final c = constVar('c', intSort);
  final va = constVar('va', intSort);
  final vb = constVar('vb', intSort);
  final vc = constVar('vc', intSort);
  for (var i = 0; i < 3; i++) {
    final line = input[i];
    final p = line.$1;
    final v = line.$2;
    final t = constVar('t-$i', intSort);
    s.add(gt(t, $(0)));
    s.add(eq(add($(p.x), mul($(v.x), $(t))), add(a, mul(va, t))));
    s.add(eq(add($(p.y), mul($(v.y), $(t))), add(b, mul(vb, t))));
    s.add(eq(add($(p.z), mul($(v.z), $(t))), add(c, mul(vc, t))));
  }

  var sum = 0;
  if (s.check() != null) {
    final m = s.getModel();
    for (final variable in [a, b, c]) {
      sum += int.parse(m.eval(variable).toString());
    }
  }
  print(sum);
}
