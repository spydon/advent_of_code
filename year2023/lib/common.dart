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

void main() {
  print([
    ['asdf'],
    [],
    ['lol'],
    ['a']
  ].splitWhere((i) => i.isEmpty));
}
