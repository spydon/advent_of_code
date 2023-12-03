extension ListExtension<T> on List<T> {
  List<T> takeLast(int i) {
    return sublist(length - i, length);
  }

  List<T> removeBack(int i) {
    final result = sublist(length - i, length);
    removeRange(length - i, length);
    return result;
  }

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

  List<List<T>> splitAroundIndex(int i) {
    return [take(i).toList(), takeLast(length - i - 1).toList()];
  }

  List<List<T>> splitAt(int i) {
    return [take(i).toList(), takeLast(length - i).toList()];
  }

  bool unique() => toSet().length == length;
}

extension StringExtension on String {
  bool isNumber() => int.tryParse(this) != null;
}

void main() {
  print([1, 2, 3, 4].takeLast(2));
  final test = [1, 2, 3, 4];
  print(test.removeBack(2));
  print(test);
  print([1, 2, 3, 4].splitAroundIndex(2));
}
