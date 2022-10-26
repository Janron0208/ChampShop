import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Five.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';

class GuildPageFive extends StatefulWidget {
  const GuildPageFive({Key? key}) : super(key: key);

  @override
  State<GuildPageFive> createState() => _GuildPageFiveState();
}

class _GuildPageFiveState extends State<GuildPageFive> {
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
                  Text('ทำห้องเก็บเสียงทำง่ายด้วยสิ่งของใกล้ตัว',
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
                  'https://www.naibann.com/wp-content/uploads/2018/10/DIY3-793x420.png'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       สำหรับครอบครัวที่ชื่นชอบความบันเทิงภายในบ้านก็มักจัมีเครื่องเสียง เครื่องดนตรีคุณภาพสูงที่ให้เสียงกระหึ่ม สร้างความบันเทิง และความสนุกสนานภายในบ้านได้เป็นอย่างดี แต่อย่างไรก็ตามเสียงที่ดังออกมาก็อาจจะรบกวนกับเพื่อนบ้านใกล้เคียง จนเกิดปัญหากันได้'),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //       'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       1. ติดตั้งผ้าม่าน หรือผ้าห่มผืนหนาๆ คุณสามารถดูดซับเสียงเล็กๆ น้อยๆ จากการทำกิจกรรมต่างๆ ภายในห้องได้โดยการติดตั้งผ้าห่มผืนหนาๆ เข้ากับผนังห้อง'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       2. ใช้ตู้ หรือชั้นวางหนังสือคุณสามารถทำให้ผนังหนาขึ้นและกันเสียงได้ง่ายขึ้นโดยการใช้ชั้นวางหรือตู้หนังสือ โดยจัดวางให้ชิดแนวผนัง ซึ่งหนังสือที่วางในชั้นก็จะช่วยเป็นชนวนกันเสียงได้ด้วย'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       3. วางเบาะเพื่อกันการสั่นสะเทือนเลือกใช้เบาะผ้า หรือเบาะโฟมมารองเครื่องเสียงภายในห้องเพื่อนกันการสั่นสะเทือน ก็จะสามารถลดเสียงจากแรงสั่นสะเทือนได้ในระดับหนึ่ง'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       4. ปิดช่องว่างใต้ประตูช่องว่างใต้ประตูมักจะเป็นจุดที่เสียงสามารถเล็ดลอดออกมาได้ ซึ่งสามารถปิดช่องนี้ได้ด้วยวัสดุจำพวกแผ่นยาง ก็จะช่วยลดเสียงที่เล็ดลอดได้'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       5. ติดแผ่นดูดซับเสียงเราสามารถติดตั้งแผ่นดูดซับเสียงได้ด้วยตัวเองง่ายๆ ซึ่งแผ่นดูดซับเสียงจะมีส่วนที่โค้งมนที่ช่วยการดูดซับเสียงได้ดี ซึ่งวิธีนี้ถือว่าเป็นวิธีที่นิยมกันมากที่สุด เพราะให้ประสิทธิภาพการเก็บเสียงได้ดี'),
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
                          ShowShopTypeFive(userModel: userModels[0])));
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
