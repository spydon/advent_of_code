import 'dart:io';

//import 'package:collection_ext/all.dart';
//import 'package:collection/collection.dart';
import 'package:collection/collection.dart';

void main() {
  final input = File('7-1.txt').readAsStringSync().split('\n');
  Node? root;
  Node? current;
  for (var i = 0; i < input.length; i++) {
    final line = input[i];
    if (line == '\$ cd ..') {
      current = current!.parent;
    } else if (line.startsWith('\$ cd')) {
      final name = line.split('\$ cd ')[1];
      final node = Node.fromLs(name, true, input.sublist(i + 2), current);
      current?.c.add(node);
      current = node;
      root ??= current;
    }
  }
  fillSize(root!);
  // Answer part 1
  print(totalUnder(root));
  final spaceAvailable = 70000000 - root.size!;
  final neededSpace = 30000000 - spaceAvailable;
  // Answer part 2
  print(sizes(root).where((e) => e >= neededSpace).min);
}

int fillSize(Node n) {
  if (n.isDir) {
    n.size = n.c.map(fillSize).sum;
    return n.size!;
  } else {
    return n.size!;
  }
}

List<int> sizes(Node n) {
  final result = <int>[];
  result.add(n.size!);
  result.addAll(n.c.map((e) => sizes(e)).flattened);

  return result;
}

int totalUnder(Node n) {
  int sum = n.size! <= 100000 && n.isDir ? n.size! : 0;
  if (n.isDir) {
    sum += n.c.map(totalUnder).sum;
  }
  return sum;
}

List<Node> content(List<String> s) {
  final nodes = <Node>[];
  s.forEachIndexed((i, l) {
    if (l.startsWith('-')) {
      nodes.add(Node.fromLine(l, nodes.last));
      nodes.last.c.addAll(
        content(s
            .sublist(i + 1)
            .takeWhile((v) => !v.startsWith('-'))
            .map((l) => l.substring(2))
            .toList()),
      );
    }
  });
  return nodes;
}

class Node {
  Node(this.isDir, this.name, {this.size, this.parent});

  Node.fromLine(String l, Node? parent)
      : this(
          l.contains('(dir)'),
          l.split('- ')[1].split(' ')[0],
          size: int.tryParse(l.split('size=').last.replaceAll(')', '')),
          parent: parent,
        );

  factory Node.fromLs(
    String name,
    bool isDir,
    List<String> lines,
    Node? parent,
  ) {
    final root = Node(isDir, name, parent: parent);
    for (var i = 0; i < lines.length; i++) {
      final l = lines[i];
      final output = l.split(' ');
      if (l.startsWith('\$')) {
        break;
      } else if (l.startsWith('dir')) {
        continue;
      } else {
        root.c.add(
          Node(
            false,
            output[1],
            size: int.parse(output[0]),
            parent: root,
          ),
        );
      }
    }
    return root;
  }

  final bool isDir;
  final String name;
  int? size;
  final Node? parent;
  final List<Node> c = [];

  @override
  String toString() =>
      '$name $isDir $size\n' + c.map((e) => '  ${e.toString()}').join();
}
