import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Five.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageEleven extends StatefulWidget {
  const GuildPageEleven({Key? key}) : super(key: key);

  @override
  State<GuildPageEleven> createState() => _GuildPageElevenState();
}

class _GuildPageElevenState extends State<GuildPageEleven> {
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
                  Text('วัสดุ กรุผนัง ภายนอก-ภายใน มีอะไรบ้าง?',
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
                  'https://www.kachathailand.com/wp-content/uploads/2022/10/221011-Content-%E0%B8%A3%E0%B8%B9%E0%B9%89%E0%B8%88%E0%B8%B1%E0%B8%81%E0%B8%81%E0%B8%B1%E0%B8%9A%E0%B8%A7%E0%B8%B1%E0%B8%AA%E0%B8%94%E0%B8%B8-%E0%B8%81%E0%B8%A3%E0%B8%B8%E0%B8%9C%E0%B8%99%E0%B8%B1%E0%B8%8702-1200x670.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       เรียกได้ว่า นอกการตกแต่งผนัง ด้วยการทาสี หรือการติดวอลเปเปอร์แล้ว นี้ยังมีการ กรุผนัง จากวัสดุชนิดต่าง ๆ เพื่อสร้างความโดดเด่นให้บ้านของคุณ'),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //       'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       1. อิฐมอญ หรืออิฐแดง เป็นวัสดุที่ผลิตจาก ดินเหนียว ผสมแกลบ แล้วเผาด้วยเตาจนสุก โครงสร้างบล็อกมีลักษณะตัน ไม่สามารถก่อเป็นผนังรับแรง เวลาก่อเสร็จ จึงต้องฉาบปูนทับ แต่ปัจจุบันไม่ต้องทำแบบนั้นแล้ว เพราะนิยมนำมากรุทำผนัง โชว์ความดิบตามแบบฉบับ ลอฟท์สไตล์ กันแทน และอิฐมอญนั้น สามารถ นำมา กรุผนังหัวเตียง หรือจะใช้ในครัว หรือหลังโซฟาก็ได้ อยู่ที่ความชอบของแต่ละคน '),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       2. การกรุผนังด้วยไม้ เรียกได้ว่า นิยมกันมาก ในทุกยุคทุกสมัย เพราะสื่อถึง ความอบอุ่น แบบครอบครัว ที่สำคัญ แต่งบ้านออกมาได้หลายสไตล์ ทั้ง Classic Style, Contemporary Style และสามารถนำไปประยุกต์กับการตกแต่งในแบบอื่น ๆ ได้อีก แต่หลาย ๆ คน คงอาจจะกังวลเรื่อง การผุพังของไม้ หรือกลัวว่า ปลวก จะมาบุกรุก กัดแทะไม้ในบ้าน  แต่ไม่ต้องกังวลไป เพราะในปัจจุบันไม้มีให้เลือกหลากหลายทั้งไม้จริงไม่ปลอม และยังเคลือกสารป้องกันเอาไว้แล้ว แค่นี้ก็เลือกใช้วัสดุไม้ได้อย่างปลอดภัย หมดห่วง แต่ถ้าไม่สบายใจ'),
            ),
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
                            title: 'guild', guild: '11',
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
