import 'package:champshop/model/product_model.dart';
import 'package:champshop/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import '../../model/cart_model.dart';
import '../../utility/my_api.dart';
import '../../utility/my_constant.dart';
import '../../utility/normal_dialog.dart';
import '../../utility/sqlite_helper.dart';

class ShowDetailProduct extends StatefulWidget {
  final ProductModel productModel;
  const ShowDetailProduct({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ShowDetailProduct> createState() => _ShowDetailProductState();
}

class _ShowDetailProductState extends State<ShowDetailProduct> {
  List<ProductModel> productModels = [];
  ProductModel? productModel;
  String? name, price, detail, pathImage, type, sale, size, color, stock;
  int amount = 1;
  double? lat1, lng1, lat2, lng2;
  Location location = Location();

  @override
  void initState() {
    super.initState();
    productModel = widget.productModel;
    name = productModel!.nameProduct;
    price = productModel!.price;
    detail = productModel!.detail;
    pathImage = productModel!.pathImage;
    type = productModel!.type;
    sale = productModel!.sale;
    size = productModel!.size;
    color = productModel!.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    image: DecorationImage(
                        image:
                            NetworkImage('${MyConstant().domain}${pathImage!}'),
                        fit: BoxFit.cover),
                  ),
                ),
                MyStyle().mySizebox0(),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.white,
                  // height: 70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${name}',
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
                            Text('$size',
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
                            Text('$color',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromARGB(255, 60, 60, 60),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        MyStyle().mySizebox1(),
                        Row(
                          children: [
                            showPrice1(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                MyStyle().mySizebox1(),
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
                            const EdgeInsets.only(left: 5, top: 15, bottom: 15),
                        child: Text('  รายละเอียดสินค้า'),
                      ),
                    ],
                  ),
                ),
                MyStyle().mySizebox0(),
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      MyStyle().mySizebox1(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('$detail')),
                      ),
                      MyStyle().mySizebox2(),
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
                                          color: Color.fromARGB(
                                              255, 195, 195, 195)),
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
                                                  BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 255, 136, 128,),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Text('เพิ่มลงตะกร้า')),
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
          ],
        ),
      ),
    );
  }

  Text showPrice1() {
    String formatAmount() {
      String price = productModel!.price!;
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

    return Text('ราคา ${formatAmount()} บาท',
        style:
            TextStyle(fontSize: 18, color: Color.fromARGB(255, 243, 89, 28)));
  }
}
