import 'dart:math';
import '../../model/chart/shop_per_month.dart';

import '../../constants/colors.dart';
import '../../provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
// ignore: implementation_imports
import 'package:charts_flutter/src/text_element.dart';
// ignore: implementation_imports
import 'package:charts_flutter/src/text_style.dart' as style;
import 'package:provider/provider.dart';

class DrawChart extends StatefulWidget {
  final DateTime? date;

  const DrawChart({Key? key, this.date}) : super(key: key);

  @override
  _DrawChartState createState() => _DrawChartState();
}

class _DrawChartState extends State<DrawChart> {
  // List<ShopPerMon> sampleData = [
  //   ShopPerMon('Hamburger', 90, Colors.lightBlue),
  //   ShopPerMon('Kaung', 70, Colors.lightBlue),
  //   ShopPerMon('Khin', 65, Colors.lightBlue),
  //   ShopPerMon('g', 64, Colors.lightBlue),
  //   ShopPerMon('f', 67, Colors.lightBlue),
  //   ShopPerMon('b', 69, Colors.lightBlue),
  //   ShopPerMon('gf', 65, Colors.lightBlue),
  //   ShopPerMon('ghj', 64, Colors.lightBlue),
  //   ShopPerMon('rtr', 67, Colors.lightBlue),
  //   ShopPerMon('op', 69, Colors.lightBlue),
  //   ShopPerMon('Hamburgfher', 90, Colors.lightBlue),
  //   ShopPerMon('Kaujng', 70, Colors.lightBlue),
  //   ShopPerMon('Khlin', 65, Colors.lightBlue),
  //   ShopPerMon('Ham;burger', 90, Colors.lightBlue),
  //   ShopPerMon('Kaundg', 70, Colors.lightBlue),
  //   ShopPerMon('Kh;in', 65, Colors.lightBlue),
  // ];

  List<Map> _sets = [];
  List<ShopPerMon> data = [];

  final ScrollController _verScrollController = ScrollController();
  final ScrollController _horScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final _deviceWith = MediaQuery.of(context).size.width;

    _sets = Provider.of<TransactionProvider>(context)
        .productPerShop(date: widget.date!);
    data = _sets
        .map((item) =>
            ShopPerMon(item['Name'], item['Amount'], Colors.cyan[900]!))
        .toList();
    //data = sampleData;

    var series = [
      charts.Series(
        id: 'Shops',
        data: data,
        domainFn: (ShopPerMon cus, _) => cus.customerName,
        measureFn: (ShopPerMon cus, _) => cus.number,
        colorFn: (ShopPerMon cus, _) => cus.color,
      )
    ];

    Widget chart = charts.BarChart(
      series,
      animate: true,
      primaryMeasureAxis: const charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: 5,
          desiredMinTickCount: 5,
          desiredMaxTickCount: 5,
        ),
      ),
      defaultRenderer: charts.BarRendererConfig(
        maxBarWidthPx: 20,
      ),
      domainAxis: const charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
              labelRotation: 0,
              //minimumPaddingBetweenLabelsPx: 10,
              // Tick and Label styling here.
              labelStyle: charts.TextStyleSpec(
                  fontSize: 12, // size in Pts.
                  color: charts.MaterialPalette.black),

              // Change the line colors to match text color.
              lineStyle:
                  charts.LineStyleSpec(color: charts.MaterialPalette.black))),
      behaviors: [
        charts.LinePointHighlighter(
          symbolRenderer: CustomCircleSymbolRenderer(),
        ),
        //new charts.SlidingViewport(),
        //new charts.PanAndZoomBehavior(),
        // charts.ChartTitle('Category',
        //     titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
        //     behaviorPosition: charts.BehaviorPosition.bottom,
        //     titleOutsideJustification:
        //         charts.OutsideJustification.middleDrawArea),
        // charts.ChartTitle('Amount',
        //     titleStyleSpec: charts.TextStyleSpec(fontSize: 15),
        //     behaviorPosition: charts.BehaviorPosition.start,
        //     titleOutsideJustification:
        //         charts.OutsideJustification.middleDrawArea),
      ],
      selectionModels: [
        charts.SelectionModelConfig(
            changedListener: (charts.SelectionModel model) {
          if (model.hasDatumSelection) {
            CustomCircleSymbolRenderer.setString(model.selectedSeries[0]
                .measureFn(model.selectedDatum[0].index)!
                .toStringAsFixed(0));
          }
        })
      ],
    );

    var chartWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      child: SingleChildScrollView(
        controller: _verScrollController,
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          controller: _horScrollController,
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              SizedBox(
                height: 175,
                width: _sets.length < 5
                    ? _deviceWith
                    : 73 * _sets.length.toDouble(),
                child: chart,
              ),
            ],
          ),
        ),
      ),
    );

    if (_sets.length == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(
            child: Text(
              'No Items added yet!',
              style: TextStyle(color: Colors.black54, fontSize: 25),
            ),
          ),
        ],
      );
    }

    return chartWidget;
  }
}

class CustomCircleSymbolRenderer extends charts.CircleSymbolRenderer {
  static String? amount;
  static void setString(String s) {
    amount = s;
  }

  @override
  void paint(
    charts.ChartCanvas canvas,
    Rectangle<num> bounds, {
    List<int>? dashPattern,
    charts.Color? fillColor,
    charts.FillPatternType? fillPattern,
    charts.Color? strokeColor,
    double? strokeWidthPx,
  }) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 10, bounds.top - 30, bounds.width + 30,
            bounds.height + 10),
        fill: charts.Color.transparent);
    var textStyle = style.TextStyle();
    textStyle.color = charts.Color.fromHex(code: '#1C2833');
    textStyle.fontSize = 13;
    canvas.drawText(TextElement('$amount ', style: textStyle),
        (bounds.left + 5).round(), (bounds.top - 15).round());
  }
}
