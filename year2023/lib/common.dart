import 'dart:io';

List<String> readInput(int day) {
  return File('$day.txt')
      .readAsStringSync()
      .split('\n')
      .where((element) => element.isNotEmpty)
      .toList();
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
}

extension CoordinateExtension on (int, int) {
  int get x => $1;

  int get y => $2;

  (int, int) operator +((int, int) other) => (x + other.x, y + other.y);

  (int, int) operator -((int, int) other) => (x - other.x, y - other.y);

  (int, int) operator *((int, int) other) => (x * other.x, y * other.y);

  (int, int) operator %((int, int) other) => (x % other.x, y % other.y);

  (int, int) invert() => this * (-1, -1);

  (int, int) turnLeft() => (y, -x);

  (int, int) turnRight() => (-y, x);

  (int, int) normalize() => (x.sign, y.sign);
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

void main() {}
