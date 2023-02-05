import '../../constants/colors.dart';
import '../../provider/date_and_tabIndex_provider.dart';
import '../../provider/transaction_provider.dart';
import '../../screens/main/product_list_screen.dart';
import '../../screens/main/shop_list_screen.dart';
import '../../screens/main/shops_tocall_screen.dart';
import '../../screens/main/transaction_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/allProvider.dart';
import '../../widgets/add_new_transaction/add_new_transaction_screen.dart';

class OverallScreen extends StatefulWidget {
  const OverallScreen({Key? key}) : super(key: key);

  @override
  _OverallScreenState createState() => _OverallScreenState();
}

class _OverallScreenState extends State<OverallScreen> {
  List<Widget> _pages = [];
  int selectedPos = 0;

  void tranMessageStream() async {
    final fs = FirebaseFirestore.instance;
    DateTime selectedDate = Provider.of<DateAndTabIndex>(context).date;
    DateTime date = DateTime(selectedDate.year, selectedDate.month);
    await for (var tranSnapshot1 in fs
        .collection('allTransactions')
        .doc(DateFormat.yMMM().format(date))
        .collection('transactions')
        .snapshots()) {
      Provider.of<TransactionProvider>(context, listen: false)
          .addAllTransactions1(tranSnapshot1);
      var tranSnapshot2;
      tranSnapshot2 = await fs
          .collection('allTransactions')
          .doc(DateFormat.yMMM().format(DateTime(date.year, date.month - 1)))
          .collection('transactions')
          .get();
      Provider.of<TransactionProvider>(context, listen: false)
          .addAllTransactions2(tranSnapshot2);
    }
  }

  void allMessageStream() async {
    final fs = FirebaseFirestore.instance;
    await for (var snapshot in fs.collection('all').snapshots()) {
      Provider.of<AllProvider>(context, listen: false).addAllOfAll(snapshot);
    }
  }

  @override
  void didChangeDependencies() {
    tranMessageStream();
    allMessageStream();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _pages = [
      const TransactionScreen(),
      const ShopsToCallScreen(),
      const ShopListScreen(),
      const ProductListScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget tabItem(var pos, String title, var image, var size) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedPos = pos;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/$image.png',
                color: selectedPos == pos ? primaryColor : Colors.black54,
                width: size,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  //height: 0.7,
                  color: selectedPos == pos ? primaryColor : Colors.black54,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primaryColor,
      body: _pages[selectedPos],
      bottomNavigationBar: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 65,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 3),
              )
            ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tabItem(0, 'Trans', 'home', 20.0),
                  tabItem(1, 'Call Shops', 'stock', 22.0),
                  Container(width: 45, height: 45),
                  tabItem(2, 'Shop List', 'tran_history', 20.0),
                  tabItem(3, 'Item List', 'setting', 20.0),
                ],
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>  AddNewTransactionScreen(),
              ));
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
