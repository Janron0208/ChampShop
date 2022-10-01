class OrderModel {
  String? id;
  String? orderDateTime;
  String? idUser;
  String? nameUser;
  String? phoneUser;
  String? addressUser;
  String? idShop;
  String? nameShop;
  String? distance;
  String? transport;
  String? idProduct;
  String? nameProduct;
  String? price;
  String? amount;
  String? sum;
  String? idRider;
  String? status;

  OrderModel(
      {this.id,
      this.orderDateTime,
      this.idUser,
      this.nameUser,
      this.phoneUser,
      this.addressUser,
      this.idShop,
      this.nameShop,
      this.distance,
      this.transport,
      this.idProduct,
      this.nameProduct,
      this.price,
      this.amount,
      this.sum,
      this.idRider,
      this.status});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderDateTime = json['OrderDateTime'];
    idUser = json['idUser'];
    nameUser = json['NameUser'];
    phoneUser = json['PhoneUser'];
    addressUser = json['AddressUser'];
    idShop = json['idShop'];
    nameShop = json['NameShop'];
    distance = json['Distance'];
    transport = json['Transport'];
    idProduct = json['idProduct'];
    nameProduct = json['NameProduct'];
    price = json['Price'];
    amount = json['Amount'];
    sum = json['Sum'];
    idRider = json['idRider'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['OrderDateTime'] = this.orderDateTime;
    data['idUser'] = this.idUser;
    data['NameUser'] = this.nameUser;
    data['PhoneUser'] = this.phoneUser;
    data['AddressUser'] = this.addressUser;
    data['idShop'] = this.idShop;
    data['NameShop'] = this.nameShop;
    data['Distance'] = this.distance;
    data['Transport'] = this.transport;
    data['idProduct'] = this.idProduct;
    data['NameProduct'] = this.nameProduct;
    data['Price'] = this.price;
    data['Amount'] = this.amount;
    data['Sum'] = this.sum;
    data['idRider'] = this.idRider;
    data['Status'] = this.status;
    return data;
  }
}
