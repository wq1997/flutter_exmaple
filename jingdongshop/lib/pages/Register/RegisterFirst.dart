import 'package:flutter/material.dart';
import '../../components/TextInput/view.dart';
import '../../components/BuyButton.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFirst extends StatefulWidget {
  @override
  _RegisterFirstState createState() => _RegisterFirstState();
}

class _RegisterFirstState extends State<RegisterFirst> {

  String tel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册-第一步'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          TextInput(
            text: "请输入手机号",
            onChanged: (value){
              this.tel = value;
            },
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: BuyButton(
              text: "下一步",
              color: Colors.red,
              callback: () async {
                  RegExp reg = new RegExp(r"^1\d{10}$");
                  String url = 'http://jd.itying.com/api/sendCode';
                  if(reg.hasMatch(this.tel)){
                    var response = await Dio().post(url, data: { "tel": this.tel } );
                    print('response ${response}');
                    if (response.data['success']) {
                      Fluttertoast.showToast(msg: response.data['message'], gravity: ToastGravity.CENTER);
                      Navigator.pushNamed(context, '/registersecond', arguments: {
                        "tel": this.tel,
                        "code": response.data['code']
                      });
                    } else {
                      Fluttertoast.showToast(msg: response.data['message'], gravity: ToastGravity.CENTER);
                    }
                  } else {
                    Fluttertoast.showToast(msg: '请输入正确的手机号',gravity: ToastGravity.CENTER);
                  }
              },
            ),
          )
        ],
      ),
    );
  }
}
