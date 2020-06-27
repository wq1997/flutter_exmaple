import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../model/CategoryModel.dart';
import '../../config.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> with AutomaticKeepAliveClientMixin{
  int selectIndex = 0;

  List categoryLeftData = [];
  List categoryRightData = [];

  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getLeftData();
  }

  getLeftData() async{
    var foucsData = await Dio().get('${Config.domain}api/pcate');
    var foucsDataList = CategoryModel.fromJson(foucsData.data);
    this.setState(() {
      this.categoryLeftData = foucsDataList.result;
    });
    getRightData(foucsDataList.result[0].sId);
  }

  getRightData(pid) async{
    var foucsData = await Dio().get('${Config.domain}api/pcate?pid=${pid}');
    var foucsDataList = CategoryModel.fromJson(foucsData.data);
    this.setState(() {
      this.categoryRightData = foucsDataList.result;
    });
  }

  leftWiget() {
    return Container(
      width: 70,
      height: double.infinity,
      child: ListView.builder(
          itemCount: this.categoryLeftData.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                InkWell(
                  onTap: (){
                    getRightData(this.categoryLeftData[index].sId);
                    this.setState((){
                      this.selectIndex = index;
                    });
                  },
                  child: Container(
                    child: Text(
                      '${this.categoryLeftData[index].title}',
                    ),
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    color: this.selectIndex == index ? Color.fromRGBO(240, 246, 246, 0.9) : Colors.white,
                  ),
                ),
                Divider(
                    height: 1
                )
              ],
            );
          }
      ),
    );
  }

  rightWiget() {
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(10),
        height: double.infinity,
        color: Color.fromRGBO(240, 246, 246, 0.9),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1/1.2
            ),
            itemCount: this.categoryRightData.length,
            itemBuilder: (context, index){
              return InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/productlist', arguments: {
                    "cid": this.categoryRightData[index].sId
                  });
                },
                child: Container(
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1/1,
                        child: Image.network(
                          "${Config.domain}${this.categoryRightData[index].pic.replaceAll('\\', '/')}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        child: Text(this.categoryRightData[index].title),
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.center_focus_weak),
          onPressed: null,
        ),
        title: InkWell(
          onTap: (){
            Navigator.pushNamed(context, '/search');
          },
          child: Container(
            padding: EdgeInsets.all(7),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                Text(
                  "笔记本",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 17
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(30)
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.message),
          )
        ],
      ),
      body: Row(
        children: <Widget>[
          leftWiget(),
          rightWiget()
        ],
      ),
    );
  }
}
