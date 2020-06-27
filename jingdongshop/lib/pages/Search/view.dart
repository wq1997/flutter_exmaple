import 'package:flutter/material.dart';
import '../../services/SearchServices.dart';

class SearchPage extends StatefulWidget {
  Map arguments;
  SearchPage({this.arguments});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var keyWords = "";

  List historyListData = [];

  @override
  void initState() {
    super.initState();
    this.getHistoryData();
  }

  getHistoryData() async{
    this.historyListData = await SearchServices.getSearchList();
    this.setState((){});
  }

  alertDialog(value) async{
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
                  print("确定");
                  await SearchServices.removeSearchData(value);
                  this.getHistoryData();
                  Navigator.pop(context, "Ok");
                },
              )
            ],
          );
        }
    );
  }

  getHistoryWiget () {
    return Column(
      children: this.historyListData.map((value){
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(value),
              onLongPress: () {
                this.alertDialog(value);
              },
            ),
            Divider()
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: 30,
            decoration: BoxDecoration(
                color: Color.fromRGBO(233, 233, 233, 0.8),
                borderRadius: BorderRadius.circular(30)
            ),
            child: TextField(
              autofocus: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30)
                )
              ),
              onChanged: (value){
                this.keyWords = value;
              },
            ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: (){
                SearchServices.setSearchData(this.keyWords);
                Navigator.pushReplacementNamed(context, '/productlist', arguments: {
                  "search": this.keyWords
                });
            },
            child: Container(
              width: 40,
              child: Row(
                children: <Widget>[
                  Text("搜索")
                ],
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(
                '热搜',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Divider(),
            Wrap(
              children: <Widget>[
                Container(
                  child: Text('女装'),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(233, 233, 233, 0.9),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            Container(
              child: Text(
                '历史搜索',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            Divider(),
            this.getHistoryWiget(),

            SizedBox(height: 100),

            OutlineButton(
              child: Text('清空历史记录'),
              onPressed: () async{
                await SearchServices.clearSearchList();
                this.getHistoryData();
              },
            )
          ],
        ),
      ),
    );
  }
}
