import 'dart:io';

import 'package:collection/collection.dart';

void main() {
  final input = File('13-1.txt')
      .readAsStringSync()
      .replaceAll(r'^\n', '')
      .split('\n')
    ..removeWhere((e) => e.isEmpty);
  final nodes = input.map(Node.new).toList();
  final pairs = <List<Node>>[];
  for (var i = 1; i < nodes.length; i += 2) {
    pairs.add([nodes[i - 1], nodes[i]]);
  }
  final correct = <int>[];
  var index = 1;
  for (final pair in pairs) {
    if (pair[0].compareTo(pair[1]) == Tri.good) {
      print('added $index');
      correct.add(index);
    }
    index++;
  }
  print(correct.sum);
}

class Node {
  late final int? v;
  final List<Node> l = [];

  Node(String input) {
    v = int.tryParse(input);
    if (v != null) {
      return;
    }
    if (input.startsWith('[')) {
      input = input.substring(1, input.length - 1);
    }
    String currentString = '';
    int open = 0;
    for (final c in input.split('')) {
      if ((c == ',' && currentString.isNotEmpty && open == 0)) {
        l.add(Node(currentString));
        currentString = '';
        continue;
      } else if (c == ']' && open == 1) {
        l.add(Node('$currentString]'));
        currentString = '';
        open = 0;
        continue;
      } else if (c == '[') {
        open++;
      } else if (c == ']') {
        open--;
      } else if (c == ',' && open == 0) {
        continue;
      }
      currentString += c;
    }
    if (currentString.isNotEmpty) {
      l.add(Node(currentString));
    }
  }

  Node.fromDigit(int d) {
    v = null;
    l.add(Node(d.toString()));
  }

  Tri compareTo(Node n) {
    if (v != null && n.v != null) {
      return v! < n.v! ? Tri.good : (v! == n.v! ? Tri.next : Tri.bad);
    } else if (v != null) {
      return Node.fromDigit(v!).compareTo(n);
    } else if (n.v != null) {
      return compareTo(Node.fromDigit(n.v!));
    } else {
      for (var x = 0; x < l.length; x++) {
        if (n.l.length <= x) {
          return Tri.bad;
        } else {
          switch (l[x].compareTo(n.l[x])) {
            case Tri.good:
              return Tri.good;
            case Tri.next:
              continue;
            case Tri.bad:
              return Tri.bad;
          }
        }
      }
      return Tri.good;
    }
  }

  @override
  String toString() {
    if (v != null) {
      return v.toString();
    } else {
      return l
          .map((n) => n.v != null ? '${n.v}' : '[${n.toString()}]')
          .join(',');
    }
  }
}

enum Tri {
  good,
  bad,
  next,
}
