import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';
class CartProvider with ChangeNotifier{
  String cartString = "[]";
  List<CartInfoModel> cartList = [];//商品列表对象
  double allPrice = 0;//总价格
  int allGoodsCount = 0;//总数量
  bool isAllCheck = true;//是否全选
  //添加购物车商品方法
  save(goodsId,goodsName,count,price,images) async{
    //初始化SharedPreferences
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    cartString=prefs.getString('cartInfo');  //获取持久化存储的值
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp=cartString==null?[]:json.decode(cartString.toString());
    //把获得值转变成List
    List<Map> tempList= (temp as List).cast();
    //声明变量，用于判断购物车中是否已经存在此商品ID
    allPrice = 0;//把商品总价设置为0
    allGoodsCount = 0;//把商品总量设置为0
    var isHave= false;  //默认为没有
    int ival=0; //用于进行循环的索引使用
    tempList.forEach((item){//进行循环，找出是否已经存在该商品
      //如果存在，数量进行+1操作
      if(item['goodsId']==goodsId){
        tempList[ival]['count']=item['count']+1;
         //关键代码-----------------start
        cartList[ival].count++;
         //关键代码-----------------end
        isHave=true;
      }
      if(item['isCheck']){
        //当前选中的商品价格*数量
        allPrice += (cartList[ival].price*cartList[ival].count);
        allGoodsCount += cartList[ival].count;
      }
      ival++;
    });
    //  如果没有，进行增加
    if(!isHave){
          Map<String, dynamic> newGoods={
             'goodsId':goodsId,
            'goodsName':goodsName,
            'count':count,
            'price':price,
            'images':images,
            'isCheck':true,//是否已经选择
          };
          tempList.add(newGoods);
          cartList.add(new CartInfoModel.fromJson(newGoods));
          allPrice += (price*count);
          allGoodsCount += count;
    }
    //把字符串进行encode操作，
    cartString= json.encode(tempList).toString();
    //print(cartString);
    //print(cartList.toString());
    prefs.setString('cartInfo', cartString);//进行持久化
    notifyListeners();
  }
  //清空
  remove()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    print('清空完成');
    notifyListeners();
  }
  //获取购物车商品列表
  getCartInfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //获得商品为字符串
    cartString = prefs.getString('cartInfo');
    //把cartList进行初始化，防止数据混乱
    cartList = [];
    //判断得到的字符串是否有值，如果等于null就说明没有key值
    if(cartString == null){
      cartList =[];
    }else{
      //转变成List<Map>形式
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;
      tempList.forEach((item){
        if(item['isCheck']){
          //总价格 = 数量 * 单价
        allPrice += (item['count']*item['price']);
        //总数量 = 数量++
        allGoodsCount += item['count'];
        }else{
          isAllCheck = false;
        } 
        //循环转使用CartInfoModel.fromJson变成对象形式加到CartList中去
        cartList.add(CartInfoModel.fromJson(item));

      });
    }
    notifyListeners();
  }
  //删除单个商品方法
  detleteOneDoods(String goodsId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    //转变成List<Map>形式也就是对象数组形式
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;//循环使用的索引
    int delIndex = 0;//删除的索引
    //注意这里为什么循环时不进行删除，因为dart语言不支持迭代时进行修改，为了保证循环时不出错
    tempList.forEach((item){
      if(item['goodsId'] == goodsId){
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    //删除选中商品数据
    tempList.removeAt(delIndex);
    //转回json字符串
    cartString = json.encode(tempList).toString();
    //刷新商品数据列表
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
  //商品选中状态
  changeCheckState(CartInfoModel cartItem)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString =prefs.getString('cartInfo');//得到持久化的字符串
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();//声明临时List，用于循环，找到修改项的索引
    int tempIndex = 0;//循环使用索引
    int changeIndex = 0;//需要修改的索引
    tempList.forEach((item){
      //循环判断索引值是否对应
      if(item['goodsId'] == cartItem.goodsId){
        //找到索引进行复制
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    //修改临时项（传递过来的修改项）
    //把对象变成Map值
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo',cartString);//进行持久化
    await getCartInfo();//重新读取列表
  }
  //点击全选按钮
  changeAllCheckState(bool isCheck)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];
    for(var item in tempList){
      var newItem = item;
      //把传递的值赋给item 不断改变item的属性
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }
    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo',cartString);
    await getCartInfo();
  }
  //购物车商品数量加减
  //第一个参数是加减操作的项，第二个参数是操做的具体事件
  // 商品数量加减
    addOrReduceAction(var cartItem,String todo) async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      cartString = prefs.getString('cartInfo');
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      int tempIndex = 0;
      int changeIndex = 0; 
      tempList.forEach((item){
        if(item['goodsId'] == cartItem.goodsId){
            changeIndex = tempIndex;
        }
        tempIndex++;
      });

      if(todo == 'add'){
        cartItem.count++;
      }else if(cartItem.count > 1){
        cartItem.count--;
      }
      tempList[changeIndex] = cartItem.toJson();
      cartString = json.encode(tempList).toString();
      prefs.setString('cartInfo', cartString);
      await getCartInfo(); 
    }
}