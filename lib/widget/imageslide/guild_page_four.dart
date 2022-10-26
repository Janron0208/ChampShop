import 'dart:convert';

import 'package:champshop/model/user_model.dart';
import 'package:champshop/widget/product/show_shop_type_Four.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../utility/my_constant.dart';

class GuildPageFour extends StatefulWidget {
  const GuildPageFour({Key? key}) : super(key: key);

  @override
  State<GuildPageFour> createState() => _GuildPageFourState();
}

class _GuildPageFourState extends State<GuildPageFour> {
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
                  Text('ตกแต่งสวน',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 239, 153, 22)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                  'https://www.infinitydesign.in.th/wp-content/uploads/2019/05/%E0%B8%88%E0%B8%B1%E0%B8%94%E0%B8%AA%E0%B8%A7%E0%B8%991.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '      1. สำรวจพื้นที่ ถือเป็นสิ่งแรกที่ไม่ควรมองข้ามเลยนะคะ ซึ่งการสำรวจพื้นที่นั้น ไม่เพียงดูแค่ขนาดอย่างเดียว แต่ควรคำนึงถึง ทิศทางของแสง และประเภทของดิน เพราะสิ่งเหล่านี้ จะบอกได้ว่า เหมาะสำหรับการปลูกต้นไม้ประเภทไหนนั้นเองค่ะ'),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '      2. ศึกษารายละเอียดต้นไม้ หลังจากที่สำรวจพื้นที่เสร็จเรียบร้อยแล้ว จะทำให้ทราบว่า สวนของเพื่อนๆนั้น เหมาะหรือไม่เหมาะกับต้นไม้ประเภทไหน ซึ่งต้นไม้แต่ละประเภทก็ย่อมมีการปลูกและการดูแลที่แตกต่างกัน ฉะนั้นควรที่จะมีการศึกษาข้อมูลเกี่ยวกับต้นไม้ที่จะปลูกโดยละเอียดค่ะ'),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '      3. แบบสวน /ร่างแบบสวน สำหรับขั้นตอนนี้เพื่อนๆ ต้องชอบกันอย่างแน่นอน ซึ่งเป็นการหาแบบสวน และ ร่างแบบสวนที่เพื่อนๆ ต้องการ แต่แบบสวนที่เลือกนั้น ควรคำนึงถึงพื้นที่และต้นไม้ที่จะปลูกด้วยนะคะ เพราะสวนแต่ละแบบก็ย่อมมีลักษณะที่แตกต่างกันออกไป'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                  'https://www.infinitydesign.in.th/wp-content/uploads/2016/02/BG04SPR-77d-450x450.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       4. ปรับหน้าดิน / กำจัดวัชพืช สำหรับการปรับหน้าดินสิ่งที่ต้องใส่ใจเป็นพิเศษ นั้นก็คือ ในส่วนของน้ำ ไม่ว่าจะเป็นการวางท่อน้ำ การระบายน้ำ ซึ่งโดยทั่วไปจะไล่ระดับความสูงของดินให้สูงลงไปต่ำ ในบริเวณที่มีท่อระบายน้ำ เพื่อไม่ให้เกิดเป็นน้ำขังนั้นเอง อีกทั้งควรมีการปรับให้มีทางระบายน้ำเป็นอย่างดี'),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       5. กำหนดตำแหน่งการวางต้นไม้แบบคร่าวๆ ซึ่งการจัดวางนั้น ควรมีการเว้นระยะห่างของต้นไม้แต่ละต้นให้มีความสมดุลกัน ไม่ชิด หรือห่างจนเกิดไป เพราะส่งผลทำให้เกิดความไม่สวยงาม อีกทั้ง อาจทำให้ต้นไม้ตายได้ง่ายยิ่งขึ้นอีกด้วยค่ะ'),
            ),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       6. ปลูกต้นไม้ ซึ่งหากมีในส่วนของน้ำพุ แนะนำให้จัดวางน้ำพุให้เสร็จเรียบร้อยก่อนที่จะทำการปลูกต้นไม้ โดยวิธีการปลูกนั้น ควรดูลักษณะและวีธีการปลูกของต้นไม้แต่ละต้น อาทิประเภทไม้พุ่ม ควรขุดหลุมลึกประมาณ 0.4 – 0.5 m ส่วนประเภทไม้คลุมดิน ควรขุดลึกเพียง 0.25 – 0.3 m เป็นต้น หลังจากที่ทำการปลูกต้นไม้เสร็จเรียบร้อยแล้วนั้น เพื่อนๆ ควรที่จะหมั่นดูแล  รดน้ำ ใส่ปุ่ย ต้นไม้ อยู่เป็นประจำ เพื่อการเจริญเติบโตและความสวยงามของต้นไม้ค่ะ'),
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
                          ShowShopTypeFour(userModel: userModels[0])));
            },
                    child: Text(
                      'ไปร้านค้า',
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
