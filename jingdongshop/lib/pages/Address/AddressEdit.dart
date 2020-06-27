import 'package:flutter/material.dart';
import '../../components/TextInput/view.dart';
import '../../components/BuyButton.dart';
import '../../config.dart';
import 'package:city_pickers/city_pickers.dart';
import '../../services/UserServices.dart';
import '../../services/SignServices.dart';
import 'package:dio/dio.dart';

class AddressEdit extends StatefulWidget {
  Map arguments;

  AddressEdit({ this.arguments });

  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {

  String area;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    area = '省/市/区';
    nameController.text = widget.arguments['name'];
    phoneController.text = widget.arguments['phone'];
    addressController.text = widget.arguments['address'];
    print(widget.arguments);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('编辑收货地址'),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 10),
          TextInput(
            text: '收货人姓名',
            controller: nameController,
            onChanged: (value){
              nameController.text = value;
            },
          ),
          SizedBox(height: 10),
          TextInput(
            text: '收货人电话',
            controller: phoneController,
            onChanged: (value){
              phoneController.text = value;
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
            controller: addressController,
            onChanged: (value){
              addressController.text = value;
            },
          ),
          SizedBox(height: 30),
          BuyButton(
            color: Colors.red,
            text: '修改',
            callback: () async{
              List userInfo = await UserServices.getUserInfo();

              Map tempJson = {
                "uid": userInfo[0]['_id'],
                "id": widget.arguments["id"],
                "name": nameController.text,
                "phone": phoneController.text,
                "address": this.area,
                "salt": userInfo[0]['salt']
              };

              String url = '${Config.domain}api/editAddress';

              var result = await Dio().post(url, data: {
                "uid": userInfo[0]['_id'],
                "name": nameController.text,
                "phone": phoneController.text,
                "address": this.area,
                "id": widget.arguments["id"],
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

