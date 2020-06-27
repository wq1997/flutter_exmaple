import 'Storage.dart';
import 'dart:convert';

class SearchServices{
  static setSearchData(value) async{
    try{
      List searchListData = json.decode(await localStorage.getItem("searchlist"));
      bool hasValue = searchListData.any((v){
        return v == value;
      });

      if (!hasValue) {
        searchListData.add(value);
        await localStorage.setItem('searchlist', json.encode(searchListData));
      }
    }catch(e){
      print("暂无搜索记录");
      List tempList = new List();
      tempList.add(value);

      localStorage.setItem('searchlist', json.encode(tempList));

    }
  }

  static getSearchList() async{
    try{
      List searchListData = json.decode(await localStorage.getItem("searchlist"));
      return searchListData.reversed.toList();
    }catch(e){
      return [];
    }
  }

  static clearSearchList() async{
    await localStorage.removeItem("searchlist");
  }

  static removeSearchData(value) async{
    List searchListData = json.decode(await localStorage.getItem("searchlist"));
    searchListData.remove(value);
    await localStorage.setItem('searchlist', json.encode(searchListData));
  }
}