import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaper {

  static init(context) {
    ScreenUtil.init(context, width: 750, height: 1334);
  }

  static setHeight(double value){
    return ScreenUtil().setHeight(value);
  }

  static setWidth(double value){
    return ScreenUtil().setWidth(value);
  }

  static getScreenWidth() {
    return ScreenUtil.screenWidthDp;
  }

  static getScreenHeight() {
    return ScreenUtil.screenHeightDp;
  }
}