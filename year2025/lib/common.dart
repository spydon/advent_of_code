import 'dart:io';
import 'dart:math';

const int maxInt = 0x7FFFFFFFFFFFFFFF;
bool debugPrint = true;

void dPrint(Object? s) {
  if (debugPrint) {
    print(s);
  }
}

List<String> readInput(int day) {
  return File('inputs/$day.txt')
      .readAsStringSync()
      .split('\n')
      .where((element) => element.isNotEmpty)
      .toList();
}

List<String> readInputWithEmpty(int day) {
  return File('inputs/$day.txt').readAsStringSync().split('\n').toList();
}

extension ListExtension<T> on List<T> {
  List<T> takeLast(int i) {
    return sublist(length - i, length);
  }

  List<T> removeBack(int i) {
    final result = sublist(length - i, length);
    removeRange(length - i, length);
    return result;
  }

  List<List<T>> splitAroundIndex(int i) {
    return [take(i).toList(), takeLast(length - i - 1).toList()];
  }

  List<List<T>> splitAt(int i) {
    return [take(i).toList(), takeLast(length - i).toList()];
  }

  bool containsAll(Iterable other) => other.every(contains);
}

extension StringListExtension on List<String> {
  List<String> rotate() {
    if (isEmpty) {
      return [];
    }

    // Get dimensions of original list
    final numRows = length;
    final numCols = first.length;

    // Create new list with swapped dimensions
    final rotatedList = List.generate(numCols, (i) => '');

    // Populate rotated list
    for (var i = 0; i < numRows; i++) {
      for (var j = 0; j < numCols; j++) {
        rotatedList[j] = rotatedList[j] + this[numRows - 1 - i][j];
      }
    }

    return rotatedList;
  }
}

extension MapExtension<K> on Map<K, int> {
  /// Adds one to the key if it exists and otherwise creates the key and inserts
  /// one.
  void bump(K key, int value) {
    this[key] = (this[key] ?? 0) + value;
  }
}

extension IterableExtension<T> on Iterable<T> {
  void removeFront(int i) {
    if (i == 0) {
      return;
    }
    toList().removeRange(0, i);
  }

  List<T> drop(int i) {
    if (i == 0) {
      return toList();
    }
    return toList()..removeRange(0, i);
  }

  List<List<T>> splitWhere(bool Function(T) check) {
    final result = <List<T>>[];
    final current = <T>[];
    for (final l in this) {
      if (check(l)) {
        if (current.isNotEmpty) {
          result.add(current.toList());
        }
        current.clear();
      } else {
        current.add(l);
      }
    }
    if (current.isNotEmpty) {
      result.add(current);
    }
    return result;
  }

  bool unique() => toSet().length == length;
}

extension StringExtension on String {
  bool isNumber() => int.tryParse(this) != null;
  String reversed() => split('').reversed.join('');
}

final directions = [(0, 1), (1, 0), (-1, 0), (0, -1)];
final allDirections = [
  (0, 1),
  (1, 1),
  (1, 0),
  (1, -1),
  (-1, 0),
  (-1, -1),
  (0, -1),
  (-1, 1),
];

extension CoordinateExtension on (int, int) {
  int get x => $1;

  int get y => $2;

  (int, int) operator +((int, int) other) => (x + other.x, y + other.y);

  (int, int) operator -((int, int) other) => (x - other.x, y - other.y);

  (int, int) operator *((int, int) other) => (x * other.x, y * other.y);

  (int, int) operator %((int, int) other) => (x % other.x, y % other.y);

  int operator ~/((int, int) other) => min(x ~/ other.x, y ~/ other.y);

  (int, int) scale(int multiplier) => this * (multiplier, multiplier);

  (int, int) invert() => this * (-1, -1);

  (int, int) turnLeft() => (y, -x);

  (int, int) turnRight() => (-y, x);

  (int, int) normalize() => (x.sign, y.sign);

  (int, int) stepNorth() => (x, y - 1);
  (int, int) stepEast() => (x + 1, y);
  (int, int) stepSouth() => (x, y + 1);
  (int, int) stepWest() => (x - 1, y);

  bool isOutsideString(List<String> input) =>
      x < 0 || y < 0 || x >= input[0].length || y >= input.length;
  bool isOutside(List<List<dynamic>> input) =>
      x < 0 || y < 0 || x >= input[0].length || y >= input.length;

  int distanceToSquared((int, int) arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;

    return dx * dx + dy * dy;
  }

  double distanceTo((int, int) arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;

    return sqrt(dx * dx + dy * dy);
  }

