import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Five.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageSix extends StatefulWidget {
  const GuildPageSix({Key? key}) : super(key: key);

  @override
  State<GuildPageSix> createState() => _GuildPageSixState();
}

class _GuildPageSixState extends State<GuildPageSix> {
   List<UserModel> userModels = [];
  String? idShop = '1';
  List<ProductModel> productModels = [];

  
   @override
  void initState() {
    super.initState();
    readShop();
   
  }


  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/champshop/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';
    await Dio().get(url).then((value) {
      // print('$value');
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        String? nameShop = model.nameShop;
        if (nameShop!.isNotEmpty) {
          print('NameShop = ${model.nameShop}');
          setState(() {
            userModels.add(model);
            index++;
          });
        }
      }
    });
  }
   Future<Null> readProductMenu() async {
    idShop = '1';
    String url = '${MyConstant().domain}/champshop/getProductTypeAll.php?isAdd';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    print('res ==> $result');
    for (var map in result) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        productModels.add(productModel);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: IconButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        icon: Icon(Icons.arrow_back_ios_new)),
                  ),
                  Text('สีทาห้องน้ำ ยี่ห้อไหนดี ?',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 239, 153, 22)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                  'https://s359.thaibuffer.com/pagebuilder/825831fb-63c4-4db5-839e-105c4f5b2cf4.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       ผลิตภัณฑ์สีสำหรับทากระเบื้องในห้องน้ำ จะมีลักษณะพิเศษที่แตกต่างไปจากสีทาบ้านทั่วไป นั่นคือ ต้องทนต่อความชื้น และมีเนื้อสีที่เกาะแน่น เพราะจะต้องสัมผัสกับความชื้นหรือเปียกน้ำอยู่บ่อยครั้ง และอาจจะมีคุณสมบัติอื่น ๆ ดังนี้'),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //       'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            // ),
            
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      '       1. ทนต่อความเปียกชื้นหรือสภาพการเป็นไอน้ำ'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       2.เนื้อสีเกาะติดแน่น ไม่หลุด ลอก ล่อน แม้ต้องโดนน้ำเปียกตลอดเวลา'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       3. ทนสารที่มีอยู่ในน้ำยาทำความสะอาด เช่น สบู่ ยาสระผม ครีมนวดผม และน้ำยาล้างห้องน้ำ เป็นต้น'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '  4. บำรุงรักษาง่าย เช่น ใช้ผ้าชุบน้ำเช็ดทำความสะอาดได้'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       5. ทนต่อเชื้อราและแบคทีเรียที่เกิดขึ้นในห้องน้ำเนื่องจากเป็นบริเวณที่เปียกชื้น'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: SizedBox(
                width: 300,
                height: 50,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    color: Color.fromARGB(255, 255, 155, 135),
                    onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                           ShowDetailProduct(
                            userModel: userModels[0],
                            title: 'guild', guild: '6',
                          )));
            },
                    child: Text(
                      'ไปยังร้านค้า',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
