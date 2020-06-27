import 'package:flutter/material.dart';
import '../services/Storage.dart';
import 'dart:convert';

class CartProviderClass with ChangeNotifier{
  List cartList = [];
  int cartNum = 0;
  bool isCheckAll = false;
  double allPrice = 0;

  List get getCartList => this.cartList;
  int get getCartNum => this.cartList.length;
  bool get getIsCheckAll => this.isCheckAll;
  double get getAllPrice => this.allPrice;

  CartProviderClass(){
    localCartList();
    computerAllPrice();
  }

  upldateLocal() async{
    localCartList();
  }

  localCartList() async{
    try{
      List cartListData = json.decode(await localStorage.getItem("cartList"));
      this.cartList = cartListData;
    }catch(e){
      cartList = [];
    }
    notifyListeners();
  }

  changeItemCount() {
    this.isCheckAll = this.hasCheckAll();
    computerAllPrice();
    localStorage.setItem('cartList', json.encode(this.cartList));
    notifyListeners();
  }

  checkAll(value){
    if (this.cartList.length > 0) {
      this.cartList.forEach((item){
        item['checked'] = value;
      });
      this.isCheckAll = value;
      localStorage.setItem('cartList', json.encode(this.cartList));
      computerAllPrice();
      notifyListeners();
    }
  }

  bool hasCheckAll(){
    if (this.cartList.length > 0) {
      bool hasCart = this.cartList.any((item) => (item['checked'] == false));
      return !hasCart;
    }
    return false;
  }

  computerAllPrice(){
    double price = 0;
    this.cartList.forEach((value){
      if (value['checked']) {
        price = price + value['price'] * value['count'];
      }
    });
    this.allPrice = price;
    notifyListeners();
  }

  removeItem() async{
    List tempList = [];
    this.cartList.forEach((value){
      if (!value['checked']) {
        tempList.add(value);
      }
    });
    this.cartList = tempList;
    await localStorage.setItem('cartList', json.encode(this.cartList));
    this.computerAllPrice();
    localCartList();
  }
}