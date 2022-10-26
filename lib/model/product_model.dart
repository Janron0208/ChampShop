class ProductModel {
  String? id;
  String? idShop;
  String? nameProduct;
  String? size;
  String? color;
  String? stock;
  String? pathImage;
  String? price;
  String? detail;
  String? type;
  String? sale;
  String? advice;
  String? guild;

  ProductModel(
      {this.id,
      this.idShop,
      this.nameProduct,
      this.size,
      this.color,
      this.stock,
      this.pathImage,
      this.price,
      this.detail,
      this.type,
      this.sale,
      this.advice,
      this.guild});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameProduct = json['NameProduct'];
    size = json['Size'];
    color = json['Color'];
    stock = json['Stock'];
    pathImage = json['PathImage'];
    price = json['Price'];
    detail = json['Detail'];
    type = json['Type'];
    sale = json['Sale'];
    advice = json['Advice'];
    guild = json['Guild'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['NameProduct'] = this.nameProduct;
    data['Size'] = this.size;
    data['Color'] = this.color;
    data['Stock'] = this.stock;
    data['PathImage'] = this.pathImage;
    data['Price'] = this.price;
    data['Detail'] = this.detail;
    data['Type'] = this.type;
    data['Sale'] = this.sale;
    data['Advice'] = this.advice;
    data['Guild'] = this.guild;
    return data;
  }
}
