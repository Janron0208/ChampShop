import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/order_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';

class OrderHistoryShop extends StatefulWidget {
  const OrderHistoryShop({Key? key}) : super(key: key);

  @override
  State<OrderHistoryShop> createState() => _OrderHistoryShopState();
}

class _OrderHistoryShopState extends State<OrderHistoryShop> {
  String? idUser, statusShow, slip;
  bool statusOrder = true;
  bool? haveData;
  List<OrderModel> orderModels = [];
  List<List<String>> listMenuProducts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totalInts = [];
  List<int> statusInts = [];
  List<List<String>> listIdOrders = [];
  int amount = 1;
  String? id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');
    // String? idOrder = preferences.getString('id');
    print('idUser = $idUser');
    readOrderFromIdUser();
  }

  Future<Null> readOrderFromIdUser() async {
    if (idUser != null) {
      String url =
          '${MyConstant().domain}/champshop/getOrderWhereIdUserHistory.php?isAdd=true&idUser=$idUser';

      Response response = await Dio().get(url);
      // print('respose ######==> $response');

      if (response.toString() != 'null') {
        var result = json.decode(response.data);
        for (var map in result) {
          OrderModel model = OrderModel.fromJson(map);
          List<String> menuProducts = changeArrey(model.nameProduct!);
          List<String> prices = changeArrey(model.price!);
          List<String> amounts = changeArrey(model.amount!);
          List<String> sums = changeArrey(model.sum!);
          // List<String> idOrders = changeArrey(model.id!);
          print('menuProducts ==>> $menuProducts');
          // print('idOrder ==>> $idOrders');

          int status = 0;
          switch (model.status) {
            case 'UserOrder':
              status = 0;
              break;
            case 'RiderHandle':
              status = 1;
              break;
            case 'Finish':
              status = 2;
              break;
            default:
          }

          int total = 0;
          for (var string in sums) {
            total = total + int.parse(string.trim());
          }

          setState(() {
            statusOrder = false;
            orderModels.add(model);
            listMenuProducts.add(menuProducts);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totalInts.add(total);
            statusInts.add(status);
            // listIdOrders.add(idOrders);
            statusOrder = false;
            haveData = true;
          });
        }
      }
    }
  }

  List<String> changeArrey(String string) {
    List<String> list = [];

    String myString = string.substring(1, string.length - 1);
    // print('myString = $myString');
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    // print('list *****=>> $list');
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: statusOrder
          ? MyStyle().showProgress()
          : haveData!
              ? buildContent()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('ไม่มีคำสั่งซื้อ')],
                  ),
                ),
    );
  }

  Widget buildContent() => ListView.builder(
        // padding: EdgeInsets.only(),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            amount = 1;
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // buildNameShop(index),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDateTimeOrder(index),
                    ],
                  ),
                  // buildTranSport(index),

                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: buildHead(),
                  ),

                  buildListVireMenuProduct(index),
                  Divider(),
                  buildTotal(index),
                  // Divider(),
                  // MyStyle().mySizebox(),
                  // buildStepIndicator(statusInts[index]),
                  // showStatus(index),
                  // MyStyle().mySizebox(),
                ],
              ),
            ),
          ),
        ),
      );

  Row showStatus(int index) {
    return Row(
                  children: [
                    Text('สถานะ : '),
                   
                    orderModels[index].status! == 'ส่งสำเร็จ'
                        ? Text(
                            'ส่งสำเร็จ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 86, 221, 71)),
                          )
                        : Text(
                            orderModels[index].status!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 244, 177, 54)),
                          ),

                    Spacer(),

                    // Text((() {
                    //   if (orderModels[index].slip! == 'none') {
                    //     return 'ยังไม่ได้ส่งสลิป';
                    //   }

                    //   return 'ส่งสลิปแล้ว';
                    // })()),

                    orderModels[index].slip! == 'none'
                        ? Text('ยังไม่ได้ส่งสลิป',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 224, 64, 64)))
                        : Text('ส่งสลิปแล้ว',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 29, 172, 36)))
                  ],
                );
  }

  Widget buildTotal(int index) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Text('ราคารวม ',
                  style: TextStyle(
                      color: Color.fromARGB(255, 64, 64, 64), fontSize: 16)),
              Text(totalInts[index].toString(),
                  style: TextStyle(
                      color: Color.fromARGB(255, 230, 125, 125),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
              Text(' บาท',
                  style: TextStyle(
                      color: Color.fromARGB(255, 230, 125, 125),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ],
          ),
        ],
      );

  ListView buildListVireMenuProduct(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenuProducts[index].length,
        itemBuilder: (context, index2) => Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(listMenuProducts[index][index2]),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(listPrices[index][index2]),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(listAmounts[index][index2]),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(listSums[index][index2]),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Color.fromARGB(255, 235, 183, 183)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'รายการ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row buildDateTimeOrder(int index) {
    return Row(
      children: [Text('วันที่สั่งซื้อ ${orderModels[index].orderDateTime!}')],
    );
  }
}
