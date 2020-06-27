import 'package:flutter/material.dart';
import '../../pages/Home/view.dart';
import '../../pages/Category/view.dart';
import '../../pages/Cart/view.dart';
import '../../pages/User/view.dart';

class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {


  List bottomItems = [
    {
      "icon": Icon(Icons.home),
      "title": Text('首页'),
    },
    {
      "icon": Icon(Icons.category),
      "title": Text('分类'),
    },
    {
      "icon": Icon(Icons.shopping_cart),
      "title": Text('购物车'),
    },
    {
      "icon": Icon(Icons.people),
      "title": Text('我的'),
    },
  ];

  List<Widget> pageList = [
    Home(),
    Category(),
    Cart(),
    User()
  ];

  getBottomItems () {
    return bottomItems.map((item){
      return BottomNavigationBarItem(
          icon: item['icon'],
          title: item['title']
      );
    }).toList();
  }

  int currentIndex = 0;

  PageController pageController;

  @override
  void initState() {
    super.initState();
    this.pageController = PageController(initialPage: this.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: this.pageController,
        children: pageList,
        onPageChanged: (index){
          this.setState((){
            this.currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        currentIndex: this.currentIndex,
        onTap: (index) {
            this.setState((){
              this.currentIndex = index;
              this.pageController.jumpToPage(this.currentIndex);
            });
        },
        items: getBottomItems(),
      ),
    );
  }
}
