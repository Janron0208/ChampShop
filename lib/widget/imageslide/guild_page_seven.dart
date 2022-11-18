import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Five.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageSeven extends StatefulWidget {
  const GuildPageSeven({Key? key}) : super(key: key);

  @override
  State<GuildPageSeven> createState() => _GuildPageSevenState();
}

class _GuildPageSevenState extends State<GuildPageSeven> {
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
                  Text('วิธีอุดรูตะปูและสว่านให้กลับมาเรียบเนียน',
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
                  'http://rk.co.th/wp-content/uploads/2018/01/hw_02.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '        เชื่อว่าผนังบ้านทุกหลังต้องมีรูจากตะปูหรือรูจากสิ่งของอื่น ๆ อย่างน้อยสักรู สองรูแน่ ๆ แต่จะดีกว่าไหมถ้าหากเราสามารถกำจัดรูเหล่านั้นให้หายไปได้ ด้วยวิธีการที่แสนง่าย แถมยังใช้อุปกรณ์ที่ใกล้ตัว เช่น ยาสีฟัน เบกกิ้งโซดา สบู่ก้อน แป้ง หรือสีเทียน โดยในวันนี้กระปุกดอทคอมก็ได้นำวิธีการอุดรูบนผนังดี ๆ เหล่านี้มาฝากกัน ถ้าหากอยากรู้ว่าแต่ละอย่างมีขั้นตอนการอุดรูได้อย่างไร เรามาดูไปพร้อม ๆ กันเลย'),
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
                      '       1. กาวเอลเมอร์'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '        กาวเอลเมอร์ (Elmer\'s glue) เป็นกาวไม้ชนิดหนึ่งที่เราสามารถนำมาอุดรูต่าง ๆ บนผนังได้ แต่ต้องเป็นรูที่มีขนาดเล็ก ๆ เท่านั้น โดยวิธีการทำให้เราหยอดก้าวเอลเมอร์เข้าไปในรู สามารถใช้คอตตอนบัดช่วยในการหยอดได้ โดยควรพยายามหยอดให้กาวไหลออกมาน้อยที่สุด จากนั้นก็รอจนกาวแข็ง แล้วตัดชั้นกาวส่วนที่ยื่นโผล่ออกมาออก พร้อมทั้งทาสีส่วนที่เราอุดให้สีเข้ากันกับผนัง เท่านี้ก็จะได้ผนังสวย ๆ เนียน ๆ กลับมาแล้ว'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Text(
                      '       2. เบกกิ้งโซดา'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '        แน่นอนว่าเบกกิ้งโซดา แป้งทำขนมสารพัดประโยชน์ก็สามารถอุดรูตะปูบนกำแพงได้เหมือนกัน โดยให้เราผสมเบกกิ้งโซดาเข้ากับกาวสีขาว แล้วนำไปเติมในรูให้เต็ม ซึ่งบอกได้เลยว่าวิธีนี้ทำให้เราได้ส่วนผสมที่เหนียวแน่นเหมาะแก่การอุดรูตะปูแบบสุด ๆ โดยพออุดรูตะปูเสร็จ ก็ให้นำเกรียงมาปาดให้เรียบเหมือนกันกับวิธียาสีฟัน หลังจากนั้นก็ทาสีบริเวณที่เราอุดไปนั้นให้เข้ากันกับสีผนังบ้านของเราได้เลย'),
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
                            title: 'guild', guild: '7',
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
