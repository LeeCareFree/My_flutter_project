import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_flutter_app01/pages/cart_page/cart_count.dart';
import '../../model/cartInfo.dart';
import './cart_bottom.dart';
import 'package:provider/provider.dart';
import '../../provide/cart.dart';
class CartItem extends StatelessWidget {
  //设置接受商品子项为参数
  final CartInfoModel item;
  //使用构造方法
  CartItem(this.item);
  @override
  Widget build(BuildContext context) {
    print(item);
    return Container(
      margin: EdgeInsets.fromLTRB(5.0,2.0,5.0,2.0),
      padding: EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12),

        )
      ),
      child: Row(
        children: <Widget>[
          _cartCheckBtn(context,item),
          _cartImage(item),
          _cartGoodsName(item),
          _cartPrice(context,item),
        ],
      ),
    );
  }
  //多选按钮
  Widget _cartCheckBtn(context,item){
    return Container(
      child: Checkbox(
        value: item.isCheck,
        activeColor:Colors.pink,
        onChanged: (bool val){
          item.isCheck = val;
          Provider.of<CartProvider>(context,listen: false
          ).changeCheckState(item);
        },
      ),
    );
  }
  //商品图片 
  Widget _cartImage(item){

    return Container(
      width: ScreenUtil().setWidth(150),
      padding: EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color:Colors.black12)
      ),
      child: Image.network(item.images),
    );
  }
  //商品名称
  Widget _cartGoodsName(item){
    return Container(
      width: ScreenUtil().setWidth(300),
      padding: EdgeInsets.all(10),
      alignment: Alignment.topLeft,
      child: Column(
        children: <Widget>[
          Text(item.goodsName),
          CartCount(item)
        ],
      ),
    );
  }

  //商品价格
  Widget _cartPrice(context,item){

    return Container(
        width:ScreenUtil().setWidth(150) ,
        alignment: Alignment.centerRight,

        child: Column(
          children: <Widget>[
            Text('￥${item.price}'),
            Container(
              child: InkWell(
                onTap: (){
                  Provider.of<CartProvider>(context,listen: false).detleteOneDoods(item.goodsId);
                },
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.black26,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      );
  }

}