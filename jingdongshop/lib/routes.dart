import 'package:flutter/material.dart';
import 'package:jingdongshop/pages/Register/RegisterThird.dart';
import 'pages/Tabs/view.dart';
import 'pages/ProductList/view.dart';
import 'pages/Search/view.dart';
import 'pages/ProductDetail/view.dart';
import 'pages/Cart/view.dart';
import 'pages/Login/view.dart';
import 'pages/Register/RegisterFirst.dart';
import 'pages/Register/RegisterSecond.dart';
import 'pages/Checkout/view.dart';
import 'pages/Address/AddressAdd.dart';
import 'pages/Address/AddressEdit.dart';
import 'pages/Address/AddressList.dart';
import 'pages/Pay/view.dart';
import 'pages/Order/view.dart';
import 'pages/OrderInfo/view.dart';

final routes = {
  '/': (context,{arguments}) => Tabs(),
  '/productlist': (context,{arguments}) => ProductListPage(arguments: arguments),
  '/search': (context,{arguments}) => SearchPage(arguments: arguments),
  '/productdetail': (context,{arguments}) => ProductDetailPage(arguments: arguments),
  '/cart': (context,{arguments}) => Cart(),
  '/login': (context,{arguments}) => Login(),
  '/registerfirst': (context,{arguments}) => RegisterFirst(),
  '/registersecond': (context,{arguments}) => RegisterSecond(arguments: arguments),
  '/registerthird': (context,{arguments}) => RegisterThird(arguments: arguments),
  '/checkout': (context,{arguments}) => Checkout(arguments: arguments),
  '/addressadd': (context,{arguments}) => AddressAdd(),
  '/addressedit': (context,{arguments}) => AddressEdit(arguments: arguments),
  '/addresslist': (context,{arguments}) => AddressList(),
  '/pay': (context,{arguments}) => Pay(),
  '/order': (context,{arguments}) => OrderPage(),
  '/orderinfo': (context,{arguments}) => OrderInfo(arguments: arguments),
};

var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(
          builder: (context) => pageContentBuilder(context)
      );
      return route;
    }
  }
};
