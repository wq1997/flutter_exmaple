import 'package:flutter/material.dart';
import '../../components/BuyButton.dart';

class Pay extends StatefulWidget {
  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('支付'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 400,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10),
                ListTile(
                  leading: Image.network("https://www.itying.com/themes/itying/images/alipay.png"),
                  title: Text('支付宝支付')
                ),
                Divider(),
                ListTile(
                  leading: Image.network("https://www.itying.com/themes/itying/images/weixinpay.png"),
                  title: Text('微信支付'),
                  trailing: Icon(Icons.check, color: Colors.red),
                )
              ],
            ),
          ),

          SizedBox(
            height: 10,
          ),

          BuyButton(
            color: Colors.red,
            text: '支付',
            callback: (){

            },
          )
        ],
      ),
    );
  }
}
