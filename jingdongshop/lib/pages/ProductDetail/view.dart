import 'package:flutter/material.dart';
import '../../components/ProductDetail/ProductDetailFirst.dart';
import '../../components/ProductDetail/ProductDetailSecond.dart';
import '../../components/ProductDetail/ProductDetailThird.dart';
import '../../components/BuyButton.dart';
import '../../components/Loading/view.dart';
import '../../model/ProductDetailModel.dart';
import 'package:dio/dio.dart';
import '../../services/EventBus.dart';
import '../../config.dart';

class ProductDetailPage extends StatefulWidget {
  Map arguments;
  ProductDetailPage({this.arguments});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  var productDetailData;

  @override
  void initState() {
    super.initState();
    this.getProductDetail();
  }

  getProductDetail() async{
    String url = '${Config.domain}api/pcontent?id=${widget.arguments["id"]}';
    var result = await Dio().get(url);
    var productDetailData = ProductDetailModel.fromJson(result.data);
    this.setState((){
      this.productDetailData = productDetailData.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.arguments['id']);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            indicatorColor: Colors.red,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: <Widget>[
              Tab(
                child: Text('商品'),
              ),
              Tab(
                child: Text('详情'),
              ),Tab(
                child: Text('评价'),
              )
            ],
          ),
          actions: <Widget>[
            PopupMenuButton(
                offset: Offset(0,100),
                icon: Icon(Icons.more_horiz),
                onSelected: (String value) {
                  print("value $value");
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.home, color: Colors.black54,),
                        Text('首页')
                      ],
                    ),
                    value: 'home',
                  ),
                  PopupMenuItem(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(Icons.search, color: Colors.black54,),
                        Text('搜索')
                      ],
                    ),
                    value: 'search',
                  )
                ])
          ],
        ),
        body: this.productDetailData != null ?
                  Stack(
                    children: <Widget>[
                      TabBarView(
                        children: <Widget>[
                          ProductDetailFirst(this.productDetailData),
                          ProductDetailSecond(this.productDetailData),
                          ProductDetailThird()
                        ],
                      ),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.black12,
                                      width: 1
                                  )
                              )
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 100,
                                height: 40,
                                child: InkWell(
                                  onTap: (){
                                    Navigator.pushNamed(context, '/cart');
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Icon(Icons.shopping_cart,size: 20,),
                                      Text(
                                        '购物车',
                                        style: TextStyle(
                                            fontSize: 12
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: BuyButton(
                                  color: Color.fromRGBO(253, 1, 0, 0.9),
                                  text: "加入购物车",
                                  callback: (){
                                    print('加入购物车');

                                    // 广播
                                    eventBus.fire(ProductDetailEvent('加入购物车'));
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: BuyButton(
                                  color: Color.fromRGBO(255, 165, 0, 0.9),
                                  text: "立即购买",
                                  callback: (){
                                    eventBus.fire(ProductDetailEvent('立即购买'));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                  :
                  Loading()
        ,
      ),
    );
  }
}
