import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import '../../widgets/transaction_history/expense_transaction.dart';
import '../../widgets/transaction_history/income_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/decoration.dart';
import '../../constants/style.dart';
import '../../provider/date_and_tabIndex_provider.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  //var _selectedDate = DateTime.now();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime _selectedDate =
        Provider.of<DateAndTabIndex>(context, listen: false).date;
    return SafeArea(
        child: Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: boldTextStyle(size: 16, color: Colors.white),
                ),
                InkWell(
                  onTap: () {
                    showMonthPicker(
                      context: context,
                      firstDate: DateTime(DateTime.now().year - 1, 5),
                      lastDate: DateTime(DateTime.now().year + 1, 9),
                      initialDate: _selectedDate,
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                          Provider.of<DateAndTabIndex>(context, listen: false)
                              .setDate(_selectedDate);
                        });
                      }
                    });
                  },
                  child: Align(
                    child: Container(
                      height: 38,
                      padding: const EdgeInsets.all(10),
                      //decoration: boxDecoration(radius: 8, showShadow: true),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.white.withOpacity(0.8)),
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Text(
                            DateFormat.yMMM().format(_selectedDate),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.date_range,
                            color: Colors.white,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: boxDecorationWithRoundedCorners(
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(30))),
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  TabBar(
                      controller: _tabController,
                      labelColor: primaryColor,
                      indicatorColor: Colors.lightBlueAccent,
                      indicatorSize: TabBarIndicatorSize.label,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: primaryTextStyle(size: 14),
                      tabs: const [
                        Tab(text: 'Income'),
                        Tab(text: 'Expense'),
                      ]),
                  Expanded(
                    child: TabBarView(controller: _tabController, children: [
                      IncomeTransaction(date: _selectedDate),
                      ExpenseTransaction(date: _selectedDate),
                    ]),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
