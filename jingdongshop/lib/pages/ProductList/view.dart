import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/sreenAdaper.dart';
import '../../model/ProductModel.dart';
import 'package:dio/dio.dart';
import '../../config.dart';
import '../../components/Loading/view.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;
  ProductListPage({this.arguments});
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List topTabBarName = [
    {
      "id": 1,
      "title": '综合',
      "fields": 'all',
      "sort": -1
    },
    {
      "id": 2,
      "title": '销量',
      "fields": 'salecount',
      "sort": -1
    },
    {
      "id": 3,
      "title": '价格',
      "fields": 'price',
      "sort": -1
    },
    {
      "id": 4,
      "title": '筛选',
    }
  ];

  ScrollController scrollController = ScrollController();

  int currentIndex = 1;

  int page = 1;

  List productList = [];

  String sort = "";

  var initKeyWordsController = TextEditingController();

  String keyWords = "";

  Widget produceWiget() {
    if (this.productList.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 40),
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            controller: scrollController,
            itemCount: this.productList.length,
            itemBuilder: (context, index){
              return Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: Image.network(
                          "${Config.domain}${this.productList[index].pic.replaceAll('\\', '/')}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 100,
                          margin: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                this.productList[index].title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color.fromRGBO(230, 230, 230, 0.9)
                                    ),
                                    child: Text('4G'),
                                  )
                                ],
                              ),
                              Text(
                                "￥${this.productList[index].price}",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider()
                ],
              );
            }
        ),
      );
    } else {
      return Center(
        child: Text('没有您想要的数据...'),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getProductList();
    
    scrollController.addListener((){
       if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          getProductList();
       }
    });

    this.keyWords = widget.arguments['search'];

    // 给search初始值
    widget.arguments['search'] == null ?
        initKeyWordsController.text = ""
        :
        initKeyWordsController.text = widget.arguments["search"];
  }

  // 获取商品列表的数据
  getProductList() async{
    String url = "";

    if (widget.arguments['search'] == null) {
      url = '${Config.domain}api/plist?cid=${widget.arguments["cid"]}&page=${this.page}&sort=${this.sort}';
    } else {
      url = '${Config.domain}api/plist?search=${this.keyWords}&page=${this.page}&sort=${this.sort}';
    }

    var foucsData = await Dio().get(url);
    var foucsDataList = ProductModel.fromJson(foucsData.data);
    if (foucsDataList.result.length > 0) {
      this.setState(() {
        this.productList.addAll(foucsDataList.result);
        this.page++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Container(
          height: 30,
          decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(30)
          ),
          child: TextField(
            controller: this.initKeyWordsController,
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
              this.currentIndex = 1;
              this.page = 1;
              this.productList = [];

              // 回到顶部
              scrollController.jumpTo(0);

              this.getProductList();
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
      endDrawer: Drawer(
        child: Container(
          child: Text("实现筛选功能"),
        ),
      ),
      body: Stack(
        children: <Widget>[
          produceWiget(),
          Positioned(
            top: 0,
            height: 40,
            width: ScreenAdaper.setWidth(750),
            child: Container(
              height: 40,
              width: ScreenAdaper.setWidth(750),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Color.fromRGBO(233, 233, 233, 0.9)
                  )
                )
              ),
              child: Row(
                children: topTabBarName.map((value){
                  return Expanded(
                    flex: 1,
                    child: InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              value['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: this.currentIndex == value['id'] ? Colors.red: Colors.black,
                              ),
                            ),
                            value['id'] != 4 &&  value['id'] != 1 ?
                              Icon(
                                  value['sort'] > 0 ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                  color: this.currentIndex == value['id'] ? Colors.red: Colors.black
                              )
                                :
                                Text("")
                          ],
                        ),
                      ),
                      onTap: (){
                        if (value['id'] == 4) {
                          scaffoldKey.currentState.openEndDrawer();
                        } else {
                          this.setState((){
                            this.currentIndex = value['id'];
                            this.sort = "${value['fields']}_${value['sort']}";
                            this.page = 1;
                            this.productList = [];
                            value['sort'] = value['sort'] * (-1);

                            // 回到顶部
                            scrollController.jumpTo(0);

                            this.getProductList();
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
