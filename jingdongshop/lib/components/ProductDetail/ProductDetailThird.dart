import 'package:flutter/material.dart';

class ProductDetailThird extends StatefulWidget {
  @override
  _ProductDetailThirdState createState() => _ProductDetailThirdState();
}

class _ProductDetailThirdState extends State<ProductDetailThird> with AutomaticKeepAliveClientMixin{
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('详情页面'),
    );
  }
}
