import 'package:flutter/material.dart';
import 'package:my_flutter_app01/model/categoryGoodsList.dart';
import './pages/index_page.dart';
import 'package:provider/provider.dart';
import './provide/counter.dart';
import 'provide/child_category.dart';
import 'provide/category_goods_list.dart';
import 'package:fluro/fluro.dart';
import 'routers/routers.dart';
import './routers/application.dart';
import './provide/details_info.dart';
import './provide/cart.dart';
import './provide/currentIndex.dart';
void main() {
  //新的provider的写法
  runApp(
    MultiProvider(
    providers: [
      //Provider<ChildCategory>(create: (_) => ChildCategory(),),
      //Provider<Counter>(create: (_) => Counter(),)
      ChangeNotifierProvider.value(
        value: Counter(),
      ),
      ChangeNotifierProvider.value(
        value: ChildCategory(),
      ),
      ChangeNotifierProvider.value(
        value: CategoryGoodsListProvider(),
      ),
      ChangeNotifierProvider.value(
        value: DetailsInfoProvider(),
      ),
      ChangeNotifierProvider.value(
        value: CartProvider(),
      ),
      ChangeNotifierProvider.value(value: CurrentIndexProvider(),)
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //路由注入
    final router = Router();
    //配置
    Routes.configureRoutes(router);
    //静态化
    Application.router = router;

    return Container(
        child: MaterialApp(
      title: '生活+',

      debugShowCheckedModeBanner: false,
      //flutter内置路由配置
      onGenerateRoute: Application.router.generator,
      theme: ThemeData(primaryColor: Colors.pink),
      home: IndexPage(),
    ));
  }
}
