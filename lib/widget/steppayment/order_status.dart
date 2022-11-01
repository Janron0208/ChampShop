import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:champshop/screens/user/main_buyer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/order_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/normal_dialog.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
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
  File? file;
  String? id;
  late Timer timer;
  int counter = 0;

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

  Future<Null> RefreshPage() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const OrderStatus(),
      ),
    );
  }

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
        setState(() {
          statusOrder = false;
          haveData = false;
        });
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
            orderModels.add(model);
            listMenuProducts.add(menuProducts);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            totalInts.add(total);
            statusInts.add(status);
            statusOrder = false;
            haveData = true;
          });
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUser();
     timer = Timer.periodic(Duration(seconds: 30), (Timer t) => RefreshPage());
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
                padding: const EdgeInsets.only(top: 55,bottom: 20),
                child: RefreshIndicator(
                    color: Colors.white,
                    backgroundColor: Color.fromARGB(255, 255, 173, 41),
                    onRefresh: () async {
                      Future<void>.delayed(const Duration(seconds: 3));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const OrderStatus(),
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
                        size: 35,
                      ),
                      color: Color.fromARGB(255, 255, 173, 41),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainBuyer()),
                            (Route<dynamic> route) => false);
                      },
                    ),
                    Text('      สถานะการจัดส่ง',
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 173, 41))),
                    Text('                '),
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
              Container(
                width: MediaQuery.of(context).size.width * 1,
                height: 40,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildDateTimeOrder(index),
                      Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              buildListVireMenuProduct(index),
              Container(
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
              ),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                // height: 80,
                color: Color.fromARGB(255, 255, 241, 227),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text('สถานะการจัดส่ง',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 105, 105, 105))),
                          Spacer(),
                          buildStatus(index),
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
            ],
          ),
        ),
      );

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

              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Text(listPrices[index][index2]),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(listAmounts[index][index2]),
              //     ],
              //   ),
              // ),
              // Expanded(
              //   flex: 1,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Text(listSums[index][index2]),
              //     ],
              //   ),
              // ),
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

  Future<Null> payMent(int index) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                title: Column(
                  children: [
                    Column(
                      children: [
                        Text('แจ้งชำระเงิน',
                            style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 84, 84, 84))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'เวลาที่สั่ง ${orderModels[index].orderDateTime!}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 249, 171, 150)),
                            ),
                          ],
                        ),
                      ],
                    ),
                 
                  ],
                ),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 1000,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 110,
                        child: RaisedButton(
                          color: Color.fromARGB(255, 127, 189, 255),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () {
                            Navigator.pop(context);
                            // print(
                            //     'Order ${productModels[index].nameProduct!} Amount = $amount');
                            // confirmDialog();
                          
                            // findUser();
                            showToast('แจ้งชำระเงินสำเร็จ');
                          },
                          child: Text(
                            'ส่งบิล',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                        width: 110,
                        child: RaisedButton(
                          color: Color.fromARGB(255, 255, 128, 119),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'ปิด',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
              ),
            ));
  }

 
 

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ยืนยันการแจ้งชำระ'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  // editThread(index);

                  Navigator.pop(context);
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(color: Colors.green),
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          )
        ],
      ),
    );
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
              color: Color.fromARGB(255, 255, 173, 41),
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
}
