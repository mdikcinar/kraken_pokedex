import 'package:flutter/material.dart';

extension StatColorExtension on int? {
  Color get statColor {
    if (this == null) return Colors.grey;
    if (this! >= 70) return Colors.greenAccent;
    if (this! > 30) return Colors.orangeAccent;
    return Colors.redAccent;
  }
}
