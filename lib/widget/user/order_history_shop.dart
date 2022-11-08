import 'dart:async';
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
  late Timer timer;
  bool switchValue = true;
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
      backgroundColor: Color.fromARGB(255, 237, 237, 237),
      body: statusOrder
          ? buildNonOrder()
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 55, bottom: 20),
                  child: RefreshIndicator(
                      color: Colors.white,
                      backgroundColor: Color.fromARGB(255, 255, 173, 41),
                      onRefresh: () async {
                        Future<void>.delayed(const Duration(seconds: 3));
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const OrderHistoryShop(),
                          ),
                        );
                        // Navigator.pop(context);
                      },
                      child: buildContent()),
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 1,
                  height: 90,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                          ),
                          color: Color.fromARGB(255, 255, 173, 41),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text('         ประวัติการสั่งซื้อ   ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 255, 173, 41))),
                        // Switch(
                        //   value: switchValue,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       switchValue = value;
                        //       print(switchValue);
                        //     });
                        //   },
                        //   activeTrackColor: Color.fromARGB(255, 255, 147, 89),
                        //   activeColor: Color.fromARGB(255, 175, 97, 76),
                        // ),
                        Text('               ')
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildContent() => ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: orderModels.length,
        itemBuilder: (context, index) => Card(
          child: Column(
            children: [

              ExpansionTile(title: buildDateTimeOrder(index),children: [
                 Card(
                child: Container(
                  color: Color.fromARGB(255, 224, 224, 224),
                  child: ExpansionTile(
                    title: Text(
                      'คำสั่งซื้อทั้งหมด ${listMenuProducts[index].length} รายการ',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                    children: <Widget>[
                      buildListVireMenuProduct(index)
                    ],
                  ),
                ),
              ),
              showDetail1(context),
              showDetail2(context, index),
              ],),
              // Container(
              //   width: MediaQuery.of(context).size.width * 1,
              //   height: 40,
              //   color: Colors.white,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Row(
           
              //       children: [
              //         buildDateTimeOrder(index),
              //         Spacer(),
              //         // Switch(
              //         //   value: switchValue,
              //         //   onChanged: (value) {
              //         //     setState(() {
              //         //       switchValue = value;
              //         //       print(index);
              //         //     });
              //         //   },
              //         //   activeTrackColor: Color.fromARGB(255, 255, 147, 89),
              //         //   activeColor: Color.fromARGB(255, 175, 97, 76),
              //         // ),
              //         // Container(
              //         //   height: 30,
              //         //   child: Row(
              //         //     mainAxisAlignment: MainAxisAlignment.end,
              //         //     children: [],
              //         //   ),
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
           
             
            ],
          ),
        ),
      );

  Container showDetail2(BuildContext context, int index) {
    return Container(
              width: MediaQuery.of(context).size.width * 1,
              // height: 120,
              color: Color.fromARGB(255, 255, 241, 227),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text('สถานะการชำระ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 105, 105, 105))),
                          Spacer(),
                          orderModels[index].slip! == 'none'
                              ? Text('เก็บเงินปลายทาง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 64, 216, 224)))
                              : Text('โอนเงิน',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Color.fromARGB(255, 29, 172, 36)))
                        ],
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 20, right: 20),
                    //   child: Row(
                    //     children: [
                    //       Text('สถานะการจัดส่ง',
                    //           style: TextStyle(
                    //               color: Color.fromARGB(255, 105, 105, 105))),
                    //       Spacer(),
                    //       buildStatus(index),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text('ค่าจัดส่ง',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 105, 105, 105))),
                          Spacer(),
                          Text('${orderModels[index].transport!} บาท',
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
                          showTotalBath(index),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
  }

  Container showDetail1(BuildContext context) {
    return Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 30,
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
                        Text(' ข้อมูลการจัดส่ง'),
                      ],
                    ),
                  ),
                ],
              ),
            );
  }

  Text showTotalBath(int index) {
    String formatAmount() {
      String price = orderModels[index].idRider!;
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

    return Text('${formatAmount()} บาท',
        style: TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 255, 173, 41),
          fontWeight: FontWeight.bold,
        ));
  }

  Container buildStatus(int index) {
    return Container(
      child: orderModels[index].status! == 'รอยืนยัน'
          ? Text(
              'รอยืนยัน',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 221, 71, 71)),
            )
          : Text(
              'กำลังจัดส่ง',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 244, 177, 54)),
            ),
    );
  }

  ListView buildListVireMenuProduct(int index) => ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: listMenuProducts[index].length,
        itemBuilder: (context, index2) => Container(
          color: Color.fromARGB(255, 239, 239, 239),
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 5, top: 2),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(listMenuProducts[index][index2],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ))),
                      Row(
                        children: [
                          showProductBath(index, index2),
                          Spacer(),
                          Text('x ${listAmounts[index][index2]} ชิ้น',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 170, 170, 170))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Text showProductBath(int index, int index2) {
    String formatAmount() {
      String price = listPrices[index][index2];
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

    return Text('${formatAmount()} บาท.',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color.fromARGB(255, 170, 170, 170)));
  }

  Row buildTranSport(int index) {
    return Row(
      children: [
        Text('ค่าส่ง ${orderModels[index].transport!} บาท'),
      ],
    );
  }

  Row buildDateTimeOrder(int index) {
    return Row(
      children: [
        Text('วันที่สั่งซื้อ ${orderModels[index].orderDateTime!}',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 36, 154, 205),
              fontWeight: FontWeight.bold,
            ))
      ],
    );
  }

  Center buildNonOrder() => Center(
          child: Text(
        'ไม่มีรายการสั่งซื้อ',
        style:
            TextStyle(fontSize: 30, color: Color.fromARGB(255, 137, 137, 137)),
      ));
}
