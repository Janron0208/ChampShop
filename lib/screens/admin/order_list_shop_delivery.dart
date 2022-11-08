import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/order_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_api.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';

class OrderListShopDelivery extends StatefulWidget {
  const OrderListShopDelivery({Key? key}) : super(key: key);

  @override
  State<OrderListShopDelivery> createState() => _OrderListShopDeliveryState();
}

class _OrderListShopDeliveryState extends State<OrderListShopDelivery> {
  OrderModel? orderModel;
  String? idShop;

  bool statusOrder = true;
  bool? haveData;

  int amount = 1;
  int noOrder = 1;
  double? lat1, lng1, distance, slip;
  Location location = Location();
  List<OrderModel> orderModels = [];
  List<List<String>> listNameProducts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<int> allprice1 = [];
  String? id;
  late CameraPosition position;
  File? file;
  final LatLng _center = const LatLng(13.712754, 100.434610);
  final LatLng _user = const LatLng(13.686374, 100.430447);
  double? lat2 = 13.712754;
  double? lng2 = 100.434610;

  @override
  void initState() {
    super.initState();
    findIdShopAndReadOrder();
    // findLat1Lng1();
  }

  // Future<Null> findLat1Lng1() async {
  //   LocationData? locationData = await findLocationData();
  //   setState(() {
  //     lat1 = double.parse(orderModel!.lat!);
  //     lng1 = double.parse(orderModel!.lng!);

  //     print('lat1 = $lng1, lng1 = $lng1');
  //   });
  // }

  // Future<LocationData?> findLocationData() async {
  //   Location location = Location();
  //   try {
  //     return await location.getLocation();
  //   } catch (e) {
  //     return null;
  //   }
  // }

  Future<Null> findIdShopAndReadOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString(MyConstant().keyId);

