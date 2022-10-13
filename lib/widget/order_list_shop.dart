import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:champshop/model/order_model.dart';
import 'package:champshop/utility/my_api.dart';
import 'package:champshop/utility/my_constant.dart';
import 'package:champshop/utility/my_style.dart';
import '../model/user_model.dart';
import '../utility/normal_dialog.dart';

class OrderListShop extends StatefulWidget {
  
  @override
  _OrderListShopState createState() => _OrderListShopState();
}


class _OrderListShopState extends State<OrderListShop> {
  OrderModel? orderModel;
  String? idShop;

  bool status = true; // H
  bool loadStatus = true;
  List<OrderModel> orderModels = [];
  List<List<String>> listNameProducts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  String? id;
  

  @override
  void initState() {
    super.initState();
    findIdShopAndReadOrder();

  }

  Future<Null> findIdShopAndReadOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString(MyConstant().keyId);

    String path =
        '${MyConstant().domain}/champshop/getOrderWhereIdShop.php?isAdd=true&idShop=$idShop';
    await Dio().get(path).then((value) {
      setState(() {
        loadStatus = false;
      });
      // print('value ==>> $value');
      var result = json.decode(value.data);
      print('result ==>> $result');

      for (var item in result) {
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

        setState(() {
          orderModels.add(model);
          listNameProducts.add(nameProducts);
          listPrices.add(prices);
          listAmounts.add(amounts);
          listSums.add(sums);
          totals.add(total);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orderModels.length == 0
          ? Center(child: Text('ยังไม่มีการสั่งซื้อ'))
          : showListProduct(),
    );
  }

  ListView showListProduct() {
    return ListView.builder(
      itemCount: orderModels.length,
      itemBuilder: (context, index) => Card(
        color: index % 2 == 0 ? Colors.lime.shade100 : Colors.lime.shade400,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyStyle().showSubTitle(
                  '${orderModels[index].nameUser!} ${orderModels[index].phoneUser!}'),
              MyStyle().showSubTitle(orderModels[index].orderDateTime!),
              buildTitle(),
              showContent2(index),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyStyle().showSubTitle('Total :'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: MyStyle().showSubTitle(totals[index].toString()),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RaisedButton.icon(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () => deleteOrder(orderModels[index]),
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      label: Text(
                        'ยกเลิกรายการ',
                        style: TextStyle(color: Colors.white),
                      )),
                  RaisedButton.icon(
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        // editStatusOrder();
                        // print(orderModels[index].id);
                        editStatusOrder(index);
                      },
                      icon: Icon(
                        Icons.car_crash,
                        color: Colors.white,
                      ),
                      label: Text(
                        'ทำการจัดส่ง',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView showContent2(int index) {
    return ListView.builder(
              itemCount: listNameProducts[index].length,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemBuilder: (context, index2) => Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(listNameProducts[index][index2]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(listPrices[index][index2]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(listAmounts[index][index2]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(listSums[index][index2]),
                    ),
                  ],
                ),
              ),
            );
  }

  // Future confirmOrder(index) async {
  //   String? id = orderModel!.id;
  //   String status = 'RiderHandle';
  //   // String url =
  //   //     '${MyConstant().domain}/champshop/editStatusWhereId.php?isAdd=true&id=$id&status=$status';
  //   // await Dio().get(url).then((value) {
      
  //   //   // MyDialog()
  //   //   //     .normalDialogOrderOk(context, 'รับคำสั่งซื้อเรียบร้อยแล้ว');
  //   // });
  //   print('$id');
  // }

  Future<Null> editStatusOrder(index) async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? idOrder = preferences.getString(orderModels.id);
    // String? idOrder = orderModels[index].id;
    // String? nextstatus = 'RiderHandle';
    // print('$nextstatus , $idOrder');
    

    // String url =
    //     '${MyConstant().domain}/champshop/editStatusWhereIdOrder.php?isAdd=true&id=$id&Status=$nextstatus';

    // await Dio().get(url).then((value) {
    //   if (value.toString() == 'true') {
    //     Navigator.pop(context);
    //   } else {
    //     normalDialog(context, 'กรุณาลองใหม่ ไม่สามารถบันทึกได้');
    //   }
    // });

    id = orderModels[index].id;
    String status = 'กำลังจัดส่ง';
    String url =
        '${MyConstant().domain}/champshop/editStatusWhereIdOrder.php?isAdd=true&id=$id&Status=$status';
    await Dio().get(url).then((value) {
    });
  

    
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

  Future<Null> deleteOrder(OrderModel orderModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: MyStyle().showerror1('คุณต้องการลบรายการนี้หรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${MyConstant().domain}/champshop/deleteOrderWhereId.php?isAdd=true&id=${orderModel.id}';
                  await Dio().get(url).then(
                    (value) {
                      return Navigator.pop(context);
                    },
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

  Container buildTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.lime.shade700),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Name Food'),
          ),
          Expanded(
            flex: 1,
            child: Text('Price'),
          ),
          Expanded(
            flex: 1,
            child: Text('Amount'),
          ),
          Expanded(
            flex: 1,
            child: Text('Sum'),
          ),
        ],
      ),
    );
  }
}
