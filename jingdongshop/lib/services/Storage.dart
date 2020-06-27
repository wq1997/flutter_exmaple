import 'package:shared_preferences/shared_preferences.dart';

class localStorage{
  static setItem(key, value) async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString(key, value);
  }

  static getItem(key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static removeItem(key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.remove(key);
  }

  static clear() async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.clear();
  }
}