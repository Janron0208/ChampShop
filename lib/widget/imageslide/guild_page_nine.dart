import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Five.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageNine extends StatefulWidget {
  const GuildPageNine({Key? key}) : super(key: key);

  @override
  State<GuildPageNine> createState() => _GuildPageNineState();
}

class _GuildPageNineState extends State<GuildPageNine> {
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
                  Text('สีพลาสติก คืออะไร?',
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
                  'https://www.kachathailand.com/wp-content/uploads/2022/11/221104-Content-%E0%B8%A3%E0%B8%B9%E0%B9%89%E0%B8%88%E0%B8%B1%E0%B8%81%E0%B8%81%E0%B8%B1%E0%B8%9A-%E0%B8%AA%E0%B8%B5%E0%B8%9E%E0%B8%A5%E0%B8%B2%E0%B8%AA%E0%B8%95%E0%B8%B4%E0%B8%8102-1200x670.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       สีพลาสติก หรือ สีอะคริลิค ผลิตขึ้นจากลาเท็กซ์ พีวีเอซี โคพอลิเมอร์ (latex PVAc copolymer) ผสมกับแม่สี เป็นสีที่สามารถใช้น้ำเป็นตัวทำละลาย หรือผสมสีให้เจือจาง เป็นสีที่สามารถใช้ทาได้ทั้งภายใน และภายนอก สำหรับงานทาผิวพื้นปูน หรือคอนกรีตทั่วไป รวมทั้งอิฐ และกระเบื้องแผ่นเรียบ'),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //       'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       สีพลาสติก สามารถแบ่งออกได้เป็น 2 ชนิด ได้แก่ สีสำหรับทาภายใน และสีสำหรับทาภายนอก โดยสีพลาสติก สำหรับทาภายนอก จะมีคุณสมบัติในการทนต่อแดด และฝนได้ดีกว่าสีชนิดทาภายใน มีจำหน่ายอยู่ในท้องตลาดมากมายหลายยี่ห้อ แต่ละยี่ห้อ ก็มีคุณสมบัติ และความคงทนของสี ที่แตกต่างกันออกไปขึ้นอยู่กับส่วนผสม และปริมาณของเนื้อสีที่มีอยู่'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       สีพลาสติกทาภายนอก ถูกออกแบบมาให้พร้อมเผชิญกับสภาวะแดด และฝนโดยตรง จึงต้องเพิ่มสารพิเศษต่าง ๆ เพื่อเพิ่มคุณสมบัติให้ใช้งานได้ดี และยาวนาน จึงมีความทนทานกว่า และมีราคาที่สูงกว่าสีทาภายใน โดยสามารถใช้ทาได้ทั้งภายนอก และภายในบ้าน'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       สีทาภายใน ถูกออกแบบมาให้ใช้ทาภายในอาคารเท่านั้น หากนำไปใช้ทาภายนอก จะทำให้สีหลุดล่อน และซีดจางได้ มีข้อดี คือ กลิ่น และสารเคมีเบาบางกว่าสีพลาสติกทาภายนอก'),
            ),
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
                            title: 'K', guild: '',
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
