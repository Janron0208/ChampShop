import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_Two.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../product/show_detail_product.dart';

class GuildPageTwo extends StatefulWidget {
  const GuildPageTwo({Key? key}) : super(key: key);

  @override
  State<GuildPageTwo> createState() => _GuildPageTwoState();
}

class _GuildPageTwoState extends State<GuildPageTwo> {

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
                  Text('ปูพื้นลามิเนต',
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
                  'https://www.kachathailand.com/wp-content/uploads/2022/03/220317-Content-%E0%B8%9B%E0%B8%B9%E0%B8%9E%E0%B8%B7%E0%B9%89%E0%B8%99%E0%B8%A5%E0%B8%B2%E0%B8%A1%E0%B8%B4%E0%B9%80%E0%B8%99%E0%B8%95%E0%B8%A7%E0%B8%B4%E0%B8%98%E0%B8%B5%E0%B8%97%E0%B8%B3%E0%B8%87%E0%B9%88%E0%B8%B2%E0%B8%A2%E0%B9%86-%E0%B8%97%E0%B8%B3%E0%B9%80%E0%B8%AD%E0%B8%87%E0%B9%84%E0%B8%94%E0%B9%89-%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%95%E0%B9%89%E0%B8%AD%E0%B8%87%E0%B8%88%E0%B9%89%E0%B8%B2%E0%B8%87%E0%B8%8A%E0%B9%88%E0%B8%B2%E0%B8%8702-1200x670.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  'ส่วนประกอบพื้นลามิเนต',
                      style: TextStyle(
                          fontSize: 20,)),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //       'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(
                      '     พื้นไม้ลามิเนตนั้น มีหลายเกรด แต่ละเกรดก็อาจมีส่วนประกอบ และกระบวนการผลิตที่แตกต่างกันไป สามารถแบ่งส่วนประกอบของแผ่นพื้นลามิเนต ได้เป็นชั้น ๆ ดังนี้'
                       ),
                       Text('- ชั้นรองพื้น เป็นวัสดุที่อยู่ชั้นล่างสุดของพื้นลามิเนต มีหน้าที่โดยตรงในการป้องกันไม่ให้ความชื้นจากพื้นคอนกรีตเข้าสู่ชั้นแกนหลัก และช่วยรักษาสมดุลไม่ให้พื้นไม้โก่งคดจนผิดรูป'),
                       Text('- ชั้นแกน ผลิตจากเส้นใย หรือชิ้นไม้นำมาบดย่อย ผสมกับกาว และสารประกอบต่าง ๆ แล้วนำมาบีบอัดด้วยความร้อน และแรงดันสูง จนได้วัสดุที่มีความแข็งแรงตามต้องการ'),
                       Text('- ชั้นปิดผิว เนื่องจากชั้นแกนหลักนั้น มีหน้าตาเหมือนไม้บดอัดแท่งที่ไร้ความสวยงาม จึงต้องมีการปิดผิวด้วยลายไม้หลากหลายเฉดสี  เพื่อทำให้พื้นลามิเนตมีความสวยงามมากขึ้น'),
                       Text('- ชั้นเคลือบผิว เพื่อเพิ่มความทนทาน พื้นไม้ลามิเนต จึงต้องเคลือบผิวด้วยวัสดุที่มีคุณสมบัติกันรอย คุณภาพของชั้นเคลือบผิว จึงส่งผลต่อราคาและความทนทานของพื้นลามิเนต'),
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
                            title: 'guild', guild: '2',
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
