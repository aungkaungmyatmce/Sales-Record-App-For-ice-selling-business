import 'package:flutter/material.dart';

class DateAndTabIndex with ChangeNotifier {
  DateTime _date = DateTime.now();
  int _tabIndex = 0;
  DateTime get date {
    return _date;
  }

  int get tabIndex {
    return _tabIndex;
  }

  void setDate(DateTime d) {
    _date = d;
    notifyListeners();
  }

  void setTabIndex(int i) {
    _tabIndex = i;
  }
}
