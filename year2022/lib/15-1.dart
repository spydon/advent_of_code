import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final lines = File('15-1.txt')
      .readAsStringSync()
      .replaceAll('x=', '')
      .replaceAll('y=', '')
      .replaceAll(',', '')
      .replaceAll('Sensor at ', '')
      .replaceAll(': closest beacon is at', '')
      .split('\n')
      .map((l) {
    final nums = l.split(' ');
    return [Pair(nums[0], nums[1]), Pair(nums[2], nums[3])];
  });

  final covers = <int>{};
  final row = 2000000;
  for (final pairs in lines) {
    final d = pairs[0].distanceTo(pairs[1]);
    if (pairs[0].y + d < row || pairs[0].y - d > row) {
      continue;
    }
    final toRow = (pairs[0].y - row).abs();
    print('${pairs[0]} - $d');
    for (int i = 0; i < d - toRow + 1; i++) {
      covers.addAll([pairs[0].x + i, pairs[0].x - i]);
    }
  }
  print(covers.sorted((a, b) => a.compareTo(b)));
  final beaconRemovals = <Pair>{};
  for (final pairs in lines) {
    if (pairs[1].y == row) {
      beaconRemovals.add(pairs[1]);
    }
    if (pairs[0].y == row) {
      beaconRemovals.add(pairs[0]);
    }
  }
  print(covers.length - beaconRemovals.length);
}

class Pair {
  Pair(String sx, String sy) {
    x = int.parse(sx);
    y = int.parse(sy);
  }

  late final int x, y;

  int distanceTo(Pair other) {
    return (other.x - x).abs() + (other.y - y).abs();
  }

  @override
  bool operator ==(Object other) =>
      other is Pair && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}
