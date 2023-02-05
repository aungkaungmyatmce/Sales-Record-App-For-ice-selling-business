import '../model/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/shop.dart';

class TransactionProvider with ChangeNotifier {
  CollectionReference transactionCollection =
      FirebaseFirestore.instance.collection('allTransactions');

  List<Transaction> _allTransactionList = [];
  List<Transaction> get allTransactions => [..._allTransactionList];

  void addAllTransactions1(QuerySnapshot snapshots1) {
    List docList1 = snapshots1.docs;
    _allTransactionList = [];
    docList1.map((doc) {
      _allTransactionList.add(Transaction.fromJson(doc));
    }).toList();
    notifyListeners();
  }

  void addAllTransactions2(QuerySnapshot snapshots2) {
    List docList2 = snapshots2.docs;

    docList2.map((doc) {
      _allTransactionList.add(Transaction.fromJson(doc));
    }).toList();
    notifyListeners();
  }

  Future<void> refreshTransactions({required DateTime date}) async {
    final qsn1 = await transactionCollection
        .doc(DateFormat.yMMM().format(date))
        .collection('transactions')
        .get();
    final qsn2 = await transactionCollection
        .doc(DateFormat.yMMM().format(DateTime(date.year, date.month - 1)))
        .collection('transactions')
        .get();
    final list1 = qsn1.docs.map((tran) => Transaction.fromJson(tran)).toList();
    final list2 = qsn2.docs.map((tran) => Transaction.fromJson(tran)).toList();
    _allTransactionList = [];
    _allTransactionList = list1 + list2;
    notifyListeners();
  }

  List<Map<String, dynamic>> transactionsForOneMonth(
      {required bool isIncome, required DateTime date}) {
    List<Transaction> dayTranList = isIncome
        ? _allTransactionList
            .where((tran) =>
                tran.sellingDate?.year == date.year &&
                tran.sellingDate?.month == date.month &&
                tran.category == 'income')
            .toList()
        : _allTransactionList
            .where((tran) =>
                tran.sellingDate?.year == date.year &&
                tran.sellingDate?.month == date.month &&
                tran.category == 'expense')
            .toList();
    List<Map<String, dynamic>> dailyTranList = [];

    for (int day = 31; day >= 0; day--) {
      int totalSum = 0;
      int totalNumber = 0;
      List<Transaction> dayList =
          dayTranList.where((tran) => tran.sellingDate?.day == day).toList();
      if (dayList.isNotEmpty) {
        for (var dayTran in dayList) {
          totalSum += dayTran.totalPrice!;
          totalNumber += dayTran.number!;
        }
        Map<String, dynamic> dayMap = {
          'date': DateFormat('dd MMMM, yyyy')
              .format(dayList.first.sellingDate!)
              .toString(),
          'tranList': dayList,
          'totalNum': totalNumber.toString(),
          'totalSum': totalSum.toString(),
        };
        dailyTranList.add(dayMap);
      }
    }
    return dailyTranList;
  }

  Future<void> addIncome(List<Transaction> trans, DateTime date) async {
    for (var tran in trans) {
      await transactionCollection
          .doc(DateFormat.yMMM().format(date).toString())
          .collection('transactions')
          .add(Transaction().toJson(tran));
    }
    notifyListeners();
  }

  Future<void> deleteTransaction(Transaction tran, DateTime date) async {
    _allTransactionList.removeWhere((transa) => transa.tranId == tran.tranId);
    transactionCollection
        .doc(DateFormat.yMMM().format(date).toString())
        .collection('transactions')
        .doc(tran.tranId)
        .delete();
    notifyListeners();
  }

