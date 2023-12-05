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
  final seedRanges = seeds
      .splitBetweenIndexed((index, _, __) => index.isEven)
      .map((p) => Range.fromLength(p[0], p[1]))
      .toList();
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

  final translated = maps.fold(
    seedRanges,
    (previousRanges, map) => map.translate(previousRanges),
  );
  final result = translated.fold(
    double.infinity,
    (previousMin, range) => min(previousMin, range.rect.left.toDouble()),
  );
  print(result);
}

class SourceMap {
  SourceMap(
    this.sourceName,
    this.destinationName,
    List<List<int>> conversions,
  ) {
    ranges = [
      for (final c in conversions)
        (Range.fromLength(c[1], c[2]), Range.fromLength(c[0], c[2]))
    ];
  }

  final String sourceName;
  final String destinationName;
  late final List<(Range, Range)> ranges;

  List<Range> translate(List<Range> other) {
    var leftToTranslate = other.map((r) => (false, r)).toList();
    final translated = <Range>[];
    for (final r in ranges) {
      final innerLeftToTranslate = <(bool, Range)>[];
      for (final (_, otherRange) in leftToTranslate) {
        final result = otherRange
            .split(r.$1, r.$2)
            .groupListsBy((rangeResult) => rangeResult.$1);
        innerLeftToTranslate.addAll(result[false] ?? []);
        translated.addAll(result[true]?.map((r) => r.$2) ?? []);
      }
      leftToTranslate = innerLeftToTranslate;
    }
    final result = [
      ...translated,
      ...leftToTranslate.map((r) => r.$2),
    ];
    return result;
  }
}

class Range {
  Range(num start, num end) : rect = Rectangle(start, 0, end - start, 1);

  // Remember that length 0 means just the start number
  Range.fromLength(num start, num length)
      : rect = Rectangle(start, 0, length, 1);

  final Rectangle rect;

  num get width => rect.width;

  Range? intersection(Range other) {
    final intersectionRect = rect.intersection(other.rect);
    if (intersectionRect == null) {
      return null;
    }
    return Range(intersectionRect.left, intersectionRect.right);
  }

  List<(bool, Range)> split(Range other, Range intersectionTranslation) {
    final intersectionRect = rect.intersection(other.rect);
    final intersection = intersectionRect != null
        ? Range.fromLength(
            intersectionTranslation.rect.left +
                intersectionRect.left -
                other.rect.left,
            intersectionRect.width,
          )
        : null;
    final result = intersection == null
        ? [(false, this)]
        : [
            if (rect.left < other.rect.left)
              (false, Range(rect.left, other.rect.left)),
            (true, intersection),
            if (rect.right > other.rect.right)
              (false, Range(other.rect.right, rect.right)),
          ];
    return result;
  }

  @override
  String toString() => 'Range(${rect.left}, ${rect.right})';
}
