import 'dart:io';

void main() {
  final shapes = [
    () => [
          ['.', '.', '@', '@', '@', '@', '.'],
        ],
    () => [
          ['.', '.', '.', '@', '.', '.', '.'],
          ['.', '.', '@', '@', '@', '.', '.'],
          ['.', '.', '.', '@', '.', '.', '.']
        ],
    () => [
          ['.', '.', '.', '.', '@', '.', '.'],
          ['.', '.', '.', '.', '@', '.', '.'],
          ['.', '.', '@', '@', '@', '.', '.']
        ],
    () => [
          ['.', '.', '@', '.', '.', '.', '.'],
          ['.', '.', '@', '.', '.', '.', '.'],
          ['.', '.', '@', '.', '.', '.', '.'],
          ['.', '.', '@', '.', '.', '.', '.']
        ],
    () => [
          ['.', '.', '@', '@', '.', '.', '.'],
          ['.', '.', '@', '@', '.', '.', '.'],
        ],
  ];

  List<List<String>> newRows() => [
        ['.', '.', '.', '.', '.', '.', '.'],
        ['.', '.', '.', '.', '.', '.', '.'],
        ['.', '.', '.', '.', '.', '.', '.'],
      ];

  final lines = File('17-1.txt').readAsStringSync().split('');
  final result = <List<String>>[];
  bool move(Direction direction) {
    bool canMove = true;
    for (int y = result.length - 1; y <= 0; y++) {
      final row = result[y];
      for (int x = 0; x < row.length; x++) {
        if (row[x] == '@') {
          switch (direction) {
            case Direction.down:
              if (y == 0 || result[y - 1][x] == '#') {
                canMove = false;
              }
              break;
            case Direction.left:
              if (x == 0 || result[y][x - 1] == '#') {
                canMove = false;
              }
              break;
            case Direction.right:
              if (x == result[y].length - 1 || result[y][x + 1] == '#') {
                canMove = false;
              }
              break;
          }
        }
      }
    }

    if (canMove) {
      for (int y = result.length - 1; y <= 0; y++) {
        final row = result[y];
        for (int x = 0; x < row.length; x++) {
          if (row[x] == '@') {
            switch (direction) {
              case Direction.down:
                result[y - 1][x] = '@';
                break;
              default:
                result[y][x + direction.dx] = '@';
                break;
            }
          }
        }
      }
    }
    return canMove;
  }
  // two left, three above highest
  // side first then down

  for (int i = 0; i <= 2022; i++) {
    result.addAll(newRows());
    result.addAll(shapes[i % shapes.length]().reversed);
    bool settled = false;
    while (!settled) {}
  }
}

enum Direction {
  down(0, -1),
  left(-1, 0),
  right(1, 0);

  const Direction(this.dx, this.dy);
  final int dx;
  final int dy;
}
