import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Five.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageEight extends StatefulWidget {
  const GuildPageEight({Key? key}) : super(key: key);

  @override
  State<GuildPageEight> createState() => _GuildPageEightState();
}

class _GuildPageEightState extends State<GuildPageEight> {
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
                  Text('ทาสีบ้าน และ วอลเปเปอร์ติดผนัง',
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
                  'https://www.kachathailand.com/wp-content/uploads/2021/06/210626-Content-%E0%B8%A7%E0%B8%AD%E0%B8%A5%E0%B9%80%E0%B8%9B%E0%B9%80%E0%B8%9B%E0%B8%AD%E0%B8%A3%E0%B9%8C%E0%B8%95%E0%B8%B4%E0%B8%94%E0%B8%9C%E0%B8%99%E0%B8%B1%E0%B8%87-%E0%B8%94%E0%B8%B5%E0%B8%81%E0%B8%A7%E0%B9%88%E0%B8%B2-%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%97%E0%B8%B2%E0%B8%AA%E0%B8%B5-%E0%B8%AD%E0%B8%A2%E0%B9%88%E0%B8%B2%E0%B8%87%E0%B9%84%E0%B8%A302-1200x670.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       วอลเปเปอร์ติดผนัง(Wallpaper) เป็นวัสดุตกแต่งภายในที่ผลิตจากวัสดุหลายชนิด เช่น กระดาษ, ผ้า, ไวนิล, โฟม และวัสดุอื่น ๆ อีกหลายประเภท โดยมีจุดเด่นที่ใช้งานได้สะดวกสบาย เพียงทากาว แล้วติดวอลเปเปอร์ลงไปบนผนังได้เลย หรือวอลเปเปอร์ประเภทที่มาพร้อมกาว เพียงแกะกาวแล้วแปะลงไปได้เลย จากนั้นรอให้กาวแห้ง ก็สามารถเข้าอยู่ได้เลยไม่มีปัญหาเรื่องกลิ่นเหม็นรบกวน นอกจากนี้ หากต้องการเปลี่ยนวอลเปเปอร์ ก็ทำได้ง่ายเพียงพรมน้ำลงบนวอลเปเปอร์เดิมแล้วทิ้งไว้สักพักให้แผ่นวอลเปเปอร์หลุดออกมา หรือใช้มือลอกออกก็ทำได้ง่าย ๆ'),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //       'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       สีทาผนัง เป็นวัสดุที่ใช้ตกแต่งบ้านทั้งภายใน และภายนอก โดยมีจุดเด่นที่ความทนทาน แบ่งได้หลายประเภท เช่น สีอะคริลิก, สีทาไม้ ตามวัตถุประสงค์ในการใช้ โดยขั้นตอนทาสีนั้น เริ่มตั้งแต่การสำรวจพื้นผิวที่ต้องการจะทาว่าเป็นประเภทใด เพื่อให้เลือกใช้สีได้เหมาะสม ต่อมาเป็นการซ่อมแซมทำความสะอาดพื้นผิว และต้องสำรวจค่าความชื้นที่เหมาะสมก่อน เพื่อไม่ให้เกิดปัญหาตามมา จากนั้น จึงลงสีพื้นซึ่งเป็นสีขาว เพื่อเพิ่มประสิทธิภาพให้สีติดทน ขั้นสุดท้าย จึงเป็นการทาสีหลักที่เราต้องการจึงเป็นอันเสร็จ ด้วยขั้นตอนมากมายเหล่านี้การทาสีผนัง จึงมีอายุการใช้งานที่ยาวนานอย่างมากนั่นเอง'),
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(
            //       '       2. ใช้ตู้ หรือชั้นวางหนังสือคุณสามารถทำให้ผนังหนาขึ้นและกันเสียงได้ง่ายขึ้นโดยการใช้ชั้นวางหรือตู้หนังสือ โดยจัดวางให้ชิดแนวผนัง ซึ่งหนังสือที่วางในชั้นก็จะช่วยเป็นชนวนกันเสียงได้ด้วย'),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(
            //       '       3. วางเบาะเพื่อกันการสั่นสะเทือนเลือกใช้เบาะผ้า หรือเบาะโฟมมารองเครื่องเสียงภายในห้องเพื่อนกันการสั่นสะเทือน ก็จะสามารถลดเสียงจากแรงสั่นสะเทือนได้ในระดับหนึ่ง'),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: Text(
            //       '       4. ปิดช่องว่างใต้ประตูช่องว่างใต้ประตูมักจะเป็นจุดที่เสียงสามารถเล็ดลอดออกมาได้ ซึ่งสามารถปิดช่องนี้ได้ด้วยวัสดุจำพวกแผ่นยาง ก็จะช่วยลดเสียงที่เล็ดลอดได้'),
            // ),
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
                            title: 'guild', guild: '8',
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
