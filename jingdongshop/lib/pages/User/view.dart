import 'package:flutter/material.dart';
import '../../services/UserServices.dart';
import '../../components/BuyButton.dart';
import 'package:event_bus/event_bus.dart';
import '../../services/EventBus.dart';

class User extends StatefulWidget {
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> with AutomaticKeepAliveClientMixin{

  bool isLogin = false;

  List userInfo = [];

  bool get wantKeepAlive => true;

  getUserInfo() async{
      bool isLogin = await UserServices.getUserLoginState();
      List userInfo = await UserServices.getUserInfo();

      setState(() {
        this.isLogin = isLogin;
        this.userInfo = userInfo;
      });
  }

  @override
  void initState() {
    super.initState();
    this.getUserInfo();

    eventBus.on<LoginEvent>().listen((e){
      this.getUserInfo();
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  image: DecorationImage(
                  image: AssetImage('images/user_bg.jpg'),
                  fit: BoxFit.cover
                )
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: ClipOval(
                      child: Image.asset(
                          'images/user.png',
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                      )
                    ),
                  ),
                  this.isLogin ?
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            "用户名：${this.userInfo[0]['username']}",
                            style: TextStyle(
                                color: Colors.white
                            )
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                            '普通会员',
                            style: TextStyle(
                                color: Colors.white
                            )
                        )
                      ],
                    ),
                  )
                      :
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        '登录/注册',
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            ListTile(
              leading: Icon(Icons.home, color: Colors.red),
              title: Text('订单列表'),
              onTap: (){
                Navigator.pushNamed(context, '/order');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.search, color: Colors.blue),
              title: Text('已付款'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('待付款'),
            ),

            Container(
              height: 20,
              width: double.infinity,
              color: Colors.black12,
            ),

            ListTile(
              leading: Icon(Icons.home, color: Colors.red),
              title: Text('订单列表'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.search, color: Colors.blue),
              title: Text('已付款'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('待付款'),
            ),

            this.isLogin ?
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 20),
                  child: BuyButton(
                    text: '退出登录',
                    color: Colors.red,
                    callback: () async{
                      await UserServices.loginOut();
                      this.getUserInfo();
                    },
                  ),
                )
                :
                Text('')
          ],
        ),
      ),
    );
  }
}
