import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config.dart';
import '../../provider/CheckoutProvider.dart';
import 'package:dio/dio.dart';
import '../../services/UserServices.dart';
import '../../services/SignServices.dart';

class Checkout extends StatefulWidget {

  Map arguments;

  Checkout({ this.arguments });

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {

  Map defaultAddress;

  getDefaultAddress() async{

    List userInfo = await UserServices.getUserInfo();

    Map tempJson = {
      "uid": userInfo[0]['_id'],
      "salt": userInfo[0]['salt']
    };

    String url = '${Config.domain}api/oneAddressList?uid=${userInfo[0]['_id']}&sign=${SignServies.getSign(tempJson)}';

    var response = await Dio().get(url);

    print("response ${response}");

    this.setState((){
      this.defaultAddress = response.data['result'][0];
    });
  }

  Widget checkOutItem(value){
    return Row(
      children: <Widget>[
        SizedBox(
          width: 10,
        ),
        Container(
          width: 60,
          child: Image.network(
            "${Config.domain}${value['pic'].replaceAll('\\', '/')}",
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${value['title']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "￥${value['price']}",
                        style: TextStyle(
                            color: Colors.red
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 55,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                            "X ${value['count']}"
                        ),
                      ),
                    )
                  ],
                ),
                Divider()
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    this.getDefaultAddress();
  }

  @override
  Widget build(BuildContext context) {
    var CheckProvider = Provider.of<CheckoutProviderClass>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('结算'),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[

                    SizedBox(
                      height: 10,
                    ),

                    this.defaultAddress != null ?

                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("${this.defaultAddress['name']} ${this.defaultAddress['phone']}"),
                            Text('${this.defaultAddress['address']}')
                          ],
                        ),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          Navigator.pushNamed(context, '/addresslist');
                        },
                      )
                      :
                      ListTile(
                        leading: Icon(Icons.add_location),
                        title: Text('请添加收货地址'),
                        trailing: Icon(Icons.navigate_next),
                        onTap: (){
                          Navigator.pushNamed(context, '/addresslist');
                        },
                      )
                  ],
                ),
              ),

              SizedBox(height: 20),

              Container(
                child: Column(
                  children: CheckProvider.getCheckOutList.map((value){
                    return checkOutItem(value);
                  }).toList(),
                ),
              ),

              SizedBox(height: 20),

              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("商品总金额：￥100"),
                    Divider(),
                    Text('立减：￥5'),
                    Divider(),
                    Text('运费：￥0')
                  ],
                ),
              )
            ],
          ),

          Positioned(
            bottom: 0,
            height: 40,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 40,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("总价：￥140", style: TextStyle(color: Colors.red)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: RaisedButton(
                      child: Text('立即下单', style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      onPressed: () async{
                        List userInfo = await UserServices.getUserInfo();
                        double all_price = 0 ;
                        CheckProvider.getCheckOutList.forEach((value){
                          all_price += value['price'] * value['count'];
                        });
                        print("all_price $all_price");

                        var sign = SignServies.getSign({
                          "uid": userInfo[0]['_id'],
                          "salt": userInfo[0]['salt'],
                          "address": this.defaultAddress['address'],
                          "phone": this.defaultAddress['phone'],
                          "name": this.defaultAddress['name'],
                          "all_price": all_price.toStringAsFixed(1),
                          "products": json.encode(CheckProvider.getCheckOutList)
                        });

                        String url = '${Config.domain}api/doOrder';

                        var response = await Dio().post(url, data: {
                          "uid": userInfo[0]['_id'],
                          "sign": sign,
                          "address": this.defaultAddress['address'],
                          "phone": this.defaultAddress['phone'],
                          "name": this.defaultAddress['name'],
                          "all_price": all_price.toStringAsFixed(1),
                          "products": json.encode(CheckProvider.getCheckOutList)
                        });

                        print("response ${response}");

                        if (response.data["success"]) {
                          Navigator.pushNamed(context, '/pay');
                        }
                      },
                    ),
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
