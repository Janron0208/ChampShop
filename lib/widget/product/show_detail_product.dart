import 'dart:convert';
import 'package:champshop/model/user_model.dart';
import 'package:champshop/screens/show_cart.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/cart_model.dart';
import '../../model/product_model.dart';

import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';
import '../../utility/normal_dialog.dart';
import '../../utility/sqlite_helper.dart';

class ShowDetailProduct extends StatefulWidget {
  final UserModel userModel;
  final String title, guild;
  const ShowDetailProduct(
      {Key? key,
      required this.userModel,
      required this.title,
      required this.guild})
      : super(key: key);

  @override
  State<ShowDetailProduct> createState() => _ShowDetailProductState();
}

class _ShowDetailProductState extends State<ShowDetailProduct> {
  UserModel? userModel;
  String? idShop = '1';
  List<ProductModel> productModels = [];
  int amount = 1;
  // double? lat1, lng1, lat2, lng2;
  Location location = Location();
  String? county, showtext;
  late bool _isLoading;
  List<CartModel> cartModels = [];
  int objectleng = 0; 

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    readProductMenu();
    readTransport();
    readSQLite();
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHelper().readAllDataFromSQLite();
    print('object length ==> ${object.length}');
    if (object.length != 0) {
      for (var model in object) {
        String? sumString = model.sum;
        int sumInt = int.parse(sumString!);
        String? transport = model.transport;
        int sumtran = int.parse(transport!);
        setState(() {
       
          cartModels = object;
        
        });
      }
    } else {
     
    }
  }

  Future<Null> readTransport() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUSer = preferences.getString('id');
    print('idUser ==>> $idUSer');

    String url =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$idUSer';

    Response response = await Dio().get(url);
    print('response ==>> $response');

    var result = json.decode(response.data);
    print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        county = userModel?.transport;
        print('$county');
      });
    }
  }

  // Future<Null> findLocation() async {
  //   location.onLocationChanged.listen((event) {
  //     lat1 = event.latitude;
  //     lng1 = event.longitude;
  //   });
  // }

  Future<Null> readProductMenu() async {
    idShop = '1';
    String type = '${widget.title}';
    print(type);

    if (type == 'Sale') {
      String url =
          '${MyConstant().domain}/champshop/apishowproducttype/getProductTypeSale.php?isAdd=true';

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
    } else if (type == 'All') {
      idShop = '1';
      String url =
          '${MyConstant().domain}/champshop/getProductTypeAll.php?isAdd';
      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      for (var map in result) {
        ProductModel productModel = ProductModel.fromJson(map);
        setState(() {
          productModels.add(productModel);
        });
      }
    } else if (type == 'guild') {
      String guild = '${widget.guild}';
      print('$guild');

      String url =
          '${MyConstant().domain}/champshop/getproductapi/getProductWhereIdShopAndGuild.php?isAdd=true&idShop=1&Guild=$guild';
      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      for (var map in result) {
        ProductModel productModel = ProductModel.fromJson(map);
        setState(() {
          productModels.add(productModel);
        });
      }
    } else {
      String url =
          '${MyConstant().domain}/champshop/getproductapi/getProductWhereIdShopAndType.php?isAdd=true&Type=$type';
      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      for (var map in result) {
        ProductModel productModel = ProductModel.fromJson(map);
        setState(() {
          productModels.add(productModel);
        });
      }
    }

    if (type == 'A') {
      showtext = 'โครง,ล้อ';
    } else if (type == 'B') {
      showtext = 'งานประปา';
    } else if (type == 'C') {
      showtext = 'งานสวน';
    } else if (type == 'D') {
      showtext = 'รถเข็น';
    } else if (type == 'E') {
      showtext = 'โครงรถเข็นปูน';
    } else if (type == 'F') {
      showtext = 'เปล';
    } else if (type == 'G') {
      showtext = 'กระเบื้องยาง';
    } else if (type == 'H') {
      showtext = 'ถังปูน';
    } else if (type == 'I') {
      showtext = 'ปูน';
    } else if (type == 'J') {
      showtext = 'เครื่องมือ';
    } else if (type == 'K') {
      showtext = 'สีทาภายในภายนอก';
    } else if (type == 'L') {
      showtext = 'งานสีอื่นๆ';
    } else if (type == 'M') {
      showtext = 'สเปรย์';
    } else if (type == 'Z') {
      showtext = 'อื่นๆ';
    } else if (type == 'All') {
      showtext = 'สินค้าทั้งหมด';
    } else if (type == 'Sale') {
      showtext = 'สินค้าลดราคา';
    } else {
      showtext = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 214, 157),
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 246, 157, 63)),
        title: Text(showtext == null ? '' : '$showtext',
            style: TextStyle(
                fontSize: 20, color: Color.fromARGB(255, 224, 141, 63))),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ShowCart(),
                    ),
                  );
                },
                child: Align(alignment: Alignment.centerRight,
                  child: Container(
                  width: 50,
                  height: 50,
                    child: Center(
                      child: Stack(children: [
                        Icon(
                          Icons.shopping_cart,
                          size: 32,
                          color: Colors.white,
                        ),
                        // Positioned(
                        //   top: -3,
                        //   right: 0,
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle, color: Colors.red),
                        //     alignment: Alignment.center,
                        //     child: Text(''),
                        //   ),
                        // )
                      ]),
                    ),
                  ),
                ),
              )),
        ],
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
        childAspectRatio: 3 / 5.6,
        crossAxisCount: 2,
      ),
      itemCount: productModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          amount = 1;
          productModels[index].stock == '0' ? '' : confirmOrder(index);
        },
        child: Card(
          color: Colors.white,
          child: showContent(context, index),
        ),
      ),
    );
  }

  Container showProductImage(BuildContext context, int index) {
    return productModels[index].stock == '0'
        ? Container(
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    image: DecorationImage(
                      image: NetworkImage(
                          '${MyConstant().domain}${productModels[index].pathImage!}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(172, 0, 0, 0),
                    borderRadius: BorderRadius.circular(0),
                    // image: DecorationImage(
                    //   image: NetworkImage(
                    //       '${MyConstant().domain}${productModels[index].pathImage!}'),
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.width * 0.45,
                  child: Center(
                    child: Text(
                      'สินค้าหมด',
                      style: TextStyle(
                          fontSize: 26.0,
                          color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 8),
            width: MediaQuery.of(context).size.width * 0.45,
            height: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              image: DecorationImage(
                image: NetworkImage(
                    '${MyConstant().domain}${productModels[index].pathImage!}'),
                fit: BoxFit.cover,
              ),
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
                child: Align(
                  alignment: Alignment.centerLeft,
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text('ยี่ห้อ : ',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Color.fromARGB(255, 161, 161, 161),
                        )),
                    Text('${productModels[index].brand!}',
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Color.fromARGB(255, 255, 132, 32),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text('รุ่น/รหัสสินค้า : ',
                        style: TextStyle(
                          fontSize: 11.0,
                          color: Color.fromARGB(255, 132, 132, 132),
                        )),
                    Text('${productModels[index].model!}',
                        style: TextStyle(
                            fontSize: 11.0,
                            color: Color.fromARGB(255, 161, 161, 161),
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('ขนาด/ปริมาณ : ${productModels[index].size!}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10.0,
                            color: Color.fromARGB(255, 161, 161, 161),
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text('สี : ',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color.fromARGB(255, 161, 161, 161),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: productModels[index].sale! == productModels[index].price!
                    ? showSale1(index)
                    : Row(
                        children: [
                          showPrice1(index),
                          Text(' '),
                          showSale2(index),
                        ],
                      ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text('ยี่ห้อ : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 132, 132, 132),
                                )),
                            Text('${productModels[index].brand}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 255, 132, 32),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text('รุ่น/รหัสสินค้า: ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 132, 132, 132),
                                )),
                            Text('${productModels[index].model}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 241, 149, 96),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text('ขนาด/ปริมาณ : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 132, 132, 132),
                                )),
                            Text('${productModels[index].size}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 104, 104, 104),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
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
                      ),
                      Row(
                        children: [
                          productModels[index].sale! ==
                                  productModels[index].price!
                              ? Row(
                                  children: [
                                    showSale3(index),
                                  ],
                                )
                              : Row(
                                  children: [
                                    showPrice2(index),
                                    Text(' '),
                                    showSale4(index),
                                  ],
                                ),
                          Spacer(),
                          SizedBox(
                              height: 30,
                              child: RaisedButton(
                                onPressed: () {},
                                child: Text(
                                    'สินค้าที่มีทั้งหมด ${productModels[index].stock} ชิ้น'),
                              )),
                          Text(' ')
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
                      child: Text(
                        '  รายละเอียดสินค้า',
                        style: TextStyle(fontSize: 16),
                      ),
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
                          child: Text('${productModels[index].detail}',
                              style: TextStyle(fontSize: 15))),
                    ),
                  ],
                ),
              ),
              showBTNaddToCart(context, setState, index),
            ],
          ),
        ),
      ),
    );
  }

  Padding showBTNaddToCart(
      BuildContext context, StateSetter setState, int index) {
    return Padding(
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
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    int stockcount = int.parse(productModels[index].stock!);

                    if (amount < stockcount) {
                      setState(() {
                        amount++;
                      });
                    }
                    // setState(() {
                    //   amount++;

                    // });
                  },
                ),
                Spacer(),
                Container(
                    width: 150,
                    height: 60,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        addOrderToCart(index);
                        popupnext();
                      },
                      child: Text('เพิ่มลงตะกร้า',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color.fromARGB(255, 255, 255, 255))),
                    ))
              ],
            ),
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

    String? brand = productModels[index].brand;
    String? model = productModels[index].model;

    if (productModels[index].brand == '-') {
      brand = '(';
    } else {
      brand = '(${productModels[index].brand} ';
    }

    if (productModels[index].model == '-') {
      model = '';
    } else {
      model = '${productModels[index].model} ';
    }

    if (productModels[index].color == '-') {
      color = '';
    } else {
      color = '${productModels[index].color} ';
    }
    if (productModels[index].size == '-') {
      size = ')';
    } else {
      size = '${productModels[index].size})';
    }

    String? nameProduct =
        '${productModels[index].nameProduct}$brand$model$color$size';

    int priceInt = int.parse(price!);
    int sumInt = priceInt * amount;

    // lat2 = double.parse(userModel!.lat!);
    // lng2 = double.parse(userModel!.lng!);
    // double distance = MyAPI().calculateDistance(lat1!, lng1!, lat2!, lng2!);

    // var myFormat = NumberFormat('##0.0#', 'en_US');
    // String distanceString = myFormat.format(distance);

    // int transport = MyAPI().calculateTransport(distance);

