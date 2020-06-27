
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/CartProvider.dart';
import '../../config.dart';
import '../../services/CartServices.dart';
import '../../provider/CheckoutProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../services/UserServices.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with AutomaticKeepAliveClientMixin{

  bool get wantKeepAlive => true;
  bool isEdit = false;

  Widget CartItem(context) {
    var CartProvider = Provider.of<CartProviderClass>(context);
    return CartProvider.getCartNum > 0 ?
            Column(
              children: CartProvider.getCartList.map((value){
                return Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.black12
                      )
                    )
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 40,
                        child: Checkbox(
                          value: value['checked'],
                          onChanged: (data){
                            value['checked'] = !value['checked'];
                            CartProvider.changeItemCount();
                          },
                          activeColor: Colors.pink,
                        ),
                      ),
                      Container(
                        width: 60,
                        child: Image.network(
                          "${Config.domain}${value['pic'].replaceAll('\\', '/')}",
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
                                '${value['title']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "￥${value['price']}",
                                      style: TextStyle(
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
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
                                              value['count']--;
                                              CartProvider.changeItemCount();
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
                                              "${value['count']}"
                                            ),
                                          ),
                                          InkWell(
                                            onTap: (){
                                              value['count']++;
                                              CartProvider.changeItemCount();
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
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            )
            :
            Center(
              child: Text('去添加好物吧'),
            );
  }

  Widget CartNum(){
    var CartProvider = Provider.of<CartProviderClass>(context);
    return Text('${CartProvider.getCartNum}');
  }

  @override
  Widget build(BuildContext context) {
    var CartProvider = Provider.of<CartProviderClass>(context);
    var CheckoutProvider = Provider.of<CheckoutProviderClass>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: (){
              setState(() {
                this.isEdit = !this.isEdit;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              CartItem(context),
            ],
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.black12
                  )
                )
              ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: <Widget>[
                          Checkbox(
                            value: CartProvider.getIsCheckAll,
                            onChanged: (value){
                              CartProvider.checkAll(value);
                            },
                            activeColor: Colors.pink,
                          ),
                          Text('全选'),
                          SizedBox(
                            width: 20,
                          ),
                          !this.isEdit ?
                          Row(
                            children: <Widget>[
                              Text("合计："),
                              Text("￥${CartProvider.getAllPrice}", style: TextStyle(color: Colors.red))
                            ],
                          )
                          :
                          Text('')
                        ],
                      ),
                    ),
                    this.isEdit ?
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        child: Text('删除', style: TextStyle(color: Colors.white),),
                        color: Colors.red,
                        onPressed: (){
                            CartProvider.removeItem();
                        },
                      ),
                    )
                    :
                    Align(
                      alignment: Alignment.centerRight,
                      child: RaisedButton(
                        child: Text('结算', style: TextStyle(color: Colors.white),),
                        color: Colors.red,
                        onPressed: () async{
                          List checkOutData = await CartServices.getCheckOutData();
                          CheckoutProvider.changeCheckOutList(checkOutData);

                          if (checkOutData.length > 0) {
                            if (await UserServices.getUserLoginState()) {
                              Navigator.pushNamed(context, '/checkout');
                            } else {
                              Navigator.pushNamed(context, '/login');
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: '购物车没有选中的数据',
                                gravity: ToastGravity.CENTER
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }
}
