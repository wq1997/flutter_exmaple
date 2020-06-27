import 'package:crypto/crypto.dart';
import 'dart:convert';

class SignServies{
  static getSign(Map requestParams){
    List attrKeys = requestParams.keys.toList();

    // 按照ASCII码升序排序
    attrKeys.sort();

    String str = '';

    attrKeys.forEach((value){
      str += "${value}${requestParams[value]}";
    });

    return md5.convert(utf8.encode(str)).toString();
  }
}


