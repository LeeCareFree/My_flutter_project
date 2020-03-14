import 'package:flutter/material.dart';
import '../model/category.dart';
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> _childCategoryList = [];
  get childCategoryList => _childCategoryList;
  int _childIndex = 0;//子类高亮索引
  get childIndex => _childIndex;
  String _categoryId = '4';//大类id
  get categoryId => _categoryId;
  String _subId = '';
  get subId => _subId;
  int _page = 1;//列表页数，改变大类或小类时进行改变
  get page => _page;
  String _noMoreText = '';//显示更多的标识
  get noMoreText => _noMoreText;
  bool _isNewCategory = true;
  get isNewCategory => _isNewCategory;
  //注意这里是BxMallSubDto泛型（小技巧）
  //点击大类时更换
    getChildCategory(List<BxMallSubDto> list,String id){
      _isNewCategory=true;
      _categoryId=id;
      _childIndex=0;
      //------------------关键代码start
      _page=1;
      _noMoreText = ''; 
      //------------------关键代码end
      _subId=''; //点击大类时，把子类ID清空
      BxMallSubDto all=  BxMallSubDto();
      all.mallSubId='';
      all.mallCategoryId='00';
      all.mallSubName = '全部';
      all.comments = 'null';
      _childCategoryList=[all];
      childCategoryList.addAll(list);   
      notifyListeners();
    }
    //改变子类索引 ,
    changeChildIndex(int index,String id){
      _isNewCategory=true;
      //传递两个参数，使用新传递的参数给状态赋值
       _childIndex=index;
       _subId=id;
       //------------------关键代码start
       _page=1;
       _noMoreText = ''; //显示更多的表示
       //------------------关键代码end
       notifyListeners();
    }
    //增加page的方法
    addPage(){
      _page++;
    }
    //改变noMoreText的数据
    changeNoMore(String text){
      _noMoreText = text;
      notifyListeners();
    }
    changeFalse(){
      _isNewCategory = false;
    }
}