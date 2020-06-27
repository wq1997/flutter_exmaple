import 'dart:convert';
import 'package:flutter/material.dart';
import '../../components/TextInput/view.dart';
import '../../components/BuyButton.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/Storage.dart';

class RegisterThird extends StatefulWidget {
  Map arguments;
  RegisterThird({this.arguments});

  @override
  _RegisterThirdState createState() => _RegisterThirdState();
}

class _RegisterThirdState extends State<RegisterThird> {

  String password;
  String rPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册-第三步'),
      ),
      body: ListView(
        children: <Widget>[
          TextInput(
            text: "请输入密码",
            onChanged: (value){
              this.password = value;
            },
          ),
          TextInput(
            text: "确认密码",
            onChanged: (value){
              this.rPassword = value;
            },
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: BuyButton(
              text: "注册",
              color: Colors.red,
              callback: () async{
                if (this.password == this.rPassword) {
                  String url = 'http://jd.itying.com/api/register';
                  var response = await Dio().post(url, data: {
                    "tel": widget.arguments['tel'],
                    "code": widget.arguments['code'],
                    "password": this.password
                  } );
                  if(response.data['success']){
                    print("response ${response.data}");
                    localStorage.setItem('userinfo', json.encode(response.data['userinfo']));
                    Navigator.pushNamed(context, '/');
                  } else {
                    Fluttertoast.showToast(msg: "${response.data['message']}", gravity: ToastGravity.CENTER);
                  }
                } else {
                  Fluttertoast.showToast(msg: "两次密码不一致,请重新输入", gravity: ToastGravity.CENTER);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
