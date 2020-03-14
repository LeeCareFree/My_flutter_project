
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app01/provide/currentIndex.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import 'category_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//修改思路把原来的statfulWidget换成静态的statelessWidget然后进行包装Provider widget
//然后在每次变化时得到索引，点击下边导航时改变索引

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会员中心'),
    ),];

  final List<Widget> tabBodies = [
      HomePage(),
      Category(),
      CartPage(),
      MemberPage(),
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334);
    return Consumer<CurrentIndexProvider>(
      builder: (context,val,child){
        int currentIndex = Provider.of<CurrentIndexProvider>(context,listen: false).currentIndex;
        return Scaffold(
          backgroundColor: Color.fromARGB(244,245,245,1),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index){
              Provider.of<CurrentIndexProvider>(context,listen: false).changeIndex(index);
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: tabBodies,
          ),
        );
      },
    );
  }
}