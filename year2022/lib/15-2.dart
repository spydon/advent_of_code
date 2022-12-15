import 'dart:io';

import 'package:collection_ext/all.dart';

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
    return [
      Pair.fromString(nums[0], nums[1]),
      Pair.fromString(nums[2], nums[3]),
    ];
  });

  final m = <Pair, int>{};
  for (final pairs in lines) {
    final d = pairs[0].distanceTo(pairs[1]);
    m[pairs[0]] = d;
  }

  for (int y = 0; y <= 2000000; y++) {
    print(y);
    for (int x = 0; x <= 2000000; x++) {
      if (m.any((p0, dOther) => p0.distance(x, y) < dOther)) {
        continue;
      }
      print('(x, y)');
    }
  }
}

class Pair {
  const Pair(this.x, this.y);

  factory Pair.fromString(String sx, String sy) {
    return Pair(int.parse(sx), int.parse(sy));
  }

  final int x, y;

  int distanceTo(Pair other) {
    return (other.x - x).abs() + (other.y - y).abs();
  }

  int distance(int xOther, int yOther) {
    return (xOther - x).abs() + (yOther - y).abs();
  }

  @override
  bool operator ==(Object other) =>
      other is Pair && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => '($x, $y)';
}
