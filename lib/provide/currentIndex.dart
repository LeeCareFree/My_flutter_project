import 'package:flutter/material.dart';
class CurrentIndexProvider with ChangeNotifier{
  int currentIndex = 0;//控制底部导航和页面跳转，要把这个索引进行状态管理
  changeIndex(int newIndex){
    currentIndex = newIndex;
    notifyListeners();
  }
}