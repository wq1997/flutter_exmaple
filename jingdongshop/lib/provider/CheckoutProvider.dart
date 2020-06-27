import 'package:flutter/material.dart';

class CheckoutProviderClass with ChangeNotifier{
  List checkOutList = [];

  List get getCheckOutList => this.checkOutList;

  changeCheckOutList(data){
    this.checkOutList = data;
    notifyListeners();
  }
}