import 'dart:convert';

import 'package:champshop/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../model/cart_model.dart';
import '../../model/product_model.dart';
import '../../utility/my_api.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';
import '../../utility/normal_dialog.dart';
import '../../utility/sqlite_helper.dart';

class ShowShopTypeD extends StatefulWidget {
  final UserModel userModel;
  const ShowShopTypeD({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShowShopTypeD> createState() => _ShowShopTypeDState();
}

class _ShowShopTypeDState extends State<ShowShopTypeD> {
  UserModel? userModel;
  String? idShop = '1';
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
    idShop = '1';
    String url = '${MyConstant().domain}/champshop/apishowproducttype/getProductTypeD.php?isAdd=true';

    Response response = await Dio().get(url);
    // print('res ==> $response');

    var result = json.decode(response.data);

    print('res ==> $result');

    for (var map in result) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        productModels.add(productModel);
      });
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 214, 157),
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 246, 157, 63)),
        title: Text('รถเข็นของ',
            style: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 224, 141, 63))),
      ),
      body: productModels.length == 0
          ? MyStyle().showProgress()
          : Stack(children: [
              Container(
                width: 392.5,
                height: 300,
                color: Color.fromARGB(255, 255, 214, 157),
              ),
              showGridview()
            ]),
    );
  }

  GridView showGridview() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 4.3,
        crossAxisCount: 2,
      ),
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
  Column showContent(BuildContext context, int index) {
    return Column(
      children: [
        showProductImage(context, index),
        Container(
          child: Column(
            children: [
              new Container(
                padding: new EdgeInsets.all(8),
                child: new Text(
                  '${productModels[index].nameProduct!}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Color.fromARGB(255, 96, 96, 96),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Spacer(),
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '฿${productModels[index].price!}',
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(255, 254, 79, 79)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container showProductImage(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
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
              child: showContentDialog(index),
            ));
  }

  StatefulBuilder showContentDialog(int index) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        titlePadding: EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 350,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                image: DecorationImage(
                    image: NetworkImage(
                        '${MyConstant().domain}${productModels[index].pathImage}'),
                    fit: BoxFit.cover),
              ),
            ),
            new Container(
              padding: new EdgeInsets.only(left: 10, right: 10),
              child: new Text(
                '${productModels[index].nameProduct!}',
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Color.fromARGB(255, 78, 77, 77),
                  // fontWeight: FontWeight.bold,
                ),
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
                          fontSize: 22,
                          color: Color.fromARGB(255, 255, 45, 45)),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'รายละเอียดสินค้า :',
                          style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '${productModels[index].detail!}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 92, 92, 92),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      size: 36,
                      // color: Colors.red,
                    ),
                    onPressed: () {
                      if (amount > 1) {
                        setState(() {
                          amount--;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 195, 195, 195)),
                      child: Center(
                        child: Text(
                          amount.toString(),
                          style: MyStyle().headText18,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      size: 36,
                      // color: Colors.green,
                    ),
                    onPressed: () {
                      setState(() {
                        amount++;
                        // print('amount = $amount');
                      });
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 184,
                  height: 60,
                  child: RaisedButton(
                    color: Color.fromARGB(255, 142, 201, 249),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () {
                      Navigator.pop(context);
                      addOrderToCart(index);
                    },
                    child: Text(
                      'ใส่ตะกร้า',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  width: 184,
                  height: 60,
                  child: RaisedButton(
                    color: Color.fromARGB(255, 255, 108, 100),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'ปิด',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Null> addOrderToCart(int index) async {
    String? nameShop = 'ChampShop';
    String? idShop = '1';
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
