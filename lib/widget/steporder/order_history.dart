import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/order_model.dart';
import '../../utility/my_api.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';

class OrderHistory extends StatefulWidget {
    // final OrderModel orderModel;
  const OrderHistory(int index, {Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderModel? orderModel;
  String? idShop;

  bool statusOrder = true;
  bool? haveData;

  int amount = 1;
  int noOrder = 1;

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
    // orderModel = widget.orderModel;
    id = orderModel!.id;
   
  }

  Future<Null> findIdShopAndReadOrder() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString(MyConstant().keyId);

    String path =
        '${MyConstant().domain}/champshop/getOrderWhereId.php?isAdd=true&id=$id';
    await Dio().get(path).then((value) {
      setState(() {
        statusOrder = false;
        haveData = false;
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
          statusOrder = false;
          haveData = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: statusOrder
          ? MyStyle().showProgress()
          : haveData!
              ? showListProduct()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('ไม่มีรายการ')],
                  ),
                ),
    );
  }

  ListView showListProduct() {
    return ListView.builder(
      itemCount: orderModels.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {},

        // color: index % 2 == 0 ? Colors.lime.shade100 : Colors.lime.shade400,
        child: Card(
          color: index % 2 == 0
              ? Color.fromARGB(255, 255, 221, 220)
              : Color.fromARGB(255, 255, 231, 218),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'ออเดอร์เมื่อ : ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text('${orderModels[index].orderDateTime!}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 70, 159, 91))),
                  ],
                ),
                Column(
                  children: [
                    buildTitle(),
                    showContent2(index),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('รวมทั้งหมด '),
                        Text(
                          totals[index].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color.fromARGB(255, 54, 178, 72)),
                        ),
                        Text(' บาท')
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [],
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

  ListView showContent2(int index) {
    return ListView.builder(
      itemCount: listNameProducts[index].length,
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemBuilder: (context, index2) => Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 2),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(listNameProducts[index][index2]),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(listPrices[index][index2]),
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
                          Text(
                            listSums[index][index2],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
