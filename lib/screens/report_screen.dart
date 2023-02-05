import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../provider/transaction_provider.dart';
import 'package:provider/provider.dart';
import '../constants/style.dart';
import 'package:flutter/material.dart';

import '../widgets/charts/draw_chart.dart';

class ReportScreen extends StatefulWidget {
  final DateTime? date;
  final String? shopName;
  const ReportScreen({Key? key, this.date, this.shopName}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, int> income = Provider.of<TransactionProvider>(context)
        .inAndExTotal(date: widget.date!, inOrEx: 'in');
    Map<String, int> expense = Provider.of<TransactionProvider>(context)
        .inAndExTotal(date: widget.date!, inOrEx: 'ex');
    return Scaffold(
      appBar: AppBar(
        title: Text('Report', style: boldTextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 30),
            child: Text(DateFormat.yMMM().format(widget.date!),
                style: boldTextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            DrawChart(
              date: widget.date,
            ),
            const SizedBox(height: 30),
            DataTable(
              columnSpacing: 35,
              dividerThickness: 0.00000001,
              dataRowHeight: 27,
              headingRowHeight: 25,
              columns: const [
                DataColumn(
                    label: Text('Name',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Amount',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold))),
              ],
              rows: [
                DataRow(cells: <DataCell>[
                  const DataCell(SizedBox(
                    width: 120,
                    child: Text('Income',
                        style: TextStyle(fontSize: 14, height: 1)),
                  )),
                  DataCell(SizedBox(
                    width: 65,
                    child: Text(income['total'].toString(),
                        textAlign: TextAlign.end,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.green)),
                  )),
                ]),
                DataRow(cells: <DataCell>[
                  const DataCell(SizedBox(
                    width: 120,
                    child: Text('Expense',
                        style: TextStyle(fontSize: 14, height: 1)),
                  )),
                  DataCell(SizedBox(
                    width: 65,
                    child: Text(expense['total'].toString(),
                        textAlign: TextAlign.end,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.red)),
                  )),
                ]),
              ],
            ),
            const SizedBox(
              width: 235,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Divider(
                  indent: 1,
                  thickness: 1,
                ),
              ),
            ),
            SizedBox(
              width: 225,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Net Profit',
                          style: boldTextStyle(size: 15, height: 1)),
                      Text((income['total']! - expense['total']!).toString(),
                          textAlign: TextAlign.end,
                          style:
                              boldTextStyle(color: Colors.lightBlue, size: 15)),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
