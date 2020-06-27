import 'package:flutter/material.dart';
import '../../config.dart';

class OrderInfo extends StatefulWidget {
  Map arguments;
  OrderInfo({this.arguments});
  @override
  _OrderInfoState createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单详情'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.add_location),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("王清 13955415175"),
                    Text('上海市')
                  ],
                )
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 60,
                        child: Image.network(
//                          "${Config.domain}${value['pic'].replaceAll('\\', '/')}",
                          "https://www.itying.com/images/flutter/list2.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
//                                '${value['title']}',
                                "王清最帅",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
//                                      "￥${value['price']}",
                                      "￥22.00",
                                      style: TextStyle(
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 55,
                                      height: 30,
                                      alignment: Alignment.center,
                                      child: Text(
//                                          "X ${value['count']}"
                                            "X 2"
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
