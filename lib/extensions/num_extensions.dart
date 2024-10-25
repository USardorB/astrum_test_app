import 'package:flutter/widgets.dart';

extension IntegerExtensions on num {
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get h => SizedBox(height: toDouble());
  double get scaleToH => double.parse(toStringAsFixed(2));
}
