import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../model/order_model.dart';
import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';

class ShowStatusProductOrder extends StatefulWidget {
  const ShowStatusProductOrder({Key? key}) : super(key: key);

  @override
  State<ShowStatusProductOrder> createState() => _ShowStatusProductOrderState();
}

class _ShowStatusProductOrderState extends State<ShowStatusProductOrder> {
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

  // get index => null;

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
                      Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                amount = 1;
                                payMent(index);
                                print(orderModels[index].id!);
                              },
                              child: Text('แจ้งชำระ'),
                            )
                          ],
                        ),
                      ),
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
                  Divider(),
                  // MyStyle().mySizebox(),
                  // buildStepIndicator(statusInts[index]),
                  Row(
                    children: [
                      Text('สถานะ : '),
                      orderModels[index].status! == 'รอยืนยัน'
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
                  ),
                  // MyStyle().mySizebox(),
                ],
              ),
            ),
          ),
        ),
      );

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
                    showImage(),
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
                            editThread(index);
                            // findUser();
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

  Widget showImage() => Container(
        margin: EdgeInsetsDirectional.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () => chooseImage(ImageSource.camera),
            ),
            // Container(
            //   width: 100.0,
            //   height: 100.0,
            //   child: file == null
            //       ? Image.asset('images/product.png')
            //       : Image.file(
            //           file!,
            //           fit: BoxFit.cover,
            //         ),
            // ),
            Container(
              width: 100.0,
              height: 100.0,
              child: file == null
                  ? Image.asset('images/product.png', fit: BoxFit.cover)
                  : Image.file(
                      file!,
                      fit: BoxFit.cover,
                    ),
            ),
            IconButton(
              icon: Icon(Icons.add_photo_alternate),
              onPressed: () => chooseImage(ImageSource.gallery),
            ),
          ],
        ),
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker()
          .getImage(source: source, maxWidth: 800.0, maxHeight: 800.0);

      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Future<Null> editThread(int index) async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'addSlip$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/champshop/saveSlip.php';
    print('### $nameFile');

    await Dio().post(urlUpload, data: formData).then((value) async {
      slip = '/champshop/Slip/$nameFile';
      print('slip = $slip');
      print(orderModels[index].id!);
      id = orderModels[index].id!;

      String url =
          '${MyConstant().domain}/champshop/insertSlipWhereIdOrder.php?isAdd=true&id=$id&Slip=$slip';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        print('## Upload Slip Success');
        // Navigator.pop(context);
      } else {
        normalDialog(context, 'ยังอัพเดทไม่ได้กรุณาลองใหม่');
      }
    });
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
      children: [Text('วันที่สั่งซื้อ ${orderModels[index].orderDateTime!}')],
    );
  }

  Center buildNonOrder() => Center(
          child: Text(
        'ไม่มีรายการสั่งซื้อ',
        style:
            TextStyle(fontSize: 30, color: Color.fromARGB(255, 137, 137, 137)),
      ));

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

  Widget buildStepIndicator(int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            StepsIndicator(
              selectedStepSize: 30,
              selectedStepColorIn: Color.fromARGB(255, 255, 168, 162),
              selectedStepBorderSize: 0,
              unselectedStepSize: 10,
              unselectedStepColorIn: Color.fromARGB(255, 255, 212, 162),
              unselectedStepBorderSize: 0,
              undoneLineColor: Color.fromARGB(255, 255, 212, 162),
              doneLineColor: Color.fromARGB(255, 255, 168, 162),
              lineLength: 100,
              nbSteps: 3,
              selectedStep: index,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('รอจัดส่ง'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Text('กำลังจัดส่ง'),
                ),
                Text('จัดส่งสำเร็จ'),
              ],
            )
          ],
        ),
      );
}
