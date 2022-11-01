import 'dart:convert';
import 'dart:io';
import 'dart:math';
// import 'dart:html';
import 'package:champshop/screens/user/main_buyer.dart';
import 'package:champshop/utility/my_style.dart';
import 'package:champshop/widget/show_status_product_order.dart';
import 'package:champshop/widget/user/show_information_shop.dart';
import 'package:champshop/widget/user/show_owner_shop.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/cart_model.dart';
import '../../model/user_model.dart';
import '../../screens/show_cart.dart';
import '../../utility/my_constant.dart';
import '../../utility/normal_dialog.dart';
import '../../utility/sqlite_helper.dart';
import '../about_shop.dart';
import 'order_success.dart';

// import '../model/cart_model.dart';
// import '../model/user_model.dart';
// import '../utility/my_constant.dart';
// import '../utility/normal_dialog.dart';
// import '../utility/sqlite_helper.dart';

class OrderPayment extends StatefulWidget {
  const OrderPayment({Key? key}) : super(key: key);

  @override
  State<OrderPayment> createState() => _OrderPaymentState();
}

class _OrderPaymentState extends State<OrderPayment> {
  List<CartModel> cartModels = [];
  List<UserModel> userModels = [];
  UserModel? userModel;
  int? totals;
  int? sumtotal;
  int total = 0;
  bool status = true;

  bool statusOrder = true;
  bool? haveData;
  Location location = Location();
  String? address, phone, slip, urlpicture;
  double? lat, lng;

  String? sumAddress;
  String? transport;
  String? nameUser, urlPicture, nickname;
  String? district, county, zipcode;

  File? file;

