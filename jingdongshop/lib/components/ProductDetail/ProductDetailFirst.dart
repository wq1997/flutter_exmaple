import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../BuyButton.dart';
import '../../config.dart';
import '../../services/EventBus.dart';
import '../../services/CartServices.dart';
import '../../provider/CartProvider.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailFirst extends StatefulWidget {

  var productDetailData;
  ProductDetailFirst(this.productDetailData);

  @override
  _ProductDetailFirstState createState() => _ProductDetailFirstState();
}

class _ProductDetailFirstState extends State<ProductDetailFirst> with AutomaticKeepAliveClientMixin{

  bool get wantKeepAlive => true;

  var eventAction;

  initAttr() {
    widget.productDetailData.attr.forEach((value){
      value.list.asMap().keys.forEach((index){
        value.attrList.add(
          {
            "title": value.list[index],
            "checked": index == 0
          }
        );
      });
    });
    this.setState((){
      getSelectedValue();
    });

    // 监听ProductDetailEvent广播
    this.eventAction = eventBus.on<ProductDetailEvent>().listen((event){
      print("event ${event.str}");
      this.attrBottomSheet();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // 取消事件监听
    this.eventAction.cancel();
  }

  changeAttr(cate, title, setBottomState) {
    widget.productDetailData.attr.forEach((value){
      if (value.cate == cate) {
        value.attrList.forEach((item){
          if(item['title'] == title){
            item['checked'] = true;
          } else {
            item['checked'] = false;
          }
        });
      }
    });
    this.getSelectedValue();
    setBottomState((){});
  }

  // 获取选中的值
  getSelectedValue(){
    List tempArr = [];
    widget.productDetailData.attr.forEach((value){
        value.attrList.forEach((item){
         if (item['checked']) {
           tempArr.add(item['title']);
         }
        });
    });
    setState(() {});
    widget.productDetailData.selectedAttr = tempArr.join(',');
    return tempArr.join(',');
  }


  List getAttrItemWiget(value, setBottomState) {
    List<Widget> attrItemList = [];
    value.attrList.forEach((item){
      attrItemList.add(
          Container(
            margin: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                changeAttr(value.cate, item['title'], setBottomState);
              },
              child: Chip(
                backgroundColor: item['checked']?Colors.red:Colors.black12,
                label: Text(
                    "${item['title']}"
                ),
              ),
            ),
          )
      );
    });
    return attrItemList;
  }

  List<Widget> getAttrWiget(setBottomState) {
    List<Widget> attrList = [];
    widget.productDetailData.attr.forEach((value){
      attrList.add(
          Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 12, left: 10),
                child: Text(
                  "${value.cate}：",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Wrap(
                children: this.getAttrItemWiget(value,setBottomState),
              )
            ],
          )
      );
    });

    return attrList;
  }

  attrBottomSheet() {
    var CartProvider = Provider.of<CartProviderClass>(context);
    showModalBottomSheet(
        context: context,
        builder: (context){
          return StatefulBuilder(
            builder: (BuildContext buildContext, setBottomState){
              return Stack(
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: this.getAttrWiget(setBottomState),
                      ),
                      Divider(),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 10),
                          Text(
                            '数量：',
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.black12
                                )
                            ),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: (){
                                    setBottomState(() {
                                      widget.productDetailData.count--;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 30,
                                    child: Text(
                                        '-'
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 55,
                                  height: 30,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1,
                                              color: Colors.black12
                                          ),
                                          left: BorderSide(
                                              width: 1,
                                              color: Colors.black12
                                          )
                                      )
                                  ),
                                  child: Text(
                                      "${widget.productDetailData.count}"
                                  ),
                                ),
                                InkWell(
                                  onTap: (){
                                      setBottomState(() {
                                        widget.productDetailData.count++;
                                      });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 30,
                                    child: Text(
                                        '+'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: BuyButton(
                            color: Color.fromRGBO(253, 1, 0, 0.9),
                            text: "加入购物车",
                            callback: ()async{
                              print('加入购物车');
                              await CartServices.addCart(widget.productDetailData);
                              CartProvider.localCartList();
                              Fluttertoast.showToast(
                                  msg: '添加购物车成功',
                                  gravity: ToastGravity.CENTER
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: BuyButton(
                            color: Color.fromRGBO(255, 165, 0, 0.9),
                            text: "立即购买",
                            callback: (){
                              print('立即购买');
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    initAttr();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 40),
      child: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16/15,
            child: Image.network(
              "${Config.domain}${widget.productDetailData.pic.replaceAll('\\', '/')}",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
                widget.productDetailData.title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20
                ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              "${widget.productDetailData.subTitle}",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 15
              ),
            ),
          ),

          // 价格
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text(
                        "现价："
                      ),
                      Text(
                        "￥${widget.productDetailData.salecount}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                          "原价："
                      ),
                      Text(
                        "￥${widget.productDetailData.oldPrice}",
                        style: TextStyle(
                            color: Colors.black87,
                            decoration: TextDecoration.lineThrough
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: (){
                attrBottomSheet();
              },
              child: Row(
                children: <Widget>[
                  Text(
                    "已选：",
                    style: TextStyle(
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(getSelectedValue()),
                ],
              ),
            ),
          ),
          Divider(),


          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Text(
                  "运费：",
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(width: 10),
                Text("免运费"),
              ],
            ),
          ),
          Divider()

        ],
      ),
    );
  }
}
