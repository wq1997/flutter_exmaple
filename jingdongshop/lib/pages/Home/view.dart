import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../services/sreenAdaper.dart';
import '../../model/FoucsModel.dart';
import '../../model/ProductModel.dart';
import '../../config.dart';
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin{

  List foucsData = [];
  List hotData = [];
  List bestData = [];

  bool get wantKeepAlive => true;

  Widget swiperWiget(){
      if (this.foucsData.length > 0) {
        return Container(
          child: AspectRatio(
            aspectRatio: 2,
            child: Swiper(
              autoplay: true,
              itemBuilder: (BuildContext context,int index){
                String pic = this.foucsData[index].pic;
                return new Image.network("${Config.domain}${pic.replaceAll('\\', '/')}",fit: BoxFit.fill);
              },
              itemCount: this.foucsData.length,
              pagination: new SwiperPagination(),
            ),
          ),
        );
      } else {
        return Text('加载中...');
      }
  }

  Widget titleWiget(String title){
    return Container(
      margin: EdgeInsets.only(left: ScreenAdaper.setHeight(5)),
      padding: EdgeInsets.only(left: ScreenAdaper.setHeight(5)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.red,
            width: ScreenAdaper.setWidth(10)
          )
        )
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black54
        ),
      ),
    );
  }

  Widget hotProductList () {
    if (this.hotData.length > 0) {
      return Container(
        width: double.infinity,
        height: ScreenAdaper.setHeight(200),
        margin: EdgeInsets.only(left: ScreenAdaper.setWidth(20), top: ScreenAdaper.setHeight(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            String pic = this.hotData[index].pic;
            return Center(
              child: Column(children: <Widget>[
                Container(
                  height: ScreenAdaper.setHeight(150),
                  width: ScreenAdaper.setWidth(150),
                  margin: EdgeInsets.only(right: 10),
                  child: Image.network(
                    "${Config.domain}${pic.replaceAll('\\', '/')}",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: ScreenAdaper.setWidth(150),
                  child: Text(
                      "${this.hotData[index].price}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red
                      ),
                  ),
                )
              ],
              ),
            );
          },
          itemCount: this.hotData.length,
        ),
      );
    } else {
      return Text('加载中');
    }
  }

  hotRecommend() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: this.bestData.map((value){
            return InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/productdetail', arguments: {
                  "id": value.sId
                });
              },
              child: Container(
                width: ( ScreenAdaper.getScreenWidth() - 30 ) / 2,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black54,
                        width: 1
                    )
                ),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                            "${Config.domain}${value.sPic.replaceAll('\\', '/')}"
                        ),
                      ),
                    ),
                    Text(
                      "${value.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '￥${value.price}',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '￥${value.oldPrice}',
                            style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
        }).toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 获取轮播图数据
    this.getFoucsData();

    // 获取猜你喜欢数据
    this.getHotData();

    // 获取热门推荐数据
    this.getBestData();
  }

  getFoucsData () async {
    var foucsData = await Dio().get('${Config.domain}api/focus');
    var foucsDataList = FoucsModel.fromJson(foucsData.data);
    this.setState(() {
      this.foucsData = foucsDataList.result;
    });
  }

  getHotData() async {
    var hotData = await Dio().get('${Config.domain}api/plist?is_hot=1');
    var hotList = ProductModel.fromJson(hotData.data);

    this.setState((){
      this.hotData = hotList.result;
    });
  }

  getBestData() async{
    var bestData = await Dio().get('${Config.domain}api/plist?is_best=1');
    var bestList = ProductModel.fromJson(bestData.data);

    this.setState((){
      this.bestData = bestList.result;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

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
      body: Container(
        child: ListView(
          children: <Widget>[
            swiperWiget(),
            SizedBox(height: ScreenAdaper.setHeight(20.0)),
            titleWiget('猜你喜欢'),
            hotProductList(),
            titleWiget('热门推荐'),
            hotRecommend()
          ],
        ),
      ),
    );
  }
}
