class CartInfoModel {
  String goodsId;
  String goodsName;
  int count;
  String images;
  double price;
  bool isCheck;

  CartInfoModel(
      {this.goodsId, this.goodsName, this.count, this.images, this.price,this.isCheck});

  CartInfoModel.fromJson(Map<String, dynamic> json) {
    goodsId = json['goodsId'];
    goodsName = json['goodsName'];
    count = json['count'];
    images = json['images'];
    price = json['price'];
    isCheck = json['isCheck'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodsId'] = this.goodsId;
    data['goodsName'] = this.goodsName;
    data['count'] = this.count;
    data['images'] = this.images;
    data['price'] = this.price;
    data['isCheck'] = this.isCheck;
    return data;
  }
}