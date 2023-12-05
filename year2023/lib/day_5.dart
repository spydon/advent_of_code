// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = File('5.txt')
      .readAsStringSync()
      .split('\n')
      .map((l) => l.replaceAll(' map:', ''))
      .map((l) => l.replaceAll(' :', ''))
      .toList();
  final seeds =
      input.first.split(' ').toList().drop(1).map((e) => int.parse(e));
  final maps = <SourceMap>[];
  for (final mapString in input.drop(1).splitWhere((e) => e.isEmpty)) {
    final names = mapString[0].split('-');
    final source = names[2];
    final destination = names[0];
    final conversions = mapString
        .drop(1)
        .map((l) => l.split(' ').map((e) => int.parse(e)).toList())
        .toList();
    maps.add(SourceMap(source, destination, conversions));
  }

  final locations =
      maps.fold(seeds, (result, map) => map.convert(result.toList()));
  print(locations.min);
}

class SourceMap {
  SourceMap(
    this.sourceName,
    this.destinationName,
    this.conversions,
  );

  final String sourceName;
  final String destinationName;
  final List<List<int>> conversions;

  int get(int x) {
    for (final c in conversions) {
      final s = c[1];
      final d = c[0];
      final l = c[2];
      if (x >= s && x <= s + l) {
        return d + x - s;
      } else {
        continue;
      }
    }
    return x;
  }

  List<int> convert(List<int> l) => l.map(get).toList();
}
