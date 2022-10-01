import 'dart:convert';

import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  String? address, phone;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSQLite();
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
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ตะกร้าสินค้า'),
      ),
      body: status
          ? Center(
              child: Text('ไม่มีสินค้าในตะกร้า', style: MyStyle().headText20),
            )
          : buildContent(),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildNameShop(),
            buildHeadTitle(),
            buildListProduct(),
            Divider(),
            showTranspot(),
            buildTotal(),
            buildClearCartButton(),
            buildOrderButton(),
          ],
        ),
      ),
    );
  }

  Widget showTranspot() => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('ค่าส่ง ', style: MyStyle().headText16),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('${cartModels[0].transport} ',
                    style: MyStyle().headText20),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('บาท', style: MyStyle().headText16),
          ),
        ],
      );

  Widget buildTotal() => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('ยอดรวม ', style: MyStyle().headText16),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$total ',
                  style: MyStyle().headText20,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('บาท', style: MyStyle().headText16),
          ),
        ],
      );

  Widget buildNameShop() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'ร้านจำหน่ายอุปกรณ์ก่อสร้าง',
                style: MyStyle().headText20,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('ระยะห่างจากร้าน '),
              Text(
                '${cartModels[0].distance}',
                style: MyStyle().headText16,
              ),
              Text(' กม.'),
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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(cartModels[index].nameProduct!),
                ),
                Expanded(
                  flex: 1,
                  child: Text(cartModels[index].price!),
                ),
                Expanded(
                  flex: 1,
                  child: Text(cartModels[index].amount!),
                ),
                Expanded(
                  flex: 1,
                  child: Text(cartModels[index].sum!),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.delete_forever),
                    color: Color.fromARGB(255, 202, 79, 79),
                    onPressed: () async {
                      int id = cartModels[index].id!;
                      print('You Click Delete id = $id');
                      await SQLiteHelper().deleteDataWhereId(id).then((value) {
                        print('Success Delete id = $id');
                        readSQLite();
                      });
                    },
                  ),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      );

  Widget buildHeadTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: MyStyle().showHeadText1('รายการ'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showHeadText1('ราคา'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showHeadText1('จำนวน'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().showHeadText1('รวม'),
          ),
          Expanded(
            flex: 1,
            child: MyStyle().mySizebox(),
          ),
        ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 150,
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
              ),
              label: Text(
                'สั่งซื้อสินค้า',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
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
    print('555');
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

    print(
        'orderDateTime = $orderDateTime, idUser = $idUser, nameUser = $nameUser, phoneUser = $phoneUser, addressUser = $addressUser, idShop = $idShop, nameShop = $nameShop, distance = $distance, transport = $transport');
    print(
        'idProduct = $idProduct, nameProduct = $nameProduct, price = $price, amount = $amount, sum = $sum');

    String url =
        '${MyConstant().domain}/champshop/addOrder.php?isAdd=true&OrderDateTime=$orderDateTime&idUser=$idUser&NameUser=$nameUser&PhoneUser=$phoneUser&AddressUser=$addressUser&idShop=$idShop&NameShop=$nameShop&Distance=$distance&Transport=$transport&idProduct=$idProduct&NameProduct=$nameProduct&Price=$price&Amount=$amount&Sum=$sum&idRider=none&Status=UserOrder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        clearAllSQLite();
        showToast('ทำการสั่งซื้อสำเร็จ');
        // notificationToShop(idShop!);
      } else {
        normalDialog(context, 'ไม่สามารถสั่งสินค้าได้ กรุณาลองใหม่');
      }
    }
    );
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

  // Future<Null> notificationToShop(String idShop) async {
  //   String urlFindToken =
  //       '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$idShop';
  //   await Dio().get(urlFindToken).then((value) {
  //     var result = json.decode(value.data);
  //     print('result ==> $result');
  //     for (var json in result) {
  //       UserModel model = UserModel.fromJson(json);
  //       String tokenShop = model.token!;
  //       print('tokenShop ==>> $tokenShop');

  //       String title = 'New Order!';
  //       String body = 'มีการสั่งสินค้าจากลูกค้า';
  //       String urlSendToken =
  //           '${MyConstant().domain}/champshop/apiNotification.php?isAdd=true&token=$tokenShop&title=$title&body=$body';

  //       sendNotificationToShop(urlSendToken);
  //     }
  //   });
  // }

  // Future<Null> sendNotificationToShop(String urlSendToken) async {
  //   await Dio().get(urlSendToken).then(
  //         (value) => normalDialog(context, 'ส่ง Order ไปที่ ร้านค้าแล้ว คะ'),
  //       );
  // }
}
