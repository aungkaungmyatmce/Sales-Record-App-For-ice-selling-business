import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/transaction_provider.dart';
import '../../services/confirm_delete_tran.dart';
import '../../services/ui_helper.dart';
import 'draw_table.dart';

class ExpenseTransaction extends StatefulWidget {
  final DateTime date;
  const ExpenseTransaction({Key? key, required this.date}) : super(key: key);

  @override
  _ExpenseTransactionState createState() => _ExpenseTransactionState();
}

class _ExpenseTransactionState extends State<ExpenseTransaction> {
  List<Map> allTranList = [];
  int total = 0;
  List<Map> tableDataList = [];

  @override
  Widget build(BuildContext context) {
    allTranList = Provider.of<TransactionProvider>(context)
        .transactionsForOneMonth(isIncome: false, date: widget.date);
    tableDataList = Provider.of<TransactionProvider>(context)
        .transactionsForDataTable(date: widget.date, inOrEx: 'ex');
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
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.only(top: 5, bottom: 8),
        child: Column(
          children: [
            ///Data Table
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     if (tableDataList.isNotEmpty)
            //       DrawTable(tableDataList: tableDataList),
            //
            //     ///
            //     if (tableDataList.isNotEmpty)
            //       SizedBox(
            //         width: MediaQuery.of(context).size.width / 1.2,
            //         child: const Align(
            //           alignment: Alignment.center,
            //           child: Divider(
            //             thickness: 1,
            //           ),
            //         ),
            //       ),
            //     Consumer<TransactionProvider>(
            //       builder: (context, tranProvider, _) => SizedBox(
            //         width: 210,
            //         child: Column(
            //           children: [
            //             Row(
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Text('Total',
            //                     style: boldTextStyle(size: 15, height: 1)),
            //                 Text(
            //                     tranProvider
            //                             .inAndExTotal(
            //                                 date: widget.date,
            //                                 inOrEx: 'ex')['total']
            //                             .toString() +
            //                         '  ',
            //                     style: boldTextStyle(color: Colors.green)),
            //               ],
            //             ),
            //             const SizedBox(height: 5),
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // const SizedBox(height: 10),

            /// Data List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allTranList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
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
                                style: boldTextStyle(weight: FontWeight.w600)),
                            Text(
                              allTranList[index]['totalSum'].toString(),
                              style: secondaryTextStyle(
                                  color: Colors.green, size: 15),
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
                                await Provider.of<TransactionProvider>(context,
                                        listen: false)
                                    .deleteTransaction(
                                        allTranList[index]['tranList'][index2],
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          allTranList[index]['tranList'][index2]
                                              .customerName,
                                          overflow: TextOverflow.ellipsis,
                                          style: primaryTextStyle(size: 15),
                                        ),
                                        if (allTranList[index]['tranList']
                                                    [index2]
                                                .productName !=
                                            null)
                                          Text(
                                            allTranList[index]['tranList']
                                                        [index2]
                                                    .productName ??
                                                '',
                                            style: secondaryTextStyle(),
                                          )
                                      ],
                                    ),
                                    Text(
                                      allTranList[index]['tranList'][index2]
                                          .totalPrice
                                          .toString(),
                                      style: secondaryTextStyle(),
                                    )
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
      ),
    );
  }
}
