import 'dart:convert';

import 'Storage.dart';

class UserServices {
  static getUserInfo() async{
    try{
      List userInfo = json.decode(await localStorage.getItem('userinfo'));
      return userInfo;
    }catch(e){
      return [];
    }
  }

  static getUserLoginState() async{
    var userInfo = await getUserInfo();
    return userInfo.length > 0;
  }

  static loginOut() async{
    localStorage.removeItem('userinfo');
  }
}
