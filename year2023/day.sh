#!/bin/sh
aocd 2023 $1 > $1.txt
cp lib/template.dart lib/day_$1.dart
sed -i "s/100/$1/g" lib/day_$1.dart
echo "Day $1 setup complete, good luck!"
