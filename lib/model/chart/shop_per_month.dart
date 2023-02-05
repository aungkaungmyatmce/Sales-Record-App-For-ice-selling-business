import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class ShopPerMon {
  final String customerName;
  final int number;
  final charts.Color color;

  ShopPerMon(this.customerName, this.number, Color color)
      : color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
