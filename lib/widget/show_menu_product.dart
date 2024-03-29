import 'dart:convert';

import 'package:champshop/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../model/cart_model.dart';
import '../model/product_model.dart';
import '../utility/my_api.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/normal_dialog.dart';
import '../utility/sqlite_helper.dart';

class ShowMenuProduct extends StatefulWidget {
  final UserModel userModel;
  const ShowMenuProduct({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShowMenuProduct> createState() => _ShowMenuProductState();
}

class _ShowMenuProductState extends State<ShowMenuProduct> {
  UserModel? userModel;
  String? idShop;
  List<ProductModel> productModels = [];
  int amount = 1;
  double? lat1, lng1, lat2, lng2;
  Location location = Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = widget.userModel;
    readProductMenu();
    findLocation();
  }

  Future<Null> findLocation() async {
    location.onLocationChanged.listen((event) {
      lat1 = event.latitude;
      lng1 = event.longitude;
      // print('lat1= $lat1, lng1 = $lng1');
    });
  }

  Future<Null> readProductMenu() async {
    idShop = userModel!.id;
    String url =
        '${MyConstant().domain}/champshop/getProductWhereIdShop.php?isAdd=true&idShop=$idShop';

    Response response = await Dio().get(url);
    // print('res ==> $response');

    var result = json.decode(response.data);

    // print('res ==> $result');

    for (var map in result) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        productModels.add(productModel);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return productModels.length == 0
        ? MyStyle().showProgress()
        : ListView.builder(
            itemCount: productModels.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                amount = 1;
                confirmOrder(index);
              },
              
              child: Card(
                child: showContent(context, index),
              ),
            ),
          );
  }

// showContent(context, index),
  Row showContent(BuildContext context, int index) {
    return Row(
                children: [
                  showProductImage(context, index),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: MediaQuery.of(context).size.width * 0.35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                productModels[index].nameProduct!,
                                style: MyStyle().headText18,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.5,
                                child: Text(productModels[index].detail!),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '${productModels[index].price!} บาท',
                                style: MyStyle().Text16,
                              ),
                              
                              



                            ],
                          ),
                        ],
                      )),
                ],
              );
  }

  Container showProductImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8, top: 8),
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
            image: NetworkImage(
                '${MyConstant().domain}${productModels[index].pathImage!}'),
            fit: BoxFit.cover),
      ),
    );
  }

  Future<Null> confirmOrder(int index) async {
    showDialog(
        context: context,
        builder: (context) => Container(
              width: 200,
              height: 500,
              // color: Colors.white,
              child: showContentDialog(index),
            ));
  }

  StatefulBuilder showContentDialog(int index) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 300,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                  image: NetworkImage(
                      '${MyConstant().domain}${productModels[index].pathImage}'),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            child: Row(
              children: [
                Text(
                  productModels[index].nameProduct!,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 86, 86, 86)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
              child: Row(
                children: [
                  Text(
                    '฿${productModels[index].price!}',
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 139, 139)),
                  ),
                ],
              ),
            ),
          ),
          Container(
            // width: 8.0,
            child: Text(
              'รายละเอียดสินค้า : ${productModels[index].detail!}',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 92, 92, 92),
              ),
            ),
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.add_circle,
                    size: 36,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    setState(() {
                      amount++;
                      // print('amount = $amount');
                    });
                  },
                ),
                Text(
                  // '1',
                  amount.toString(),
                  style: MyStyle().headText18,
                ),
                IconButton(
                  icon: Icon(
                    Icons.remove_circle,
                    size: 36,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    if (amount > 1) {
                      setState(() {
                        amount--;
                      });
                    }
                  },
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 120,
                height: 50,
                child: RaisedButton(
                  color: Color.fromARGB(255, 64, 169, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () {
                    Navigator.pop(context);
                    // print(
                    //     'Order ${productModels[index].nameProduct!} Amount = $amount');

                    addOrderToCart(index);
                  },
                  child: Text(
                    'ใส่ตะกร้า',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                width: 120,
                height: 50,
                child: RaisedButton(
                  color: Color.fromARGB(255, 255, 19, 7),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ]),
      ),
    );
  }

  Future<Null> addOrderToCart(int index) async {
    String? nameShop = userModel!.nameShop;
    String? idProduct = productModels[index].id;
    String? nameProduct = productModels[index].nameProduct;
    String? price = productModels[index].price;

    int priceInt = int.parse(price!);
    int sumInt = priceInt * amount;

    lat2 = double.parse(userModel!.lat!);
    lng2 = double.parse(userModel!.lng!);
    double distance = MyAPI().calculateDistance(lat1!, lng1!, lat2!, lng2!);

    var myFormat = NumberFormat('##0.0#', 'en_US');
    String distanceString = myFormat.format(distance);

    int transport = MyAPI().calculateTransport(distance);

// , distance = $distanceString, transport = $transport
    print(
        'idShop = $idShop, nameShop = $nameShop, idProduct = $idProduct, nameProduct = $nameProduct, price = $price, amount = $amount, sum = $sumInt, distance = $distanceString, transport = $transport');

    Map<String, dynamic> map = Map();

    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idProduct'] = idProduct;
    map['nameProduct'] = nameProduct;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sumInt.toString();
    map['distance'] = distanceString;
    map['transport'] = transport.toString();

    print('map ==> ${map.toString()}');

    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHelper().readAllDataFromSQLite();
    print('object = ${object.length}');

    if (object.length == 0) {
      await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
        print('Insert Success');
        showToast("เพิ่มลงในตะกร้าแล้ว");
      });
    } else {
      String? idShopSQLite = object[0].idShop;
      print('idShopSQLite ==> $idShopSQLite');
      if (idShop == idShopSQLite) {
        await SQLiteHelper().insertDataToSQLite(cartModel).then((value) {
          print('Insert Success');
          showToast("เพิ่มลงในตะกร้าแล้ว");
        });
      } else {
        normalDialog(context,
            'ตะกร้ามีรายการสินค้าของร้าน ${object[0].nameShop} กรุณาซื้อจากร้านนี่ให้จบก่อน');
      }
    }
  }

  void showToast(String? string) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('เพิ่มลงในตะกร้าแล้ว'),
        action: SnackBarAction(
            label: 'ปิด', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
