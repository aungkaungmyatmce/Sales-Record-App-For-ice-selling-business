import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/transaction_provider.dart';
import '../../screens/report_screen.dart';
import '../../services/confirm_delete_tran.dart';
import '../../services/ui_helper.dart';
import 'draw_table.dart';

class IncomeTransaction extends StatefulWidget {
  final DateTime date;
  const IncomeTransaction({Key? key, required this.date}) : super(key: key);

  @override
  _IncomeTransactionState createState() => _IncomeTransactionState();
}

class _IncomeTransactionState extends State<IncomeTransaction> {
  List<Map> allTranList = [];
  int total = 0;
  List<Map> tableDataList = [];

  @override
  Widget build(BuildContext context) {
    allTranList = Provider.of<TransactionProvider>(context)
        .transactionsForOneMonth(isIncome: true, date: widget.date);
    tableDataList = Provider.of<TransactionProvider>(context)
        .transactionsForDataTable(date: widget.date, inOrEx: 'in');
    if (allTranList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(40),
        color: Colors.white,
        child: Text(
          'No Transactions For this month!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        Provider.of<TransactionProvider>(context, listen: false)
            .refreshTransactions(date: widget.date);
      },
      child: SingleChildScrollView(
          child: Column(children: [
        ///Data Table
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.only(top: 5, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (tableDataList.isNotEmpty)
                    DrawTable(tableDataList: tableDataList),

                  ///
                  if (tableDataList.isNotEmpty)
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Divider(
                          indent: 1,
                          thickness: 1,
                        ),
                      ),
                    ),
                  Consumer<TransactionProvider>(
                    builder: (context, tranProvider, _) => SizedBox(
                      width: MediaQuery.of(context).size.width / 1.23,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style: boldTextStyle(size: 15, height: 1)),
                              Text(
                                  tranProvider
                                          .inAndExTotal(
                                              date: widget.date,
                                              inOrEx: 'in')['total']
                                          .toString() +
                                      '  ',
                                  textAlign: TextAlign.end,
                                  style: boldTextStyle(
                                      color: Colors.green, size: 15)),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportScreen(
                          date: widget.date,
                        ),
                      ));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: primaryColor, //Colors.lightBlue.withOpacity(0.17),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'View Report For This Period',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 5),

              /// Data List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allTranList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: boxDecorationRoundedWithShadow(12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(allTranList[index]['date'],
                                  style:
                                      boldTextStyle(weight: FontWeight.w600)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      allTranList[index]['totalNum'].toString(),
                                      style: secondaryTextStyle(
                                          color: Colors.black, size: 15),
                                    ),
                                    Text(
                                      allTranList[index]['totalSum'].toString(),
                                      style: secondaryTextStyle(
                                          color: Colors.green, size: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: allTranList[index]['tranList'].length,
                            itemBuilder: (context, index2) {
                              return Dismissible(
                                key: ValueKey(allTranList[index]['tranList']
                                        [index2]
                                    .tranId),
                                confirmDismiss: (direction) {
                                  return confirmDeleteTran(context);
                                },
                                onDismissed: (direction) async {
                                  await Provider.of<TransactionProvider>(
                                          context,
                                          listen: false)
                                      .deleteTransaction(
                                          allTranList[index]['tranList']
                                              [index2],
                                          widget.date);
                                  UIHelper.showSuccessFlushBar(
                                      context, 'Transaction deleted!');
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Icon(Icons.delete,
                                      color: Colors.white),
                                  alignment: Alignment.centerRight,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.7,
                                        height: 32,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  allTranList[index]['tranList']
                                                          [index2]
                                                      .customerName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: primaryTextStyle(
                                                      height: 1.3, size: 15)),
                                            ),
                                            Container(
                                              width: 80,
                                              height: 32,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(13),
                                                  border: Border.all(
                                                      color: Colors.black26)),
                                              child: Center(
                                                child: Text(
                                                  allTranList[index]['tranList']
                                                          [index2]
                                                      .productName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: secondaryTextStyle(
                                                      size: 12,
                                                      color: primaryColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                allTranList[index]['tranList']
                                                        [index2]
                                                    .number
                                                    .toString(),
                                                textAlign: TextAlign.end,
                                                style: secondaryTextStyle()),
                                            Text(
                                                allTranList[index]['tranList']
                                                        [index2]
                                                    .totalPrice
                                                    .toString(),
                                                style: secondaryTextStyle()),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ])),
    );
  }
}