  @override
  void initState() {
    super.initState();
    readSQLite();
    findLat1Lng1();
    readCurrentInfo();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUSer = preferences.getString('id');
    print('idUser ==>> $idUSer');

    String url =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$idUSer';

    Response response = await Dio().get(url);
    // print('response ==>> $response');

    var result = json.decode(response.data);
    // print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameUser = userModel?.name;
        nickname = userModel?.nickname;
        address = userModel?.address;
        phone = userModel?.phone;
        urlPicture = userModel?.urlPicture;
        district = userModel?.district;
        county = userModel?.county;
        zipcode = userModel?.zipcode;
        transport = userModel?.transport;
        sumAddress = userModel?.sumAddress;
        print('$transport');
      });
    }
  }

  Future<Null> findLat1Lng1() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat = locationData!.latitude!;
      lng = locationData.longitude!;
      // lat2 = double.parse(userModel.lat);
      // lng2 = double.parse(userModel.lng);
      print('lat1 = $lng, lng1 = $lng');
    });
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
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
          // print('รวม ${total}');
          status = false;
          cartModels = object;
          total = total + sumInt;
          sumtotal = total + sumtran;
          var formatter = NumberFormat('#,##,000');
          print(formatter.format(sumtotal));

          // ignore: unused_local_variable
        });
      }
    } else {
      setState(() {
        status = true;
        statusOrder = false;
        haveData = false;
      });
    }
  }

  String? selectedValue = 'เก็บเงินปลายทาง';

  @override
  Widget build(BuildContext context) {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 173, 41)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('ชำระเงิน',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 255, 173, 41))),
            Text('')
          ],
        ),
      ),
      body: status
          ? buildNonOrder()
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 1,
                        //   color: Colors.amber,
                        //   height: 5,
                        // ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'ชื่อผู้รับ : ',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 173, 41),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('${nameUser}(${nickname})',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 83, 83, 83))),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('เบอร์โทรศัพท์ : ',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 173, 41),
                                              fontWeight: FontWeight.bold)),
                                      Text('${phone}',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 83, 83, 83))),
                                    ],
                                  ),
                                  Text('${address}',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 83, 83, 83))),
                                ],
                              ),
                            ),
                          ),
                        ),

                        buildContent(),
                        // Spacer(),
                        MyStyle().mySizebox0(),

                        Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Text(
                                'เลือกประเภทการชำระเงิน',
                                style: TextStyle(fontSize: 20),
                              ),
                              ListTile(
                                title: const Text('โอนเงิน',
                                    style: TextStyle(fontSize: 15)),
                                leading: Radio(
                                  value: 'โอนเงิน',
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String?;
                                      print(selectedValue);
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('เก็บเงินปลายทาง',
                                    style: TextStyle(fontSize: 15)),
                                leading: Radio(
                                  value: 'เก็บเงินปลายทาง',
                                  groupValue: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String?;
                                      print(selectedValue);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        MyStyle().mySizebox0(),
                        Container(
                            child: selectedValue == 'เก็บเงินปลายทาง'
                                ? Text('')
                                : Container(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        MyStyle().mySizebox1(),
                                        RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AboutShop(),
                                                ),
                                              );
                                            },
                                            child: Text(
                                              'ดูเลขบัญชีสำหรับการโอนเงิน',
                                              style: TextStyle(fontSize: 18),
                                            )),
                                        MyStyle().mySizebox1(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: Container(
                                            width: 100.0,
                                            height: 100.0,
                                            child: file == null
                                                ? Image.asset(
                                                    'images/product.png',
                                                  )
                                                : GestureDetector(
                                                    onTap: () async {
                                                      await showDialog(
                                                          context: context,
                                                          builder:
                                                              (_) => Container(
                                                                    child:
                                                                        Dialog(
                                                                      // backgroundColor: Colors.transparent,
                                                                      elevation:
                                                                          5,
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.stretch,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 8.0),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [],
                                                                            ),
                                                                          ),
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Container(
                                                                                // width: 250,
                                                                                height: 400,

                                                                                decoration: BoxDecoration(
                                                                                  image: DecorationImage(fit: BoxFit.cover, image: FileImage(file!)),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ));
                                                    },
                                                    child: Container(
                                                        width: 100.0,
                                                        height: 100.0,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: FileImage(
                                                                    file!)))),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ElevatedButton(
                                            child: Text("เลือกรูปภาพสลิป"),
                                            onPressed: () => chooseImage(
                                                ImageSource.gallery),
                                            style: ElevatedButton.styleFrom(
                                              primary: Color.fromARGB(
                                                  255, 255, 121, 112),
                                              onPrimary: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 20),
                          child: Text(
                            '*** โปรดตรวจสอบข้อมูลให้ถูกต้องก่อนทำการสั่งซื้อ ***',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 60,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 215,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('ยอดชำระเงินทั้งหมด'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      buildSumTotal(),
                                      Text(' บาท',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 173, 41),
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                // orderThread();
                                confirmOrderThread();
                              },
                              child: Container(
                                width: 150,
                                height: 60,
                                color: Color.fromARGB(255, 255, 173, 41),
                                child: Center(
                                    child: Text('สั่งซื้อ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255)))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Text buildSumTotal() {
    int total1 = int.parse('$total');
    int total2 = int.parse('$transport');

    int total3 = total1 + total2;
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return Text(myFormat.format(total3),
        style: TextStyle(
            color: Color.fromARGB(255, 255, 173, 41),
            fontSize: 18,
            fontWeight: FontWeight.bold));
  }

  Center buildNonOrder() => Center(
          child: Text(
        'ไม่มีรายการสินค้าในตะกร้า',
        style:
            TextStyle(fontSize: 30, color: Color.fromARGB(255, 137, 137, 137)),
      ));

  Widget buildContent() {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 45,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 15),
                child: Row(
                  children: [
                    Text('รายการทั้งหมด',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
        buildListProduct2(),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 45,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Text('คำสั่งซื้อทั้งหมด ${cartModels.length} รายการ'),
                    Spacer(),
                    buildTotal1(),
                  ],
                ),
              ),
            ],
          ),
        ),
        MyStyle().mySizebox1(),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 40,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.list_alt,
                      color: Color.fromARGB(255, 255, 173, 41),
                    ),
                    Text(' ข้อมูลการชำระเงิน'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 1,
          height: 80,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Text('รวมการสั่งซื้อ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 105, 105, 105))),
                    Spacer(),
                    showPrice1(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Text('ค่าจัดส่ง',
                        style: TextStyle(
                            color: Color.fromARGB(255, 105, 105, 105))),
                    Spacer(),
                    Text('$transport บาท',
                        style: TextStyle(
                            color: Color.fromARGB(255, 105, 105, 105))),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Text('ยอดชำระเงินทั้งหมด',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 33, 33, 33))),
                    Spacer(),
                    showTotal2(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Text testsum() {
    int total1 = int.parse('$total');
    int total2 = int.parse('$transport');

    int total3 = total1 + total2;
    return Text('$total3');
  }

  Text showTotal2() {
    int total1 = int.parse('$total');
    int total2 = int.parse('$transport');

    int total3 = total1 + total2;
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return Text('${myFormat.format(total3)} บาท',
        style:
            TextStyle(fontSize: 16, color: Color.fromARGB(255, 255, 173, 41)));
  }

  Text showPrice1() {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return Text('${myFormat.format(total)} บาท',
        style: TextStyle(color: Color.fromARGB(255, 105, 105, 105)));
  }

  Text showPrice2(int index) {
    String formatAmount() {
      String price = cartModels[index].price!;
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

    return Text(' ${formatAmount()}',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color.fromARGB(255, 170, 170, 170)));
  }

  Row buildTotal1() {
    NumberFormat myFormat = NumberFormat.decimalPattern('en_us');
    return Row(
      children: [
        Text(
          myFormat.format(total),
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 173, 41)),
        ),
        Text(
          ' บาท',
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 173, 41)),
        ),
      ],
    );
  }

  Widget buildTotal() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'ยอดรวม ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$total ',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 134, 134)),
          ),
          Text(
            'บาท',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'ร้านจำหน่ายอุปกรณ์ก่อสร้าง',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 149, 123)),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildListProduct2() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            // Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        height: 70,
                        width: 40,
                        child: Image.network(
                            '${MyConstant().domain}${cartModels[index].pathImage}',
                            fit: BoxFit.cover),
                      )),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              '${cartModels[index].nameProduct!}',
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            showPrice2(index),
                            Text(' บาท',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 170, 170, 170))),
                            Spacer(),
                            Text('x ${cartModels[index].amount!} ชิ้น',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 170, 170, 170))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      );

  Widget buildListProduct() => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: cartModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(cartModels[index].nameProduct!),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(cartModels[index].price!),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(cartModels[index].amount!),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(cartModels[index].sum!),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.delete_forever),
                      color: Color.fromARGB(255, 202, 79, 79),
                      onPressed: () async {
                        int id = cartModels[index].id!;
                        print('You Click Delete id = $id');
                        await SQLiteHelper()
                            .deleteDataWhereId(id)
                            .then((value) {
                          print('Success Delete id = $id');
                          readSQLite();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ),
      );

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 146, 146),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                'รายการ',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'ราคา',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'จำนวน',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'รวม',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MyStyle().mySizebox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            height: 50,
            child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 74, 151, 253),
                onPressed: () {
                  // orderThread();
                  confirmOrderThread();
                },
                icon: Icon(
                  Icons.playlist_add_check_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                label: Text(
                  'สั่งซื้อสินค้า',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ),
        ],
      ),
    );
  }

  Future<Null> confirmDeleteAllData() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ต้องการจะลบรายการทั้งหมดหรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.white,
                onPressed: () async {
                  Navigator.pop(context);
                  await SQLiteHelper().deleteAllData().then((value) {
                    readSQLite();
                    showToast('ล้างรายการสินค้าสำเร็จ');
                  });
                },
                icon: Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 179, 45, 45),
                ),
                label: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Color.fromARGB(255, 179, 45, 45)),
                ),
              ),
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Color.fromARGB(255, 97, 183, 60),
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Color.fromARGB(255, 97, 183, 60)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> confirmOrderThread() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ดำเนินการต่อหรือไม่ ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.white,
                onPressed: () async {
                  orderThread();

                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check,
                  color: Color.fromARGB(255, 45, 108, 179),
                ),
                label: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Color.fromARGB(255, 45, 108, 179)),
                ),
              ),
              RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Color.fromARGB(255, 183, 60, 101),
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Color.fromARGB(255, 183, 60, 101)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> orderThread() async {
    DateTime dateTime = DateTime.now();
    String year = DateFormat('yyyy').format(dateTime);
    int intyear = int.parse(year);

    int thaiyear = intyear + 543;
    print(thaiyear);
    String orderDateTime =
        DateFormat('dd/MM/$thaiyear HH:mm น.').format(dateTime);

    print(orderDateTime);

    String? idShop = cartModels[0].idShop;
    String? nameShop = cartModels[0].nameShop;
    String? distance = cartModels[0].distance;
    // String? transport = cartModels[0].transport;

    // print(transport);

    List<String> idProducts = [];
    List<String> nameProducts = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      idProducts.add(model.idProduct!);
      nameProducts.add(model.nameProduct!);
      prices.add(model.price!);
      amounts.add(model.amount!);
      sums.add(model.sum!);
    }
    String idProduct = idProducts.toString();
    String nameProduct = nameProducts.toString();
    String price = prices.toString();
    String amount = amounts.toString();
    String sum = sums.toString();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUser = preferences.getString('id');
    String? nameUser = preferences.getString('Name');
    String? addressUser = preferences.getString('Address');
    String? phoneUser = preferences.getString('Phone');
    String? slip = preferences.getString('Slip');
    String? urlPicture = preferences.getString('UrlPicture');
    // String? transport = preferences.getString('Transport');
    String? sumAddress = preferences.getString('SumAddress');

    int transport1 = int.parse(transport!);

    int total = 0;
    for (var string in sums) {
      total = total + int.parse(string.trim());
    }
    // print('$total');
    // print('$transport1');

    int sumtotal = total + transport1;
    // print('$sumtotal');

    print(file);

    if (file == null) {
      print(
          'orderDateTime = $orderDateTime, idUser = $idUser, nameUser = $nameUser, nickname = $nickname , phoneUser = $phoneUser, addressUser = $sumAddress, idShop = $idShop, nameShop = $nameShop, distance = $distance, transport = $transport, lat = $lat, lng = $lng, slip = $slip, urlPicture = $urlPicture');
      print(
          'idProduct = $idProduct, nameProduct = $nameProduct, price = $price, amount = $amount, sum = $sum, all = $sumtotal');

      String sumAddress1 = '$address $district $county กทม. $zipcode';

      print(
          'OrderDateTime = $orderDateTime , idUser = $idUser , NameUser=$nameUser , PhoneUser=$phoneUser');
      print('AddressUser=$sumAddress1 , Lat=$lat , Lng=$lng ');
      print(
          'Slip=none , UrlPicture=$urlPicture , idShop=$idShop , NameShop=$nameShop , Distance=$distance , ');
      print(
          'Transport= $transport1 , idProduct=$idProduct , NameProduct=$nameProduct , Price=$price');
      print(
          'Amount=$amount , Sum=$sum , idRider=$sumtotal , Status = $selectedValue');

      String url =
          '${MyConstant().domain}/champshop/addOrder.php?isAdd=true&OrderDateTime=$orderDateTime&idUser=$idUser&NameUser=$nameUser&PhoneUser=$phoneUser&AddressUser=$sumAddress1&Lat=$lat&Lng=$lng&Slip=none&UrlPicture=$urlPicture&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport1&idProduct=$idProduct&NameProduct=$nameProduct&Price=$price&Amount=$amount&Sum=$sum&idRider=$sumtotal&Status=รอยืนยัน';

      await Dio().get(url).then((value) {
        if (value.toString() == 'true') {
          clearAllSQLite();
          // showToast('ทำการสั่งซื้อสำเร็จ');
          notificationToShop(idShop!);
          //     Navigator.pushAndRemoveUntil(
          // context,
          // MaterialPageRoute(builder: (context) => OrderSuccess()),
          // (Route<dynamic> route) => false);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const OrderSuccess(),
            ),
          );
        } else {
          normalDialog(context, 'ไม่สามารถสั่งสินค้าได้ กรุณาลองใหม่');
        }
      });
    } else {
      String urlUpload = '${MyConstant().domain}/champshop/saveSlip.php';
      Random random = Random();
      int i = random.nextInt(100000);
      String nameFile = 'addSlip$i.jpg';
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);
      print('### $nameFile');
      await Dio().post(urlUpload, data: formData).then((value) async {
        slip = '/champshop/Slip/$nameFile';
        print('slip = $slip');

        print(
            'orderDateTime = $orderDateTime, idUser = $idUser, nameUser = $nameUser, nickname = $nickname , phoneUser = $phoneUser, addressUser = $sumAddress, idShop = $idShop, nameShop = $nameShop, distance = $distance, transport = $transport, lat = $lat, lng = $lng, slip = $slip, urlPicture = $urlPicture');
        print(
            'idProduct = $idProduct, nameProduct = $nameProduct, price = $price, amount = $amount, sum = $sum, all = $sumtotal');

        String sumAddress1 = '$address $district $county กทม. $zipcode';

        print(
            'OrderDateTime = $orderDateTime , idUser = $idUser , NameUser=$nameUser , PhoneUser=$phoneUser');
        print('AddressUser=$sumAddress1 , Lat=$lat , Lng=$lng ');
        print(
            'Slip = $slip  , UrlPicture=$urlPicture , idShop=$idShop , NameShop=$nameShop , Distance=$distance , ');
        print(
            'Transport= $transport1 , idProduct=$idProduct , NameProduct=$nameProduct , Price=$price');
        print(
            'Amount=$amount , Sum=$sum , idRider=$sumtotal , Status = $selectedValue');

        String url =
            '${MyConstant().domain}/champshop/addOrder.php?isAdd=true&OrderDateTime=$orderDateTime&idUser=$idUser&NameUser=$nameUser&PhoneUser=$phoneUser&AddressUser=$sumAddress1&Lat=$lat&Lng=$lng&Slip=$slip&UrlPicture=$urlPicture&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport1&idProduct=$idProduct&NameProduct=$nameProduct&Price=$price&Amount=$amount&Sum=$sum&idRider=$sumtotal&Status=รอยืนยัน';

        await Dio().get(url).then((value) {
          if (value.toString() == 'true') {
            clearAllSQLite();
            // showToast('ทำการสั่งซื้อสำเร็จ');
            notificationToShop(idShop!);
            //    Navigator.pushAndRemoveUntil(
            // context,
            // MaterialPageRoute(builder: (context) => OrderSuccess()),
            // (Route<dynamic> route) => false);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const OrderSuccess(),
              ),
            );
          } else {
            normalDialog(context, 'ไม่สามารถสั่งสินค้าได้ กรุณาลองใหม่');
          }
        });
      });
    }
  }

  void showToast(String? string) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(string!),
        action: SnackBarAction(
            label: 'ปิด', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future<Null> clearAllSQLite() async {
    await SQLiteHelper().deleteAllData().then((value) {
      readSQLite();
    });
  }

  Future<Null> notificationToShop(String idShop) async {
    String urlFindToken =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$idShop';
    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      print('result ==> $result');
      for (var json in result) {
        UserModel model = UserModel.fromJson(json);
        String tokenShop = model.token!;
        print('tokenShop ==>> $tokenShop');

        String title = 'New Order!';
        String body = 'มีการสั่งสินค้าจากลูกค้า';
        String urlSendToken =
            '${MyConstant().domain}/champshop/apiNotification.php?isAdd=true&token=$tokenShop&title=$title&body=$body';

        sendNotificationToShop(urlSendToken);
      }
    });
  }

  Future<Null> sendNotificationToShop(String urlSendToken) async {
    await Dio().get(urlSendToken).then(
          (value) => {},
        );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }
}
