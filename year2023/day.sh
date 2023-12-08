#!/bin/sh
aocd 2023 $1 > $1.txt
cp lib/day_1.dart lib/day_$1.dart
echo "Day $1 setup complete, good luck!"