  List<Map> transactionsForDataTable(
      {required DateTime date,
      bool addTotalSum = false,
      required String inOrEx}) {
    List<String> productNames = [];
    List<int> numList = [];
    List<int> priceList = [];
    int totalNum = 0;
    int totalPrice = 0;

    List<Transaction> tranList = [];

    tranList = inOrEx == 'in'
        ? _allTransactionList
            .where((tran) =>
                tran.sellingDate?.year == date.year &&
                tran.sellingDate?.month == date.month &&
                tran.category == 'income')
            .toList()
        : _allTransactionList
            .where((tran) =>
                tran.sellingDate?.year == date.year &&
                tran.sellingDate?.month == date.month &&
                tran.category == 'expense')
            .toList();

    for (var tran in tranList) {
      if (inOrEx == 'in') {
        if (!productNames.contains(tran.productName)) {
          productNames.add(tran.productName!);
        }
      } else {
        if (!productNames.contains(tran.customerName)) {
          productNames.add(tran.customerName!);
        }
      }
    }

    for (var proName in productNames) {
      int num = 0;
      int price = 0;
      for (var tran in tranList) {
        if (inOrEx == 'in') {
          if (proName == tran.productName) {
            num += tran.number!;
            price += tran.totalPrice!;
          }
        } else {
          if (proName == tran.customerName) {
            num += tran.number!;
            price += tran.totalPrice!;
          }
        }
      }
      numList.add(num);
      priceList.add(price);
      totalNum += num;
      totalPrice += price;
    }

    List<Map> dataList = List.generate(
        productNames.length,
        (index) => {
              'Name': productNames[index],
              'No': inOrEx == 'in' ? numList[index].toString() : null,
              'Price': priceList[index].toString(),
            });
    if (addTotalSum) {
      dataList.add({
        'totalNum': totalNum.toString(),
        'totalPrice': totalPrice.toString(),
      });
    }
    return dataList;
  }

  ///

  Map<String, int> inAndExTotal(
      {required DateTime date, required String inOrEx}) {
    List<Transaction> tranList = [];
    int total = 0;
    tranList = inOrEx == 'in'
        ? _allTransactionList
            .where((tran) =>
                tran.sellingDate?.year == date.year &&
                tran.sellingDate?.month == date.month &&
                tran.category == 'income')
            .toList()
        : _allTransactionList
            .where((tran) =>
                tran.sellingDate?.year == date.year &&
                tran.sellingDate?.month == date.month &&
                tran.category == 'expense')
            .toList();
    for (var tran in tranList) {
      total += tran.totalPrice!;
    }

    Map<String, int> totalInAndEx = {'total': total};
    return totalInAndEx;
  }

  ///

  List<Map<String, dynamic>> shopsToCall() {
    List<Map<String, dynamic>> shopsToCallList = [];
    List<String> shopNames = [];
    List<Transaction> _tranList = [];

    _tranList =
        _allTransactionList.where((tran) => tran.category == 'income').toList();

    for (var tran in _tranList) {
      if (!shopNames.contains(tran.customerName)) {
        shopNames.add(tran.customerName!);
      }
    }

    for (var shop in shopNames) {
      List<int> numList = [];
      int orderHabit = 0;
      List<Transaction> tranListForShop =
          _tranList.where((tran) => tran.customerName == shop).toList();
      tranListForShop.sort((b, a) => a.sellingDate!.compareTo(b.sellingDate!));

      for (var shop in tranListForShop) {
        if (shop != tranListForShop.last) {
          DateTime from = DateTime(shop.sellingDate!.year,
              shop.sellingDate!.month, shop.sellingDate!.day);
          DateTime to = DateTime(
              tranListForShop[tranListForShop.indexOf(shop) + 1]
                  .sellingDate!
                  .year,
              tranListForShop[tranListForShop.indexOf(shop) + 1]
                  .sellingDate!
                  .month,
              tranListForShop[tranListForShop.indexOf(shop) + 1]
                  .sellingDate!
                  .day);
          int dayDifference = from.difference(to).inDays;
          if (dayDifference != 0) {
            numList.add(dayDifference);
          }
        }
      }
      if (numList.isNotEmpty) {
        if (numList.length > 4) {
          numList = numList.getRange(0, 4).toList();
        }
        for (int i in numList) {
          orderHabit += i;
        }
        orderHabit =
            int.parse((orderHabit / numList.length).toStringAsFixed(0));
        //print(orderHabit);
        // print(DateTime.now()
        //     .difference(tranListForShop.first.sellingDate!)
        //     .inDays);
        if ((DateTime.now()
                    .difference(DateTime(
                        tranListForShop.first.sellingDate!.year,
                        tranListForShop.first.sellingDate!.month,
                        tranListForShop.first.sellingDate!.day))
                    .inDays >=
                orderHabit) &&
            (DateTime.now()
                        .difference(tranListForShop.first.sellingDate!)
                        .inDays -
                    orderHabit) <
                5) {
          Map<String, dynamic> shopToCall = {
            'name': shop,
            'last order': DateTime.now()
                .difference(DateTime(
                    tranListForShop.first.sellingDate!.year,
                    tranListForShop.first.sellingDate!.month,
                    tranListForShop.first.sellingDate!.day))
                .inDays,
            'order habit': orderHabit,
            'day difference': DateTime.now()
                    .difference(DateTime(
                        tranListForShop.first.sellingDate!.year,
                        tranListForShop.first.sellingDate!.month,
                        tranListForShop.first.sellingDate!.day))
                    .inDays -
                orderHabit,
          };
          if (shopToCall['name'] != 'အိမ်' && shopToCall['name'] != 'Chue') {
            shopsToCallList.add(shopToCall);
          }
        }
      }
    }

    shopsToCallList
        .sort((a, b) => a['day difference'].compareTo(b['day difference']));
    return shopsToCallList;
  }

