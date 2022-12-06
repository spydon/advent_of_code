import 'dart:io';
//import 'package:collection_ext/all.dart';
//import 'package:collection/collection.dart';
//import 'common.dart';

void main() {
  final window = List.generate(14, (_) => '');
  var pos = 0;
  final input = File('6-1.txt').readAsStringSync().split('');
  for (final c in input) {
    window[pos % 14] = c;
    pos++;
    if (window.toSet().length == 14 && !window.contains('')) {
      print(pos);
      break;
    }
  }
}
