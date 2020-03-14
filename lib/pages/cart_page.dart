import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provide/cart.dart';
import 'package:provider/provider.dart';
import './cart_page/cart_bottom.dart';
import './cart_page/cart_item.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
            List cartList =
                Provider.of<CartProvider>(context, listen: false).cartList;
            if (snapshot.hasData  && cartList != null) {
            return Stack(
              children: <Widget>[
                Consumer<CartProvider>(
                  builder: (context, childCartgory, child) {
                    cartList = Provider.of<CartProvider>(context, listen: false)
                        .cartList;
                    print(cartList);
                    return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return CartItem(cartList[index]);
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                )
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provider.of<CartProvider>(context, listen: false).getCartInfo();
    return 'end';
  }
}

// class CartPage extends StatefulWidget {
//   @override
//   _CartPageState createState() => _CartPageState();
// }

// class _CartPageState extends State<CartPage> {
//   List<String> testList = [];

//   @override
//   Widget build(BuildContext context) {
//     _show();
//     return Container(
//       child: Column(
//         children: <Widget>[
//           Container(
//             height: ScreenUtil().setHeight(500),
//             child: ListView.builder(
//               itemCount: testList.length,
//               itemBuilder: (context,index){
//                 return ListTile(
//                   title: Text(testList[index]),
//                 );
//               },
//             ),
//           ),
//           //增加
//           RaisedButton(
//             onPressed: (){
//               _add();
//             },
//             child: Text('增加'),
//           ),
//           //清空
//           RaisedButton(
//             onPressed: (){
//               _clear();
//             },
//             child: Text('清空'),
//           ),
//         ],
//       ),
//     );
//   }

//   //增加方法
//   void _add() async {
//     //初始化
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String temp = "邱文君是最美的！！！";
//     testList.add(temp);
//     //持久化操作
//     prefs.setStringList('testInfo', testList);
//     _show();
//   }

//   //查询
//   void _show() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //判断key值是否存在
//     if (prefs.getStringList('testInfo') != null) {
//       setState(() {
//         testList = prefs.getStringList('testInfo');
//       });
//     }
//   }
//   //删除
//   void _clear()async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //prefs.clear();
//     //移除key键
//     prefs.remove('testInfo');
//     setState(() {
//       testList = [];
//     });
//   }
// }
