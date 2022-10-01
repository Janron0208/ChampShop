import 'dart:convert';

import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../model/order_model.dart';
import '../utility/my_constant.dart';

class ShowStatusProductOrder extends StatefulWidget {
  const ShowStatusProductOrder({Key? key}) : super(key: key);

  @override
  State<ShowStatusProductOrder> createState() => _ShowStatusProductOrderState();
}

class _ShowStatusProductOrderState extends State<ShowStatusProductOrder> {
  String? idUser;
  bool statusOrder = true;
  List<OrderModel> orderModels = [];
  List<List<String>> listMenuProducts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totalInts = [];
  List<int> statusInts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
  }

  @override
  Widget build(BuildContext context) {
    return statusOrder ? buildNonOrder() : buildContent();
  }

  Widget buildContent() => ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Column(
          children: [
            MyStyle().mySizebox(),
            buildNameShop(index),
            buildDateTimeOrder(index),
            buildTranSport(index),
            buildHead(),
            buildListVireMenuProduct(index),
            buildTotal(index),
            MyStyle().mySizebox(),
            buildStepIndicator(statusInts[index]),
            MyStyle().mySizebox(),
          ],
        ),
      );

  Widget buildTotal(int index) => Row(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyStyle().showHeadText1('ราคารวม '),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyStyle().showSubTitle(totalInts[index].toString()),
              ],
            ),
          ),
        ],
      );

  ListView buildListVireMenuProduct(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenuProducts[index].length,
        itemBuilder: (context, index2) => Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(listMenuProducts[index][index2]),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listPrices[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listAmounts[index][index2]),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(listSums[index][index2]),
                ],
              ),
            ),
          ],
        ),
      );

  Container buildHead() {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(color: Color.fromARGB(255, 209, 209, 209)),
      child: Row(
        children: [
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
        ],
      ),
    );
  }

  Row buildTranSport(int index) {
    return Row(
      children: [
        MyStyle().showHeadText1('ค่าส่ง ${orderModels[index].transport!} บาท'),
      ],
    );
  }

  Row buildDateTimeOrder(int index) {
    return Row(
      children: [
        MyStyle().showHeadText1(
            'วันที่สั่งซื้อ ${orderModels[index].orderDateTime!}'),
      ],
    );
  }

  Row buildNameShop(int index) {
    return Row(
      children: [
        MyStyle().showHeadText1(orderModels[index].nameShop!),
      ],
    );
  }

  Center buildNonOrder() => Center(child: Text('ไม่มีรายการสั่งซื้อ'));

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idUser = preferences.getString('id');
    print('idUser = $idUser');
    readOrderFromIdUser();
  }

  Future<Null> readOrderFromIdUser() async {
    if (idUser != null) {
      String url =
          '${MyConstant().domain}/champshop/getOrderWhereIdUser.php?isAdd=true&idUser=$idUser';

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
          // print('menuFoods ==>> $menuProducts');

          int status = 0;
          switch (model.status) {
            case 'UserOrder':
              status = 0;
              break;
            case 'ShopCooking':
              status = 1;
              break;
            case 'RiderHandle':
              status = 2;
              break;
            case 'Finish':
              status = 3;
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

  Widget buildStepIndicator(int index) => Column(
        children: [
          StepsIndicator(
            lineLength: 80,
            nbSteps: 4,
            selectedStep: index,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Order'),
              Text('Cooking'),
              Text('Delivery'),
              Text('Finish'),
            ],
          )
        ],
      );
}
