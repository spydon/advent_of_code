import 'dart:io';
//import 'package:collection_ext/all.dart';
//import 'package:collection/collection.dart';
//import 'common.dart';

void main() {
  final window = List.generate(4, (_) => '');
  var pos = 0;
  final input = File('6-1.txt').readAsStringSync().split('');
  for (final c in input) {
    window[pos % 4] = c;
    pos++;
    if (window.toSet().length == 4 && !window.contains('')) {
      print(pos);
      break;
    }
  }
}