    String path =
        '${MyConstant().domain}/champshop/getOrderWhereIdShopStatusRiderHandle.php';
    await Dio().get(path).then((value) {
      var result = json.decode(value.data);
      for (var map in result) {
        setState(() {
          orderModel = OrderModel.fromJson(map);
        });
        // print('lat1 = ${orderModel!.lat}, lng1 = ${orderModel!.lng}');
      }

      if (value.toString() == 'null') {
        setState(() {
          statusOrder = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          OrderModel model = OrderModel.fromJson(item);
          // print('orderDateTime = ${model.orderDateTime}');

          List<String> nameProducts =
              MyAPI().createStringArray(model.nameProduct!);
          List<String> prices = MyAPI().createStringArray(model.price!);
          List<String> amounts = MyAPI().createStringArray(model.amount!);
          List<String> sums = MyAPI().createStringArray(model.sum!);
          //  print('idOrder ==>> $idOrder');

          int total = 0;
          for (var item in sums) {
            total = total + int.parse(item);
          }

          print(prices);

          int allprice = 0;
          for (var item in prices) {
            allprice = allprice + int.parse(item);
          }

          setState(() {
            orderModels.add(model);
            listNameProducts.add(nameProducts);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totals.add(total);
            allprice1.add(allprice);
            statusOrder = false;
            haveData = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('กำลังจัดส่ง'),
        backgroundColor: Color.fromARGB(255, 255, 183, 173),
      ),
      body: statusOrder
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('ไม่มีคำสั่งซื้อ')],
              ),
            )
          : haveData!
              ? Container(
                color: Color.fromARGB(255, 255, 169, 116),
                child: showListProduct())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('ไม่มีคำสั่งซื้อ')],
                  ),
                ),
    );
  }

  ListView showListProduct() {
    
    return ListView.builder(
      itemCount: orderModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          // print('You Click index = $index');
          amount = 1;
          checkOrder(index);
        },

        // color: index % 2 == 0 ? Colors.lime.shade100 : Colors.lime.shade400,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Card(
            color: index % 2 == 0
                ? Color.fromARGB(255, 255, 221, 220)
                : Color.fromARGB(255, 255, 231, 218),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.white,
                  height: 40,
                  child: Row(
                    children: [
                      Text(
                        '  ออเดอร์เมื่อ : ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('${orderModels[index].orderDateTime!}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color.fromARGB(255, 70, 159, 91))),
                    ],
                  ),
                ),
                Column(
                  children: [
                    showContent2(index),
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 35,
                      color: Color.fromARGB(255, 219, 219, 219),
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
                                        color: Color.fromARGB(
                                            255, 105, 105, 105))),
                                Spacer(),
                                Text('${allprice1[index].toString()} บาท',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 135, 135, 135)))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Text('ค่าจัดส่ง',
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 105, 105, 105))),
                                Spacer(),
                                Text('${orderModels[index].transport!} บาท',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color:
                                            Color.fromARGB(255, 135, 135, 135)))
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
                                        color:
                                            Color.fromARGB(255, 33, 33, 33))),
                                Spacer(),
                                Text('${orderModels[index].idRider!} บาท',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 240, 151, 78)))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 160,
                          child: RaisedButton.icon(
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            onPressed: () {
                              deleteOrder(orderModels[index]);

                              // confirmDeleteOrder(index);
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            ),
                            label: Text(
                              'ยกเลิกออร์เดอร์',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: 160,
                          child: RaisedButton.icon(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              onPressed: () {
                                confirmOrder(index);
                                // editStatusOrder(index);
                                // findIdShopAndReadOrder();
                              },
                              icon: Icon(
                                Icons.car_crash,
                                color: Colors.white,
                              ),
                              label: Text(
                                'ยืนยันออเดอร์',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> confirmDeleteOrder(index) async {
    showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SimpleDialog(
          title: Text('ดำเนินการลบหรือไม่ ?'),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton.icon(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.white,
                  onPressed: () async {
                    deleteOrder(orderModels[index]);
                    findIdShopAndReadOrder();
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
      ),
    );
  }

  Future<Null> confirmOrder(index) async {
    showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SimpleDialog(
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
                    editStatusOrder(index);
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
      ),
    );
  }

  ListView showContent2(int index) {
    return ListView.builder(
      itemCount: listNameProducts[index].length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index2) => Column(
        children: [
          Container(
        color: Color.fromARGB(255, 228, 228, 228),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      listNameProducts[index][index2],
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  Row(
                    children: [
                      Text('${listPrices[index][index2]} บาท',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromARGB(255, 77, 153, 207))),
                      Spacer(),
                      Text(
                          'x${listAmounts[index][index2]} ชื้น (${listSums[index][index2]} บาท)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color.fromARGB(255, 77, 153, 207))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> editStatusOrder(index) async {
    id = orderModels[index].id;
    String status = 'ส่งสำเร็จ';
    String url =
        '${MyConstant().domain}/champshop/editStatusWhereIdOrder.php?isAdd=true&id=$id&Status=$status';
    await Dio().get(url);
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OrderListShopDelivery(),
          ),
        );
  }

  Future<Null> notificationToShop(String id) async {
    String urlFindToken =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(urlFindToken).then((value) {
      var result = json.decode(value.data);
      print('result ==> $result');
      for (var json in result) {
        UserModel model = UserModel.fromJson(json);
        String tokenShop = model.token!;
        print('tokenShop ==>> $tokenShop');

        String title = 'ยกเลิกออเดอร์!';
        String body =
            'มีการยกเลิกจากผู้ขาย หากมีข้อสงสัยโปรดติดต่อได้ทางเบอร์โทรศัพท์';
        String urlSendToken =
            '${MyConstant().domain}/champshop/apiNotification.php?isAdd=true&token=$tokenShop&title=$title&body=$body';
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

  Future<Null> checkOrder(int index) async {
    showDialog(
        barrierColor: Color.fromARGB(202, 112, 112, 112),
        context: context,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    backgroundColor: Color.fromARGB(255, 255, 245, 228),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    title: Container(
                      child: Column(
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${MyConstant().domain}${orderModels[index].urlPicture!}'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                showNameAndPhone(index),
                                showDateOrder(index),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.circular(10.0),
                                color: Color.fromARGB(255, 216, 216, 216)),
                          ),
                          Divider(),
                          // showMap(),
                          // Container(
                          //   width: 300,
                          //   height: 300,
                          //   decoration: BoxDecoration(),
                          //   // ignore: prefer_const_constructors
                          //   child: showMap(),
                          // ),

                          Divider(),
                          showHeadAddress(),
                          showAddress(index),
                          Divider(),
                          Row(
                            children: [
                              Text('ตัวเลือกการชำระเงิน : ',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 98, 98, 98))),
                              orderModels[index].slip! == 'none'
                                  ? Text('ชำระเงินปลายทาง',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color.fromARGB(
                                              255, 65, 179, 251)))
                                  : Text('โอนเงิน',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color:
                                              Color.fromARGB(255, 61, 200, 56)))
                            ],
                          ),
                          Divider(),
                          orderModels[index].slip! == 'none'
                              ? Text('')
                              : Column(
                                  children: [
                                    showTextSlip(),
                                    showImageSlip(index),
                                    Divider(),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    content: RaisedButton.icon(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      label: Text(
                        'ปิด',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // showBTN(context),
                  ),
                ),
              ),
            ));
  }

  Column showBTN(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 110,
              child: RaisedButton(
                color: MyStyle().greenColor2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                onPressed: () {
                  Navigator.pop(context);
                  // print(
                  //     'Order ${productModels[index].nameProduct!} Amount = $amount');

                  // addOrderToCart(index);
                },
                child: Text(
                  'ใส่ตะกร้า',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              width: 110,
              child: RaisedButton(
                color: MyStyle().greenColor2,
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
      ],
    );
  }

  Row showImageSlip(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showImage(index),
      ],
    );
  }

  Text showTextSlip() {
    return Text('สลิปชำระเงิน',
        style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 98, 98, 98)));
  }

  Text showAddress(int index) => Text(orderModels[index].addressUser!,
      style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 54, 54, 54)));

  Row showHeadAddress() {
    return Row(
      children: [
        Text(
          'ที่อยู่รับของ : ',
          style:
              TextStyle(fontSize: 18, color: Color.fromARGB(255, 98, 98, 98)),
        ),
      ],
    );
  }

  Row showDateOrder(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'เวลาที่สั่ง ',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
        ),
        Text(orderModels[index].orderDateTime!,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 110, 219, 113)))
      ],
    );
  }

  Column showNameAndPhone(int index) {
    return Column(
      children: [
        Text(
          'คุณ ${orderModels[index].nameUser!}',
          style:
              TextStyle(fontSize: 16, color: Color.fromARGB(255, 43, 43, 43)),
        ),
        Text(
          'เบอร์ติดต่อ : ${orderModels[index].phoneUser!}',
          style:
              TextStyle(fontSize: 15, color: Color.fromARGB(255, 43, 43, 43)),
        ),
      ],
    );
  }

  Future<Null> deleteOrder(OrderModel orderModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showerror1('คุณต้องการยกเลิกรายการนี้หรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  // Navigator.pop(context);
                  String url =
                      '${MyConstant().domain}/champshop/deleteOrderWhereId.php?isAdd=true&id=${orderModel.id}';
                  await Dio().get(url);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const OrderListShopDelivery(),
                    ),
                  );
                },
                child: Text('ยืนยัน'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget showImage(index) => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (_) =>
                        imageDialog('สลิปชำระเงิน', slip, context, index));
              },
              child: Container(
                  width: 100,
                  height: 100,
                  child: orderModels[index].slip! == 'none'
                      ? Image.asset('images/noslip.png')
                      : showHaveSlip(index)),
            ),
          ],
        ),
      );

  Container shownoslip() {
    return Container(
      width: 50,
      height: 50,
      child: Image.asset(
        'images/noslip.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Container showHaveSlip(index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
            image: NetworkImage(
                '${MyConstant().domain}${orderModels[index].slip!}'),
            fit: BoxFit.cover),
      ),
    );
  }

  Container showNoSlip(index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'รายการ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('ราคา', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('จำนวน', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('รวม', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageDialog(text, path, context, index) {
    return Container(
      child: Dialog(
        // backgroundColor: Colors.transparent,
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  // width: 250,
                  height: 400,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                        image: NetworkImage(
                            '${MyConstant().domain}${orderModels[index].slip!}'),
                        fit: BoxFit.contain),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
