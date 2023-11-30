extension ListExtension<T> on List<T> {
  List<T> takeLast(int i) {
    return sublist(length - i, length);
  }

  List<T> removeBack(int i) {
    final result = sublist(length - i, length);
    removeRange(length - i, length);
    return result;
  }

  List<T> removeFront(int i) {
    final result = take(i).toList();
    removeRange(0, i);
    return result;
  }

  List<List<T>> splitAroundIndex(int i) {
    return [take(i).toList(), takeLast(length - i - 1).toList()];
  }

  List<List<T>> splitAt(int i) {
    return [take(i).toList(), takeLast(length - i).toList()];
  }

  bool unique() => toSet().length == length;
}

void main() {
  print([1, 2, 3, 4].takeLast(2));
  final test = [1, 2, 3, 4];
  print(test.removeBack(2));
  print(test);
  print([1, 2, 3, 4].splitAroundIndex(2));
}
