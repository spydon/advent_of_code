import 'dart:io';

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

  for (var row = 0; row < 2000000; row++) {
    print(row);
    final covers = <int>{};
    for (final pairs in lines) {
      final d = pairs[0].distanceTo(pairs[1]);
      if (pairs[0].y + d < row || pairs[0].y - d > row) {
        continue;
      }
      final toRow = (pairs[0].y - row).abs();
      for (int i = 0; i < d - toRow + 1; i++) {
        final left = pairs[0].x - i;
        final right = pairs[0].x + i;
        if (left >= 0 && left <= 4000000) {
          covers.add(left);
        }
        if (right >= 0 && right <= 4000000) {
          covers.add(right);
        }
      }
    }
    if (covers.length != 4000001) {
      print('Row found $row ${covers.length}');
      break;
    }
  }
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
