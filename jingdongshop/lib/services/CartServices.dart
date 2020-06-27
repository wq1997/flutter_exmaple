import 'Storage.dart';
import 'dart:convert';
class CartServices {
  static addCart(item) async{
    item = formatCartData(item);
    print(item);
    try{
      List cartListData = json.decode(await localStorage.getItem("cartList"));
      bool hasValue = cartListData.any((v){
        return v['_id'] == item['_id'] && v['selectedAttr'] == item['selectedAttr'];
      });

      if (!hasValue) {
        cartListData.add(item);
      } else {
        cartListData.map((v){
          if(v['_id'] == item['_id'] && v['selectedAttr'] == item['selectedAttr']){
            v['count'] = v['count'] + item['count'];
          }
        });
      }
      await localStorage.setItem('cartList', json.encode(cartListData));
    }catch(e){
      print("购物车为空");
      List tempList = new List();
      tempList.add(item);

      await localStorage.setItem('cartList', json.encode(tempList));

    }
  }

  static formatCartData(item){
    final Map data = new Map<String, dynamic>();
    data["_id"] = item.sId;
    data['title'] = item.title;
    if ( item.price is int || item.price is double ) {
      data['price'] = item.price;
    } else {
      data['price'] = double.parse(item.price);
    }
    data['selectedAttr'] = item.selectedAttr;
    data['count'] = item.count;
    data['pic'] = item.pic;
    data['checked'] = true;

    return data;
  }

  static getCheckOutData() async{
    List cartListData = [];
    List checkoutData = [];
    try{
      cartListData = json.decode(await localStorage.getItem("cartList"));
      cartListData.forEach((value){
        if (value['checked']) {
          checkoutData.add(value);
        }
      });
    }catch(e){
      checkoutData = [];
    }

    return checkoutData;
  }
}


