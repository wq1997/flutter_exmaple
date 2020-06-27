import 'package:flutter/material.dart';
import '../../components/TextInput/view.dart';
import '../../components/BuyButton.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/Storage.dart';
import 'dart:convert';
import '../../services/EventBus.dart';
import 'package:event_bus/event_bus.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('客服'),
            onPressed: (){
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10),

          TextInput(
            text: "请输入用户名",
            onChanged: (value){
              this.username = value;
            },
          ),

          SizedBox(
            height: 20,
          ),
          TextInput(
            text: "请输入密码",
            onChanged: (value){
              this.password = value;
            },
          ),

          SizedBox(height: 10),

          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('忘记密码'),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/registerfirst');
                    },
                    child: Text('新用户注册'),
                  ),
                )
              ],
            ),
          ),

          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: BuyButton(
              text: "登录",
              color: Colors.red,
              callback: () async{
                String url = 'http://jd.itying.com/api/doLogin';
                var response = await Dio().post(url, data: {
                  "username": this.username,
                  "password": this.password
                });
                if(response.data['success']){
                  print("response ${response.data}");
                  await localStorage.setItem('userinfo', json.encode(response.data['userinfo']));
                  eventBus.fire(LoginEvent('登录成功'));
                  Navigator.pop(context);
                } else {
                  Fluttertoast.showToast(msg: "${response.data['message']}", gravity: ToastGravity.CENTER);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
