import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jingdongshop/services/SignServices.dart';
import '../../config.dart';
import '../../services/UserServices.dart';

class AddressList extends StatefulWidget {
  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {

  List addressList = [];

  getAddressList() async{
    List userInfo = await UserServices.getUserInfo();

    Map tempJson = {
      "uid": userInfo[0]['_id'],
      "salt": userInfo[0]['salt']
    };
    
    String sign = SignServies.getSign(tempJson);

    String url = '${Config.domain}api/addressList?uid=${userInfo[0]['_id']}&sign=${sign}';

    var result = await Dio().get(url);

    print("result $result");
    this.setState((){
      this.addressList = result.data['result'];
    });

  }

  alertDelDialog(id) async{
    var result = await showDialog(
      // 点击灰色背景是否弹框消失
        barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text('提示信息'),
            content: Text("您确定要删除嘛？"),
            actions: <Widget>[
              FlatButton(
                child: Text("取消"),
                onPressed: (){
                  print("取消");
                  Navigator.pop(context, "Cancel");
                },
              ),
              FlatButton(
                child: Text("确定"),
                onPressed: () async{
                  List userInfo = await UserServices.getUserInfo();

                  Map tempJson = {
                    "uid": userInfo[0]['_id'],
                    "id": id,
                    "salt": userInfo[0]['salt']
                  };

                  String sign = SignServies.getSign(tempJson);

                  String url = '${Config.domain}api/deleteAddress';

                  var result = await Dio().post(url,data: {
                    "uid": userInfo[0]['_id'],
                    "id": id,
                    "sign": sign
                  });

                  print("result $result");
                  this.getAddressList();
                  Navigator.pop(context, "Ok");
                },
              )
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    this.getAddressList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('收货地址'),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            ListView(
              children: this.addressList.length > 0 ?
                          this.addressList.map((value){
                            return Column(
                              children: <Widget>[
                                ListTile(
                                  leading: value['default_address'] > 0 ? Icon(Icons.check, color: Colors.red) : null,
                                  title: InkWell(
                                    onTap: () async{
                                      List userInfo = await UserServices.getUserInfo();

                                      Map tempJson = {
                                        "uid": userInfo[0]['_id'],
                                        "id": value['_id'],
                                        "salt": userInfo[0]['salt']
                                      };

                                      String url = '${Config.domain}api/changeDefaultAddress';

                                      var result = await Dio().post(url, data: {
                                        "uid": userInfo[0]['_id'],
                                        "id": value['_id'],
                                        "sign": SignServies.getSign(tempJson)
                                      });

                                      print("result $result ${value['_id']}");

                                      if (result.data['success']) {
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${value['name']} ${value['phone']}'),
                                        Text('${value['address']}')
                                      ],
                                    ),
                                  ),
                                  onLongPress: (){
                                    this.alertDelDialog(value['_id']);
                                  },
                                  trailing: IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: (){
                                      Navigator.pushNamed(context, '/addressedit', arguments: {
                                        "id": value["_id"],
                                        "name": value["name"],
                                        "phone": value["phone"],
                                        "address": value['address']
                                      });
                                    },
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          }).toList()
                          :
                          <Widget>[
                              Text('快去添加收获地址吧'),
                          ]
            ),

            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Container(
                color: Colors.red,
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, '/addressadd');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.add, color: Colors.white),
                      Text('增加收货地址', style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

