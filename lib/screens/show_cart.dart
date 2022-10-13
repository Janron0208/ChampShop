import 'dart:convert';
// import 'dart:html';

import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/cart_model.dart';
import '../model/user_model.dart';
import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';
import '../utility/sqlite_helper.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  State<ShowCart> createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<CartModel> cartModels = [];
  List<UserModel> userModels = [];

  int total = 0;
  bool status = true;

  bool statusOrder = true;
  bool? haveData;
  Location location = Location();
  String? address, phone, slip, urlpicture;
  double? lat, lng ;
  @override
  void initState() {
    super.initState();
    readSQLite();
     findLat1Lng1();
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
        setState(() {
          status = false;
          cartModels = object;
          total = total + sumInt;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,elevation: 0,
        title: Text('ตะกร้าสินค้า',
            style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 20, color: Color.fromARGB(255, 255, 147, 147))),
      ),
      body: status ? buildNonOrder() : Card(child: buildContent()),
    );
  }

  Center buildNonOrder() => Center(
          child: Text(
        'ไม่มีรายการสินค้าในตะกร้า',
        style:
            TextStyle(fontSize: 30, color: Color.fromARGB(255, 137, 137, 137)),
      ));

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildNameShop(),
            buildHeadTitle(),
            buildListProduct(),
            // Divider(),
            showTranspot(),
            buildTotal(),
            // buildClearCartButton(),

            buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget showTranspot() => Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('ระยะห่างจากร้าน ',
                  style: TextStyle(
                      fontSize: 12,
                      // fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 78, 78))),
              Text('${cartModels[0].distance}',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 46, 219, 43))),
              Text(' กม.',
                  style: TextStyle(
                      fontSize: 12,
                      // fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 78, 78, 78))),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'ค่าส่ง ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${cartModels[0].transport}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 134, 134)),
              ),
              Text(
                ' บาท',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      );

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
              Container(
                  height: 25,
                  child: RaisedButton(
                      color: Color.fromARGB(255, 245, 90, 105),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        confirmDeleteAllData();
                      },
                      child: Text(
                        'ล้างตะกร้า',
                        style: TextStyle(color: Colors.white),
                      )))
            ],
          ),
        ],
      ),
    );
  }

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

  Widget buildClearCartButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150,
          child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color.fromARGB(255, 188, 49, 49),
              onPressed: () {
                confirmDeleteAllData();
              },
              icon: Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              label: Text(
                'Clear ตะกร้า',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
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
                  'Confirm',
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
                  'Cancel',
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
        title: Text('ต้องดำเนิการต่อหรือไม่ ?'),
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
    // print(dateTime.toString());
    String orderDateTime = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

    print(orderDateTime);

    String? idShop = cartModels[0].idShop;
    String? nameShop = cartModels[0].nameShop;
    String? distance = cartModels[0].distance;
    String? transport = cartModels[0].transport;

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
    // String? lat = preferences.getString('Lat');
    // String? lng = preferences.getString('Lng');
    String? slip = preferences.getString('Slip');
    String? urlPicture = preferences.getString('UrlPicture');

    print(
        'orderDateTime = $orderDateTime, idUser = $idUser, nameUser = $nameUser, phoneUser = $phoneUser, addressUser = $addressUser, idShop = $idShop, nameShop = $nameShop, distance = $distance, transport = $transport, lat = $lat, lng = $lng, slip = $slip, urlPicture = $urlPicture');
    print(
        'idProduct = $idProduct, nameProduct = $nameProduct, price = $price, amount = $amount, sum = $sum');

    String url =
        '${MyConstant().domain}/champshop/addOrder.php?isAdd=true&OrderDateTime=$orderDateTime&idUser=$idUser&NameUser=$nameUser&PhoneUser=$phoneUser&AddressUser=$addressUser&Lat=$lat&Lng=$lng&Slip=none&UrlPicture=$urlPicture&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport&idProduct=$idProduct&NameProduct=$nameProduct&Price=$price&Amount=$amount&Sum=$sum&idRider=none&Status=รอยืนยัน';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        clearAllSQLite();
        showToast('ทำการสั่งซื้อสำเร็จ');
        notificationToShop(idShop!);
      } else {
        normalDialog(context, 'ไม่สามารถสั่งสินค้าได้ กรุณาลองใหม่');
      }
    });
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
          (value) => normalDialog(context, 'ส่งออเดอร์สำเร็จ'),
        );
  }
}
