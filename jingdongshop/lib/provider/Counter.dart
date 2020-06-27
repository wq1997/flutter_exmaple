import 'package:flutter/material.dart';

class Counter with ChangeNotifier{
  int count = 1;

  int get getCount => count; // 获取状态

  incCount(count) {
    this.count = count;
    notifyListeners();  // 表示更新状态
  }
}