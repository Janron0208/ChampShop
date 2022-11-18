import 'dart:convert';

import 'package:champshop/model/user_model.dart';
import 'package:champshop/widget/product/show_shop_type_Three.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageThree extends StatefulWidget {
  const GuildPageThree({Key? key}) : super(key: key);

  @override
  State<GuildPageThree> createState() => _GuildPageThreeState();
}

class _GuildPageThreeState extends State<GuildPageThree> {
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
                  Text('ซ่อมท่อประปา',
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
                  'https://www.kachathailand.com/wp-content/uploads/2022/10/221013-Content-%E0%B8%97%E0%B9%88%E0%B8%AD%E0%B8%9B%E0%B8%A3%E0%B8%B0%E0%B8%9B%E0%B8%B2%E0%B8%A3%E0%B8%B1%E0%B9%88%E0%B8%A7%E0%B9%83%E0%B8%95%E0%B9%89%E0%B8%9E%E0%B8%B7%E0%B9%89%E0%B8%99%E0%B8%9A%E0%B9%89%E0%B8%B2%E0%B8%9902-1200x670.jpg'),
            ),
            Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '     ปัญหาท่อประปารั่วใต้พื้นบ้าน น้ำรั่ว น้ำซึม ตามพื้น ตามผนังบ้าน เป็นปัญหาที่พบเจอได้บ่อยครั้ง ซึ่งนอกจากจะสร้างความรำคาญให้แก่ผู้อยู่อาศัยแล้ว หลายครั้งที่มักจะเกิดปัญหาอื่น ๆ ตามมา ไปจนถึงโครงสร้างบ้านได้รับความเสียหาย จากการที่เหล็กเสริมในคอนกรีตเป็นสนิม โดยมีสาเหตุ และแนวทางการแก้ไขต่างกันไป บทความนี้ KACHA จะพาไปรู้ถึงวิธีแก้ปัญหา ท่อประปารั่วใต้พื้นบ้าน ที่เราสามารถแก้ได้ ก่อนปัญหาจะบานปลาย ไปดูกัน'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  'สาเหตุ ท่อประปารั่วใต้พื้นบ้าน',
                      style: TextStyle(
                          fontSize: 20,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
 Text('- รอยแตกร้าว รอยแตกร้าวของผนัง หรือระหว่างผนัง และพื้น อาจเป็นหนึ่งในสาเหตุที่ไปกระทบกับท่อน้ำ ที่ถูกฝังอยู่ในผนังบ้าน หรือใต้พื้นบ้าน'),
                   Text('- ข้อต่อท่อ เป็นจุดที่เกิดปัญหาค่อนข้างบ่อย เพราะตอนวางระบบน้ำ ช่างอาจจะใช้แรงมากเกินไปจนท่อร้าวได้ หรือบางกรณีอัดกาวไม่แน่นพอ จะเกิดท่อหลวม ซึ่งเมื่อเป็นการร้าวของท่อที่ฝังอยู่ใน พื้นใต้บ้าน หรือกำแพง อาจจะต้องสกัดปูน เพื่อเปลี่ยนข้อต่อท่อในส่วนนั้น'),
                   Text('- แรงดันภายในท่อน้ำ ช่วงที่ไฟฟ้าดับ ทำให้เครื่องสูบน้ำหยุดทำงานฉับพลัน แต่เมื่อไฟฟ้ากลับมาปกติ อาจเกิดการกระแทกกลับของน้ำในท่อ เป็นสาเหตุหนึ่ง ที่ทำให้ท่อประปาแตกได้ หรือการที่ปล่อยให้ ถังเก็บน้ำแห้งเป็นประจำ อากาศจะเข้าไปแทนที่ภายในท่อ และเมื่อเปิดใช้น้ำ จะเกิดแรงอัดจนท่อแตกได้'),
                   Text('- ดินทรุด เป็นสาเหตุที่สังเกตได้ค่อนข้างยาก เพราะบ้านที่ปลูกสร้างไว้หลายปี อาจเกิดปัญหาดินทรุดแบบไม่รู้ตัว หรืออาจทรุด เฉพาะส่วนที่ต่อเติมบ้านออกไป จนกระทบท่อน้ำขยับ จนหลุดตามไปด้วย '),
                   Text('- งานติดตั้งที่ไม่ได้มาตรฐาน ความชำนาญของช่าง เป็นสิ่งที่มองข้ามไม่ได้ ถ้าได้ช่างที่ไม่ได้มาตรฐาน มักทำให้งานมีปัญหาหลังจากที่ใช้งานไปได้ระยะหนึ่ง ที่พบมาก คือ น้ำรั่วบริเวณข้อต่อต่าง ๆ เนื่องจากการต่อท่อไม่ได้มาตรฐาน หรือไม่ทดสอบแรงดันน้ำในเส้นท่อก่อน ส่งผลให้เกิดปัญหาในภายหลัง อีกทั้งขั้นตอนในการต่อท่อ ก็ต้องทำให้เรียบร้อย เลือกช่างที่ไว้ใจได้ เพื่อที่จะได้งานระบบประปาที่มีคุณภาพ ใช้ไปได้นาน'),
                ],
              ),
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
                            title: 'guild', guild: '3',
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
