import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Five.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageTen extends StatefulWidget {
  const GuildPageTen({Key? key}) : super(key: key);

  @override
  State<GuildPageTen> createState() => _GuildPageTenState();
}

class _GuildPageTenState extends State<GuildPageTen> {
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
                  Text('ปูนปรับระดับพื้น คือ?',
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
                  'https://www.kachathailand.com/wp-content/uploads/2022/10/221028-Content-%E0%B8%82%E0%B9%89%E0%B8%AD%E0%B8%84%E0%B8%A7%E0%B8%A3%E0%B8%A3%E0%B8%B9%E0%B9%89%E0%B8%81%E0%B9%88%E0%B8%AD%E0%B8%99%E0%B8%97%E0%B8%B3-%E0%B8%9B%E0%B8%B9%E0%B8%99%E0%B8%9B%E0%B8%A3%E0%B8%B1%E0%B8%9A%E0%B8%A3%E0%B8%B0%E0%B8%94%E0%B8%B1%E0%B8%9A%E0%B8%9E%E0%B8%B7%E0%B9%89%E0%B8%9902-1200x670.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       ปูนปรับระดับ หรือปูนเทปรับระดับ (Self-Leveling ) บางคนอาจจะเรียก ปูนทรายปรับระดับ เป็นปูนที่มีลักษณะเหลว และไหลตัวได้ดี ซึ่งหน้าที่สำคัญ คือ การปรับระดับพื้นที่ไม่เรียบ ไม่เสมอกัน เป็นหลุมเป็นแอ่ง ไม่ได้ระดับ มีน้ำขัง  ใช่ก่อนการปูกระเบื้อง กระเบื้องยาง ไม้ปาร์เก้ ไม้ลามิเนต หรือวัสดุปิดทับ'),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //       'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                      '   ข้อดีของการปรับระดับพื้น'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       1.พื้นปูนที่ปรับให้เรียบเนียนแล้ว ช่วยให้การปูพื้นชนิดอื่น ๆ เช่น กระเบื้องยาง ลามิเนต ปาร์เก้ หรือกระเบื้องเซรามิก มีคุณภาพมากยิ่งขึ้น ไม่ต้องกังวลเรื่องพื้นบวม โก่งตัว หรือหลุดล่อน สามารถปูพื้นชนิดต่าง ๆ ได้อย่างมีคุณภาพ'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       2.พื้นปูนที่เรียบเนียนได้ระดับ จะช่วยเพิ่มความปลอดภัยในบ้าน โดยเฉพาะบ้านที่มีผู้สูงอายุ หรือเด็กเล็ก ช่วยป้องกันอุบัติเหตุจากการสะดุดหกล้ม เพราะพื้นที่ขรุขระ หรือไม่เรียบเสมอกัน ช่วยเพิ่มความปลอดภัยได้'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       3.ช่วยลดฝุ่นผงภายในบ้าน ปัญหาพื้นแตกร้าว ขรุขระส่วนใหญ่ มักจะมีปัญหาฝุ่นผงจากคอนกรีต ที่แตกร้าวตามมา การปรับระดับพื้นปูนให้เรียบ จึงช่วยลดฝุ่นผง สิ่งสกปรกภายในบ้าน ช่วยเสริมสุขภาพที่ดีให้กับคนในบ้านด้วย'),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(
            //       '       5. ติดแผ่นดูดซับเสียงเราสามารถติดตั้งแผ่นดูดซับเสียงได้ด้วยตัวเองง่ายๆ ซึ่งแผ่นดูดซับเสียงจะมีส่วนที่โค้งมนที่ช่วยการดูดซับเสียงได้ดี ซึ่งวิธีนี้ถือว่าเป็นวิธีที่นิยมกันมากที่สุด เพราะให้ประสิทธิภาพการเก็บเสียงได้ดี'),
            // ),
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
                            title: 'I', guild: '',
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