// , distance = $distanceString, transport = $transport

    print(
        'idShop = $idShop, nameShop = $nameShop, idProduct = $idProduct, nameProduct = $nameProduct, price = $price, amount = $amount, sum = $sumInt, transport = $county, pathImage = $pathImage');

    Map<String, dynamic> map = Map();

    map['idShop'] = idShop;
    map['nameShop'] = nameShop;
    map['idProduct'] = idProduct;
    map['nameProduct'] = nameProduct;
    map['price'] = price;
    map['amount'] = amount.toString();
    map['sum'] = sumInt.toString();
    // map['distance'] = distanceString;
    map['transport'] = county.toString();
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
          readSQLite();
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
        duration: const Duration(seconds: 1),
        content: const Text('เพิ่มลงในตะกร้าแล้ว'),
        // action: SnackBarAction(

        //     label: 'ปิด', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<Null> popupnext() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Center(child: Text('ไปยังตะกร้าสินค้าสินค้าหรือไม่?')),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(
                          255, 107, 201, 255) //elevated btton background color
                      ),
                  onPressed: () async {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ShowCart(),
                      ),
                    );
                  },
                  icon: Icon(Icons.shopping_cart),
                  label: Text('ไปยังตะกร้า')),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(
                          255, 255, 150, 106) //elevated btton background color
                      ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.production_quantity_limits),
                  label: Text('เลือกสินค้าต่อ')),
            ],
          )
        ],
      ),
    );
  }
}
