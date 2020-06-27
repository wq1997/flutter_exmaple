import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的订单'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            child: ListView(
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("订单编号：XXXXXXXXXXXX"),
                      ),
                      ListTile(
                        leading: Container(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            "https://www.itying.com/images/flutter/list2.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text("6小时学会TypeScript教程"),
                        trailing: Text("X1"),
                        onTap: (){
                          Navigator.pushNamed(context, '/orderinfo');
                        },
                      ),
                      ListTile(
                        leading: Text("合计：￥345.00"),
                        trailing: FlatButton(
                          child: Text('申请售后'),
                          onPressed: (){
                            print('申请售后');
                          },
                          color: Colors.grey[100],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            height: 40,
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('全部', textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('待付款', textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('待收货', textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('已完成', textAlign: TextAlign.center,),
                  ),
                  Expanded(
                    child: Text('已取消', textAlign: TextAlign.center,),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
