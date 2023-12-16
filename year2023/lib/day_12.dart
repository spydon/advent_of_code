// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(12)
      .map((line) => line.split(' ').map((l) => l.split('').toList()).toList())
      .map(configurations2)
      .sum;
  print(input);
}

void moveRange(
  int rangeId,
  List<(int, int)> ranges,
  List<String> map,
  bool singleStep,
) {
  (int, int) initialRange = ranges[rangeId];
  (int, int)? innerNext;
  do {
    void setNext() {
      innerNext = nextPosition(
        ranges[rangeId],
        rangeId + 1 < ranges.length ? ranges[rangeId + 1] : null,
        map,
      );
    }

    final lastRange = innerNext;
    setNext();
    if (innerNext != null) {
      ranges[rangeId] = innerNext!;
      printPositions(ranges, map, 'new ');
    } else {
      if (rangeId + 1 < ranges.length && lastRange != null) {
        print('running single step');
        moveRange(rangeId + 1, ranges, map, true);
        setNext();
        moveRange(rangeId, ranges, map, true);
      }
    }
  } while (innerNext != null && !singleStep);
  if (!singleStep) {
    ranges[rangeId] = initialRange;
  }
}

int configurations2(List<List<String>> config) {
  test.clear();
  final map = config[0];
  final records = config[1].map(int.tryParse).whereType<int>().toList();
  final starts = startPositions(map, records);
  printPositions(starts, map, 'starts');
  print(starts);
  print(map);
  var ranges = starts.toList();
  var previousRanges = ranges.toList();
  printPositions(ranges, map, 'start');
  for (int current = ranges.length - 1; current >= 0; current--) {
    previousRanges = ranges.toList();
    for (int inner = ranges.length - 1; inner > current; inner--) {
      moveRange(inner, ranges, map, false);
    }
    final initialRange = ranges[current];
    //if (ranges[current] != initialRange) {
    //  //current++; // run same again since it can still move
    //} else {
    ranges = previousRanges;
    //}
    moveRange(current, ranges, map, true);
  }
  return test.length + 1;
}

(int, int)? nextPosition(
  (int, int) current,
  (int, int)? next,
  List<String> map,
) {
  if (current.$1 + 1 > map.length) {
    return null;
  }
  List<String> space;
  if (next != null) {
    if (next.$1 - 2 < current.$1 + 1) {
      space = [];
    } else {
      space = map.sublist(current.$1 + 1, next.$1 - 2);
    }
  } else {
    space = map.sublist(current.$1 + 1);
  }
  final (start, end) = current;
  final length = end - start;
  if (space.isEmpty || space.length < length || space[0] == '#') {
    return null;
  }

  for (int i = 0; i < space.length; i++) {
    if (space[i] == '#' || space[i] == '?') {
      return (start + i + 1, end + i + 1);
    }
    if (space[i] == '.') {
      return null; // ??
    }
  }
  return null;
}

List<(int, int)> startPositions(List<String> map, List<int> records) {
  final result = <(int, int)>[];
  var i = 0;
  for (final record in records) {
    while (
        (i + record < map.length && map[i + record] == '#') || map[i] == '.') {
      i++;
    }
    result.add((i, i + record - 1));
    i += record + 1;
  }

  return result;
}

Set<String> test = {};

void printPositions(List<(int, int)> positions, List<String> map, String id) {
  final output = map.toList();
  for (final position in positions) {
    output.replaceRange(
      position.$1,
      position.$2 + 1,
      List.generate(position.$2 - position.$1 + 1, (_) => '#'),
    );
  }
  test.add(output.join());
  print('$id ${output.join()}');
}
