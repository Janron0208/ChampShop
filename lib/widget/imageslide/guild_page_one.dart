import 'dart:convert';

import 'package:champshop/widget/product/show_shop_type_one.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../utility/my_constant.dart';

class GuildPageOne extends StatefulWidget {
  const GuildPageOne({Key? key}) : super(key: key);

  @override
  State<GuildPageOne> createState() => _GuildPageOneState();
}

class _GuildPageOneState extends State<GuildPageOne> {
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
                  Text('บ่อปลาคาร์พ',
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
                  'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/38.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       “ฮวงจุ้ย” เป็นเพียงปัจจัยหนึ่งที่จะเป็นตัวช่วยส่งเสริมสนับสนุนให้คนคนนั้นสามารถดำเนินชีวิตไปได้อย่างมีความสุข เปรียบเสมือนกับคนเราที่เจอปัญหาวุ่นวายมาจากที่ทำงาน เวลากลับมาบ้านก็อยากที่จะพักผ่อนคายความเครียด'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                  'https://img.thaibuffer.com/u/2022/Jarosphan/Home/Garden/122581/40.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                  '       ปัจจุบันปลาคาร์ฟเป็นที่ยกย่องและยอมรับกันโดยทั่วไปว่าเป็น “จ้าวแห่งปลาเลี้ยงของโลก” นอกจากจะมีการเลี้ยงกันอย่างกว้างขวางในประเทศญี่ปุ่นแล้วยังได้มีการแพร่ขยายไปทั่วโลก เช่น สหรัฐอเมริกา อังกฤษ คานาดา เกาหลี'),
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
                          ShowShopTypeOne(userModel: userModels[0])));
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
