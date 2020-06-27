import 'package:flutter/material.dart';
import '../../components/TextInput/view.dart';
import '../../components/BuyButton.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterSecond extends StatefulWidget {

  Map arguments;

  RegisterSecond({ this.arguments });
  @override
  _RegisterSecondState createState() => _RegisterSecondState();
}

class _RegisterSecondState extends State<RegisterSecond> {

  bool sendCodeBtn = false;
  int seconds = 10;
  String code;

  showTimer() {
    Timer timer = Timer.periodic(Duration(milliseconds: 1000), (t){
      setState(() {
        this.seconds--;
      });
      if(this.seconds == 0) {
        t.cancel();
        this.setState((){
          this.sendCodeBtn = true;
        });
      }
    });
  }

  sendCode() async{
    String url = 'http://jd.itying.com/api/sendCode';
    var response = await Dio().post(url, data: { "tel": widget.arguments['tel'] } );
    if (response.data['success']) {
      setState(() {
        this.sendCodeBtn = false;
        this.seconds = 10;
        this.code = response.data['code'];
        this.showTimer();
      });
    } else {
      Fluttertoast.showToast(msg: response.data['message'], gravity: ToastGravity.CENTER);
    }
  }

  validateCode() async{
    String url = 'http://jd.itying.com/api/validateCode';
    var response = await Dio().post(url, data: { "tel": widget.arguments['tel'], "code": this.code } );
    if(response.data['success']){
        Navigator.pushNamed(context, '/registerthird', arguments: {
          "tel": widget.arguments['tel'],
          "code": this.code
        });
    } else {
      Fluttertoast.showToast(msg: "${response.data['message']}", gravity: ToastGravity.CENTER);
    }
  }

  @override
  void initState() {
    super.initState();
    this.code = widget.arguments['code'];
    this.showTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户注册-第二步'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Stack(
            children: <Widget>[
              TextInput(
                text: "请输入验证码",
                onChanged: (value){

                },
              ),
              Positioned(
                right: 0,
                child: this.sendCodeBtn ? RaisedButton(
                  child: Text('发送验证码'),
                  onPressed: (){
                    this.sendCode();
                  },
                )
                    :
                RaisedButton(
                  child: Text('${this.seconds}秒后重发'),
                  onPressed: (){

                  },
                )
              )
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 30,right: 30),
            child: BuyButton(
              text: "下一步",
              color: Colors.red,
              callback: (){
                this.validateCode();
              },
            ),
          )
        ],
      ),
    );
  }
}
