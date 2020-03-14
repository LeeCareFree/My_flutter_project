import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_flutter_app01/provide/child_category.dart';
import 'package:provider/provider.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNavState(),
                CategoryGoodsList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

//左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;
  @override
  void initState() {
    _getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var categoryId = list[index].mallCategoryId;
        //获取到从后台拿到子类数据
        var childList = list[index].bxMallSubDto;
        //用状态管理方法改变
        Provider.of<ChildCategory>(context, listen: false)
            .getChildCategory(childList, categoryId);
        //可选参数在传值时必须使用这样带key值的形式
        _getGoodList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  //得到后台大类数据
  void _getCategory() async {
    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      
      CategoryModel categoryList = CategoryModel.fromJson(data);
      setState(() {
        list = categoryList.data;
      });
      Provider.of<ChildCategory>(context, listen: false)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  //得到商品列表数据
  //这里使用可选参数
  void _getGoodList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': "",
      'page': 1
    };
    await request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      //修改列表状态
      //print('goodsList${goodsList}');
      Provider.of<CategoryGoodsListProvider>(context, listen: false)
          .getGoodsList(goodsList.data);

      //print('>>>>>>>>>>>>>>>>>>>:${list[0].goodsName}');
    });
  }
}

//右侧商品导航条
class RightCategoryNavState extends StatefulWidget {
  @override
  _RightCategoryNavStateState createState() => _RightCategoryNavStateState();
}

class _RightCategoryNavStateState extends State<RightCategoryNavState> {
  //List list = ['名酒','宝丰','北京二锅头'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ChildCategory>(
        builder: (context, childCategory, child) {
          return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.black12))),
            //动态构造builder的方式
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: childCategory.childCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWell(
                    index, childCategory.childCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isCheck = false;
    //是否已经点击
    isCheck =
        (index == Provider.of<ChildCategory>(context, listen: false).childIndex)
            ? true
            : false;
    return InkWell(
      onTap: () {
        Provider.of<ChildCategory>(context, listen: false)
            .changeChildIndex(index, item.mallSubId);
        _getGoodList(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(28),
              color: isCheck ? Colors.pink : Colors.black),
        ),
      ),
    );
  }

  //得到商品列表数据
  void _getGoodList(String categorySubId) {
    var data = {
      'categoryId':
          Provider.of<ChildCategory>(context, listen: false).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      // Provide.value<CategoryGoodsList>(context).getGoodsList(goodsList.data);
      //判断是否有商品
      if (goodsList.data == null) {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getGoodsList([]);
      } else {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getGoodsList(goodsList.data);
      }
    });
  }
}
//商品列表，可以上拉加载

class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  EasyRefreshController _controller;
  var scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryGoodsListProvider>(
      builder: (context, data, child) {
        try {
          if (Provider.of<ChildCategory>(context, listen: false).page == 1)
            //列表位置回到最上边
            scrollController.jumpTo(0.0);
        } catch (e) {
          //print('进入页面第一次初始化${e}');
        }
        //在构建时 判断是否有商品
        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              //height: ScreenUtil().setHeight(1000),
              child: EasyRefresh(
                enableControlFinishRefresh: false,
                enableControlFinishLoad: true,
                controller: _controller,
                footer: ClassicalFooter(
                    noMoreText:
                        Provider.of<ChildCategory>(context, listen: false)
                            .noMoreText),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listWidget(data.goodsList, index);
                  },
                ),
                onLoad: () async {
                  if (Provider.of<ChildCategory>(context, listen: false)
                          .noMoreText ==
                      '没有更多了') {
                    Fluttertoast.showToast(
                        msg: "已经到底了",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.pink,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }else{
                    _getMoreList();
                  }
                },
              ),
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  //上拉加载更多方法
  void _getMoreList() {
    Provider.of<ChildCategory>(context, listen: false).addPage();
    var data = {
      'categoryId':
          Provider.of<ChildCategory>(context, listen: false).categoryId,
      'categorySubId': Provider.of<ChildCategory>(context, listen: false).subId,
      'page': Provider.of<ChildCategory>(context, listen: false).page,
    };

    request('getMallGoods', formData: data).then((val) {
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      // Provide.value<CategoryGoodsList>(context).getGoodsList(goodsList.data);
      //判断是否有商品
      if (goodsList.data == null) {
        //print('111');
        Provider.of<ChildCategory>(context, listen: false).changeNoMore('没有更多了');
      } else {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getMoreList(goodsList.data);
      }
    });
  }

//部分组合
  Widget _listWidget(List newList, int index) {
    return InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.black12))),
          child: Row(
            children: <Widget>[
              _goodsImage(newList, index),
              Column(
                children: <Widget>[
                  _goodsName(newList, index),
                  _goodsPrice(newList, index)
                ],
              )
            ],
          ),
        ));
  }

  //商品图片
  Widget _goodsImage(List newList, index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  //商品名称
  Widget _goodsName(List newList, index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  //商品价格
  Widget _goodsPrice(List newList, index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '价格：￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      ),
    );
  }
}