  ///

  List<String> sortShopNames(List<String?> shopNames) {
    List<Map<String, dynamic>> shopMapList = [];
    List<String> shopList = [];
    List<Transaction> _tranList = _allTransactionList
        .where((tran) =>
            tran.sellingDate?.year == DateTime.now().year &&
            tran.sellingDate?.month == DateTime.now().month)
        .toList();

    for (var shop in shopNames) {
      int num = 0;
      for (var tran in _tranList) {
        if (tran.customerName == shop) {
          num += tran.number!;
        }
      }
      Map<String, dynamic> sho = {
        'name': shop,
        'num': num,
      };
      shopMapList.add(sho);
    }
    //print(shopMapList);
    shopMapList.sort((a, b) => b['num'].compareTo(a['num']));
    for (var sl in shopMapList) {
      shopList.add(sl['name']);
    }
    List shopsCall = shopsToCall().reversed.toList();
    for (var sc in shopsCall) {
      if (shopList.contains(sc['name'])) {
        shopList.removeWhere((sl) => sl == sc['name']);
        shopList.insert(0, sc['name']);
      }
    }
    return shopList;
  }

  ///

  List<Map> sortShopNamesWithAmt(List<Shop?> shops) {
    List<Map<String, dynamic>> shopMapList = [];
    List<Transaction> _tranList = _allTransactionList
        .where((tran) =>
            tran.sellingDate?.year == DateTime.now().year &&
            tran.sellingDate?.month == DateTime.now().month)
        .toList();

    for (var shop in shops) {
      int num = 0;
      for (var tran in _tranList) {
        if (tran.customerName == shop?.name) {
          num += tran.number!;
        }
      }
      Map<String, dynamic> sho = {
        'shop': shop,
        'name': shop?.name,
        'num': num,
        'buyingProduct': shop?.buyingProduct,
        'phNo': shop?.phNo,
      };
      shopMapList.add(sho);
    }
    //print(shopMapList);
    shopMapList.sort((a, b) => b['num'].compareTo(a['num']));

    return shopMapList;
  }

  ///

  List<Map> productPerShop({required DateTime date}) {
    List<String> shopNames = [];
    List<int> amountList = [];
    List<Transaction> tranList = _allTransactionList
        .where((tran) =>
            tran.sellingDate?.year == date.year &&
            tran.sellingDate?.month == date.month &&
            tran.category == 'income')
        .toList();
    for (var tran in tranList) {
      if (!shopNames.contains(tran.customerName)) {
        shopNames.add(tran.customerName!);
      }
    }

    for (var shopName in shopNames) {
      int amount = 0;
      for (var tran in tranList) {
        if (shopName == tran.customerName) {
          amount += tran.number!;
        }
      }
      amountList.add(amount);
    }

    List<Map> dataList = List.generate(
        shopNames.length,
        (index) => {
              'Name': shopNames[index],
              'Amount': amountList[index],
            });
    dataList.sort((b, a) => a['Amount'].compareTo(b['Amount']));
    return dataList;
  }
}
