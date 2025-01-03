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
}
