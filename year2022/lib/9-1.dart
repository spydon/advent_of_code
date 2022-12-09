import 'dart:io';
import 'dart:math';
//import 'common.dart';

void main() {
  final input = File('9-1.txt').readAsStringSync().split('\n').map(
    (l) {
      final s = l.split(' ');
      return M(s[0], int.parse(s[1]));
    },
  ).toList();
  final visited = {P(0, 0)};
  var h = P(0, 0);
  var t = P(0, 0);
  for (final m in input) {
    for (var i = 0; i < m.steps; i++) {
      h = h.moved(m.d);
      if (!t.adj(h)) {
        t = t.movedCloserTo(h);
        visited.add(t);
      }
    }
  }
  print(visited.length);
}

class M {
  M(this.d, this.steps);

  final String d;
  final int steps;
}

class P {
  P(this.x, this.y);

  final int x;
  final int y;

  bool adj(P other) {
    return (x - other.x).abs() <= 1 && (y - other.y).abs() <= 1;
  }

  P movedCloserTo(P o) {
    return ['U', 'D', 'L', 'R', 'UR', 'UL', 'DR', 'DL']
        .map((d) => moved(d))
        .fold(
          P(
            1000,
            1000,
          ),
          (best, current) =>
              current.distanceTo(o) < best.distanceTo(o) ? current : best,
        );
  }

  double distanceTo(P o) {
    final result = sqrt(pow(o.x - x, 2) + pow(o.y - y, 2));
    return result < 0 ? double.maxFinite : result;
  }

  P moved(String ds) {
    P r = this;
    for (final d in ds.split('')) {
      switch (d) {
        case 'U':
          r = P(r.x, r.y - 1);
          break;
        case 'D':
          r = P(r.x, r.y + 1);
          break;
        case 'L':
          r = P(r.x - 1, r.y);
          break;
        case 'R':
          r = P(r.x + 1, r.y);
          break;
        default:
          r = P(r.x, r.y);
      }
    }
    return r;
  }

  @override
  String toString() => '($x, $y)';

  @override
  bool operator ==(Object other) {
    return other is P && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hashAll([x, y]);
}
