class CartModel {
  int? id;
  String? idShop;
  String? nameShop;
  String? idProduct;
  String? nameProduct;
  String? price;
  String? amount;
  String? sum;
  String? distance;
  String? transport;
  String? pathImage;

  CartModel(
      {this.id,
      this.idShop,
      this.nameShop,
      this.idProduct,
      this.nameProduct,
      this.price,
      this.amount,
      this.sum,
      this.distance,
      this.transport,
      this.pathImage});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShop = json['idShop'];
    nameShop = json['nameShop'];
    idProduct = json['idProduct'];
    nameProduct = json['nameProduct'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
    distance = json['distance'];
    transport = json['transport'];
    pathImage = json['pathImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['idShop'] = this.idShop;
    data['nameShop'] = this.nameShop;
    data['idProduct'] = this.idProduct;
    data['nameProduct'] = this.nameProduct;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    data['pathImage'] = this.pathImage;
    return data;
  }
}
