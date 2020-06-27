import 'package:flutter/material.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:jingdongshop/pages/User/view.dart';
import '../../components/TextInput/view.dart';
import '../../components/BuyButton.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../services/UserServices.dart';
import '../../services/SignServices.dart';
import 'package:dio/dio.dart';
import '../../config.dart';

class AddressAdd extends StatefulWidget {
  @override
  _AddressAddState createState() => _AddressAddState();
}

class _AddressAddState extends State<AddressAdd> {

  String area;

  String name;

  String phone;

  String address;

  @override
  void initState() {
    super.initState();
    area = '省/市/区';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('增加收货地址'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10),
          TextInput(
            text: '收货人姓名',
            onChanged: (value){
              this.name = value;
            },
          ),
          SizedBox(height: 10),
          TextInput(
            text: '收货人电话',
            onChanged: (value){
              this.phone = value;
            },
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.black12
                )
              )
            ),
            child: InkWell(
              onTap: () async{
                Result result = await CityPickers.showCityPicker(
                    context: context,
                    cancelWidget: Text('取消',style: TextStyle(color: Colors.black)),
                    confirmWidget: Text('确定',style: TextStyle(color: Colors.black))
                );
                print("result $result");
                setState(() {
                  this.area = '${result.provinceName}/${result.cityName}/${result.areaName}';
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.add_location),
                  Text(this.area, style: TextStyle(color: Colors.black54))
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          TextInput(
            text: '详细地址',
            maxLength: 4,
            height: 120,
            onChanged: (value){
              this.address = "${this.area} ${value}";
            },
          ),
          SizedBox(height: 30),
          BuyButton(
            color: Colors.red,
            text: '增加',
            callback: () async{
              List userInfo = await UserServices.getUserInfo();

              Map tempJson = {
                "uid": userInfo[0]['_id'],
                "name": this.name,
                "phone": this.phone,
                "address": this.address,
                "salt": userInfo[0]['salt']
              };

              String url = '${Config.domain}api/addAddress';

              var result = await Dio().post(url, data: {
                "uid": userInfo[0]['_id'],
                "name": this.name,
                "phone": this.phone,
                "address": this.address,
                "sign": SignServies.getSign(tempJson)
              });

              print("result $result");

              if (result.data['success']) {
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}

