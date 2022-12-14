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
    final result = pair[0].compareTo(pair[1]);
    if (result != Tri.bad) {
      if (result == Tri.next) {
        if (pair[0].toString() == pair[1].toString()) {
          print('Lists are identical, that means they are not in order?');
          exit(0);
        } else {
          print('Left side ran out of items, so inputs are in the right order');
          print('Added $index');
          correct.add(index);
        }
      } else {
        print('Added $index');
        correct.add(index);
      }
    }
    index++;
  }
  print(correct.sum);
}

class Node {
  late final int? v;
  final List<Node> l;

  Node(String input) : l = [] {
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

  Node.fromDigit(int d) : l = [] {
    v = null;
    l.add(Node(d.toString()));
  }

  Tri compareTo(Node n) {
    print('Compare $this to $n');
    if (v != null && n.v != null) {
      print('Value compare $this to $n');
      if (v! == n.v!) {
        return Tri.next;
      } else {
        return v! < n.v! ? Tri.good : Tri.bad;
      }
    } else if (v != null) {
      print('Mixed types; convert left to [$v] and retry comparison');
      return Node.fromDigit(v!).compareTo(n);
    } else if (n.v != null) {
      print('Mixed types; convert right to [${n.v}] and retry comparison');
      return compareTo(Node.fromDigit(n.v!));
    } else {
      for (var x = 0; x < l.length; x++) {
        if (n.l.length <= x) {
          print(
            'Right side ran out of items, so inputs are not in the right order',
          );
          return Tri.bad;
        } else {
          print('List compare ${l[x]} to ${n.l[x]}');
          switch (l[x].compareTo(n.l[x])) {
            case Tri.good:
              return Tri.good;
            case Tri.next:
              break;
            case Tri.bad:
              return Tri.bad;
          }
        }
      }
      return Tri.next;
    }
  }

  @override
  String toString() {
    if (v != null) {
      return v.toString();
    } else {
      return "[${l.map((n) => n.v != null ? '${n.v}' : n.toString()).join(',')}]";
    }
  }
}

enum Tri {
  good,
  bad,
  next,
}

// 3525 Too low
// 4513
// 6499 Too high
