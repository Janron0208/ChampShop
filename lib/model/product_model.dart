class ProductModel {
  String? id;
  String? idShop;
  String? nameProduct;
  String? pathImage;
  String? price;
  String? detail;
  String? type;
  String? sale;
  String? advice;

  ProductModel(
      {this.id,
      this.idShop,
      this.nameProduct,
      this.pathImage,
      this.price,
      this.detail,
      this.type,
      this.sale,
      this.advice});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameProduct = json['NameProduct'];
    pathImage = json['PathImage'];
    price = json['Price'];
    detail = json['Detail'];
    type = json['Type'];
    sale = json['Sale'];
    advice = json['Advice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['NameProduct'] = this.nameProduct;
    data['PathImage'] = this.pathImage;
    data['Price'] = this.price;
    data['Detail'] = this.detail;
    data['Type'] = this.type;
    data['Sale'] = this.sale;
    data['Advice'] = this.advice;
    return data;
  }
}
