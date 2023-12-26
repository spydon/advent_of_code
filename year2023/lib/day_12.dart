// ignore_for_file: unused_import

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:collection_ext/all.dart';
import 'package:year2023/common.dart';

void main() {
  final input = readInput(12)
      .map((line) => line.split(' ').map((l) => l.split('').toList()).toList());
  final result = input.map(configurations).sum;
  print(result);

  final ranges = [(1, 1), (5, 5), (10, 12)];
  //nextPosition((1, 1), (5, 5), ['.', '?', '?', '., ., ?, ?, ., ., ., ?, #, #, .]);
}

//void moveRange(
//  int rangeId,
//  List<(int, int)> ranges,
//  List<String> map,
//  bool singleStep,
//) {
//  (int, int) initialRange = ranges[rangeId];
//  (int, int)? innerNext;
//  do {
//    void setNext() {
//      innerNext = nextPosition(
//        ranges[rangeId],
//        rangeId + 1 < ranges.length ? ranges[rangeId + 1] : null,
//        map,
//      );
//    }
//
//    final lastRange = innerNext;
//    setNext();
//    if (innerNext != null) {
//      ranges[rangeId] = innerNext!;
//      printPositions(ranges, map, 'new ');
//    } else {
//      if (rangeId + 1 < ranges.length && lastRange != null) {
//        print('running single step');
//        moveRange(rangeId + 1, ranges, map, true);
//        setNext();
//        moveRange(rangeId, ranges, map, true);
//      }
//    }
//  } while (innerNext != null && !singleStep);
//  if (!singleStep) {
//    ranges[rangeId] = initialRange;
//  }
//}

int configurations(List<List<String>> config) {
  test.clear();
  final map = config[0];
  final records = config[1].map(int.tryParse).whereType<int>().toList();
  final starts = startPositions(map, records);
  printPositions(starts, map, 'starts');
  print(starts);
  print(map);
  var ranges = starts.toList();
  final stack = Queue<List<(int, int)>>();
  printPositions(ranges, map, 'start');
  stack.add(ranges.toList());
  for (int current = ranges.length - 1; current >= 0; current--) {
    print('Outer: $current');
    final outer = stack.last.toList();
    for (int inner = ranges.length - 1; inner > current; inner--) {
      print('Inner: $inner');
      (int, int)? next;
      do {
        print('=====');
        print(outer[inner]);
        print(inner + 1 < ranges.length ? outer[inner + 1] : null);
        print(map);
        print('=====');
        next = nextPosition(
          outer[inner],
          inner + 1 < ranges.length ? outer[inner + 1] : null,
          map,
        );
        if (next != null) {
          outer[inner] = next;
          printPositions(outer, map, 'inner');
        }
      } while (next != null);
    }
    final nextStatic = nextPosition(
      stack.last[current],
      current + 1 < ranges.length ? ranges[current + 1] : null,
      map,
    );
    printPositions(outer, map, 'outer');
    if (nextStatic != null) {
      break;
    } else {
      //final last = stack.removeLast();
      //stack.add()
    }
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
