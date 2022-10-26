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

class ShowShopTypeL extends StatefulWidget {
  final UserModel userModel;
  const ShowShopTypeL({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ShowShopTypeL> createState() => _ShowShopTypeLState();
}

class _ShowShopTypeLState extends State<ShowShopTypeL> {
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
    String url = '${MyConstant().domain}/champshop/apishowproducttype/getProductTypeL.php?isAdd=true';

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
        title: Text('งานสีอื่นๆ',
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
        childAspectRatio: 3 / 4.8,
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

  Column showContent(BuildContext context, int index) {
    return Column(
      children: [
        showProductImage(context, index),
        Container(
          child: Column(
            children: [
              new Container(
                padding:
                    new EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 2),
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
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text('ขนาด/ปริมาณ : ',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color.fromARGB(255, 132, 132, 132),
                        )),
                    Text('${productModels[index].size!}',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 255, 132, 32),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text('สี : ',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color.fromARGB(255, 132, 132, 132),
                        )),
                    Text('${productModels[index].color!}',
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              productModels[index].sale! == productModels[index].price!
                  ? showSale1(index)
                  : Row(
                      children: [
                        showPrice1(index),
                        showSale2(index),
                      ],
                    )
            ],
          ),
        ),
      ],
    );
  }

  Text showSale2(int index) {
     String formatAmount() {
      String price = productModels[index].sale!;
      String priceInText = "";
      int counter = 0;
      for (int i = (price.length - 1); i >= 0; i--) {
        counter++;
        String str = price[i];
        if ((counter % 3) != 0 && i != 0) {
          priceInText = "$str$priceInText";
        } else if (i == 0) {
          priceInText = "$str$priceInText";
        } else {
          priceInText = ",$str$priceInText";
        }
      }
      return priceInText.trim();
    }
    return Text(
                        '${formatAmount()} บาท.',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                            color: Color.fromARGB(255, 249, 91, 91)),
                      );
  }

  Text showPrice1(int index) {
      String formatAmount() {
      String price = productModels[index].price!;
      String priceInText = "";
      int counter = 0;
      for (int i = (price.length - 1); i >= 0; i--) {
        counter++;
        String str = price[i];
        if ((counter % 3) != 0 && i != 0) {
          priceInText = "$str$priceInText";
        } else if (i == 0) {
          priceInText = "$str$priceInText";
        } else {
          priceInText = ",$str$priceInText";
        }
      }
      return priceInText.trim();
    }
    return Text(
                        '${formatAmount()} บาท',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 81, 185, 43)),
                      );
  }

  Text showSale1(int index) {
     String formatAmount() {
      String price = productModels[index].sale!;
      String priceInText = "";
      int counter = 0;
      for (int i = (price.length - 1); i >= 0; i--) {
        counter++;
        String str = price[i];
        if ((counter % 3) != 0 && i != 0) {
          priceInText = "$str$priceInText";
        } else if (i == 0) {
          priceInText = "$str$priceInText";
        } else {
          priceInText = ",$str$priceInText";
        }
      }
      return priceInText.trim();
    }
    return Text(
                    '${formatAmount()} บาท.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color.fromARGB(255, 249, 91, 91)),
                  );
  }

  SingleChildScrollView showContentDialog(int index) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 0),
          titlePadding: EdgeInsets.only(bottom: 0, left: 0, right: 0, top: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.cancel,
                          size: 30,
                        )),
                  ),
                ],
              ),

              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                      image: NetworkImage(
                          '${MyConstant().domain}${productModels[index].pathImage}'),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${productModels[index].nameProduct}',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 64, 64, 64)),
                        ),
                      ),
                      Row(
                        children: [
                          Text('ขนาด/ปริมาณ : ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 132, 132, 132),
                              )),
                          Text('${productModels[index].size}',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 255, 132, 32),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('สี : ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 132, 132, 132),
                              )),
                          Text('${productModels[index].color}',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Color.fromARGB(255, 60, 60, 60),
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                       productModels[index].sale! == productModels[index].price!
                  ? Row(
                    children: [
                      showSale3(index),
                    ],
                  )
                  : Row(
                      children: [
                        showPrice2(index),
                        showSale4(index),
                      ],
                    )
                    ],
                  ),
                ),
              ),
     
              Container(
                width: MediaQuery.of(context).size.width * 1,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.my_library_books_outlined,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 5, top: 2, bottom: 2),
                      child: Text('  รายละเอียดสินค้า',style: TextStyle(fontSize: 16),),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('${productModels[index].detail}',style: TextStyle(fontSize: 15))),
                    ),
               
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: MediaQuery.of(context).size.width * 0.20,
                          color: Color.fromARGB(255, 255, 255, 255),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: 50,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 195, 195, 195)),
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
                                Spacer(),
                                Container(
                                  width: 150,
                                  height: 60,
                                  child: ElevatedButton(
                                    
                                      style: ButtonStyle(
                                        
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        addOrderToCart(index);
                                      },
                                      child: Text('เพิ่มลงตะกร้า',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 255, 255, 255))),)
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            ],
          ),
        ),
      ),
    );
  }

  Text showPrice2(int index) {
     String formatAmount() {
      String price = productModels[index].price!;
      String priceInText = "";
      int counter = 0;
      for (int i = (price.length - 1); i >= 0; i--) {
        counter++;
        String str = price[i];
        if ((counter % 3) != 0 && i != 0) {
          priceInText = "$str$priceInText";
        } else if (i == 0) {
          priceInText = "$str$priceInText";
        } else {
          priceInText = ",$str$priceInText";
        }
      }
      return priceInText.trim();
    }
    return Text(
                        '${formatAmount()} บาท',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 81, 185, 43)),
                      );
  }

  Text showSale4(int index) {
     String formatAmount() {
      String price = productModels[index].sale!;
      String priceInText = "";
      int counter = 0;
      for (int i = (price.length - 1); i >= 0; i--) {
        counter++;
        String str = price[i];
        if ((counter % 3) != 0 && i != 0) {
          priceInText = "$str$priceInText";
        } else if (i == 0) {
          priceInText = "$str$priceInText";
        } else {
          priceInText = ",$str$priceInText";
        }
      }
      return priceInText.trim();
    }
    return Text(
                        '${formatAmount()} บาท.',
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 14,
                            color: Color.fromARGB(255, 249, 91, 91)),
                      );
  }

  Text showSale3(int index) {
    String formatAmount() {
      String price = productModels[index].sale!;
      String priceInText = "";
      int counter = 0;
      for (int i = (price.length - 1); i >= 0; i--) {
        counter++;
        String str = price[i];
        if ((counter % 3) != 0 && i != 0) {
          priceInText = "$str$priceInText";
        } else if (i == 0) {
          priceInText = "$str$priceInText";
        } else {
          priceInText = ",$str$priceInText";
        }
      }
      return priceInText.trim();
    }
    return Text(
                        '${formatAmount()} บาท.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color.fromARGB(255, 249, 91, 91)),
                      );
  }

  Future<Null> addOrderToCart(int index) async {
    String? nameShop = 'ChampShop';
    String? idShop = '1';
    String? idProduct = productModels[index].id;
    // String? nameProduct = productModels[index].nameProduct;
    String? price = productModels[index].price;
    String? pathImage = productModels[index].pathImage;

  String? size = productModels[index].size;
  String? color = productModels[index].color;

  String? nameProduct = '${productModels[index].nameProduct}(${productModels[index].size}/${productModels[index].color})' ;



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
        'idShop = $idShop, nameShop = $nameShop, idProduct = $idProduct, nameProduct = $nameProduct, price = $price, amount = $amount, sum = $sumInt, distance = $distanceString, transport = $transport, pathImage = $pathImage');

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
    map['pathImage'] = pathImage;

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
