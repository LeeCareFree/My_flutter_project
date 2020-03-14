import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provide/details_info.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsDetail = Provider.of<DetailsInfoProvider>(context, listen: false)
        .goodsInfo
        .data
        .goodInfo
        .goodsDetail;
    return Consumer<DetailsInfoProvider>(
      builder: (context, val, child) {
        var isLeft =
            Provider.of<DetailsInfoProvider>(context, listen: false).isLeft;
        if (isLeft) {
          return Container(
            child: Html(data: goodsDetail),
          );
        } else {
          return Container(
            width: ScreenUtil().setWidth(750),
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text('暂时没有数据'),
          );
        }
      },
    );
  }
}
