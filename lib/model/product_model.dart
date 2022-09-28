class ProductModel {
  String? id;
  String? idShop;
  String? nameProduct;
  String? pathImage;
  String? price;
  String? detail;
  String? type;

  ProductModel(
      {this.id,
      this.idShop,
      this.nameProduct,
      this.pathImage,
      this.price,
      this.detail,
      this.type});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameProduct = json['NameProduct'];
    pathImage = json['PathImage'];
    price = json['Price'];
    detail = json['Detail'];
    type = json['Type'];
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
    return data;
  }
}