  int manhattanDistanceTo((int, int) arg) {
    return (x - arg.x).abs() + (y - arg.y).abs();
  }

  double get length => distanceTo((0, 0));

  bool isZero() => x == 0 && y == 0;

  (int, int) gcd((int, int) other) {
    return (findGCD(x, other.x), findGCD(y, other.y));
  }

  void printDirection() {
    if (!debugPrint) {
      return;
    }
    if (y < 0) {
      stdout.write('North');
    } else if (y > 0) {
      stdout.write('South');
    }
    if (x < 0) {
      stdout.write('West');
    } else if (x > 0) {
      stdout.write('East');
    }
    if (isZero()) {
      stdout.write('Zero');
    }
    stdout.writeln();
  }
}

extension CoordinateDoubleExtension on (double, double) {
  double get x => $1;

  double get y => $2;

  (double, double) operator +((double, double) other) =>
      (x + other.x, y + other.y);

  (double, double) operator -((double, double) other) =>
      (x - other.x, y - other.y);

  (double, double) operator *((double, double) other) =>
      (x * other.x, y * other.y);

  (double, double) operator %((double, double) other) =>
      (x % other.x, y % other.y);

  (double, double) invert() => this * (-1, -1);

  (double, double) turnLeft() => (y, -x);

  (double, double) turnRight() => (-y, x);

  (double, double) normalize() => (x.sign, y.sign);

  double distanceToSquared((double, double) arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;

    return dx * dx + dy * dy;
  }
}

extension Coordinate3DExtension on (int, int, int) {
  int get x => $1;

  int get y => $2;

  int get z => $3;

  (int, int, int) operator +((int, int, int) other) =>
      (x + other.x, y + other.y, z + other.z);

  (int, int, int) operator -((int, int, int) other) =>
      (x - other.x, y - other.y, z - other.z);

  (int, int, int) operator *((int, int, int) other) =>
      (x * other.x, y * other.y, z * other.z);

  (int, int, int) operator %((int, int, int) other) =>
      (x % other.x, y % other.y, z % other.z);

  (int, int, int) invert() => this * (-1, -1, -1);

  (int, int, int) normalize() => (x.sign, y.sign, z.sign);
}

extension MatrixExtensions<T> on List<List<T>> {
  T get((int, int) coordinate) => this[coordinate.y][coordinate.x];

  void printAll() {
    var line = 1;
    for (final l in this) {
      print('$line ${l.join('')}');
      line++;
    }
  }
}

int findGCD(int a, int b) {
  while (b != 0) {
    int remainder = a % b;
    a = b;
    b = remainder;
  }
  return a;
}

int findLCD(int a, int b) {
  if (a == 0 || b == 0) {
    return 0;
  }
  int gcd = findGCD(a, b);
  return (a * b) ~/ gcd;
}

int findLCDList(List<int> numbers) {
  if (numbers.isEmpty) {
    return 0;
  }

  int lcd = numbers[0];
  for (int i = 1; i < numbers.length; i++) {
    lcd = (lcd * numbers[i]) ~/ findGCD(lcd, numbers[i]);
  }

  return lcd;
}

int calculateLCM(List<List<int>> numberSeries) {
  int lcmOfTwoNumbers(int a, int b) {
    return (a * b) ~/ findGCD(a, b);
  }

  int lcm = 1;

  for (List<int> series in numberSeries) {
    for (int number in series) {
      lcm = lcmOfTwoNumbers(lcm, number);
    }
  }

  return lcm;
}

extension StreamExtension<T> on Stream<T> {
  /// If [parallelism] is `null`, [Platform.numberOfProcessors] is used.
  Stream<R> parallel<R>(
    Future<R> Function(T) convert, {
    int? parallelism,
  }) async* {
    final pending = <Future<R>>[];
    final done = <Future<R>>[];

    await for (final value in this) {
      late final Future<R> future;
      future = Future(() async {
        try {
          return await convert(value);
        } finally {
          pending.remove(future);
          done.add(future);
        }
      });
      pending.add(future);

      if (pending.length < (parallelism ?? Platform.numberOfProcessors)) {
        continue;
      }

      await Future.any(pending);

      for (final future in done) {
        yield await future;
      }
      done.clear();
    }

    for (final result in await Future.wait(pending)) {
      yield result;
    }
  }
}

bool setEquals<T>(Set<T>? a, Set<T>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  if (identical(a, b)) {
    return true;
  }
  for (final T value in a) {
    if (!b.contains(value)) {
      return false;
    }
  }
  return true;
}
