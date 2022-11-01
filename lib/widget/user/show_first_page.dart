import 'dart:convert';
import 'package:champshop/screens/show_cart.dart';
import 'package:champshop/widget/imageslide/guild_page_five.dart';
import 'package:champshop/widget/imageslide/guild_page_four.dart';
import 'package:champshop/widget/imageslide/guild_page_three.dart';
import 'package:champshop/widget/imageslide/guild_page_two.dart';
import 'package:champshop/widget/user/show_information_shop.dart';

import 'package:champshop/model/user_model.dart';

import 'package:champshop/widget/product/show_shop_type_all.dart';
import 'package:champshop/widget/user/show_setting.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/product_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';

import '../imageslide/guild_page_one.dart';

class ShowFirstPage extends StatefulWidget {
  const ShowFirstPage({Key? key}) : super(key: key);

  @override
  State<ShowFirstPage> createState() => _ShowFirstPageState();
}

class _ShowFirstPageState extends State<ShowFirstPage> {
  List<UserModel> userModels = [];
  UserModel? userModel;
  String? idShop = '1';
  List<ProductModel> productModels = [];
  String? nameUser;
  String? nickname;
  String? phoneUser;
  String? addressUser;
  String? lat;
  String? lng;
  String? urlPicture;

  Location location = Location();
  double? lat1, lng1;
  double? lat2 = 13.712754;
  double? lng2 = 100.434610;
  String? distanceString;
  int? transport;
  late CameraPosition position;

  @override
  void initState() {
    super.initState();
    readShop();
    readProductMenu();
    checkPreferance();
    findLat1Lng1();
   readCurrentInfo();
  }

  Future<Null> findLat1Lng1() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat1 = locationData!.latitude!;
      lng1 = locationData.longitude!;
      // lat2 = double.parse(userModel.lat);
      print('lat1 = $lng1, lng1 = $lng1, lat2 = $lat2, lng2 = $lng2');
    });
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

   Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUSer = preferences.getString('id');
    print('idUser ==>> $idUSer');

    String url =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$idUSer';

    Response response = await Dio().get(url);
    // print('response ==>> $response');

    var result = json.decode(response.data);
    print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nickname = userModel?.nickname;
 
      });
    }
  }

  Future<void> checkPreferance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
      nickname = preferences.getString('Nickname');
      phoneUser = preferences.getString('Phone');
      addressUser = preferences.getString('Address');
      lat = preferences.getString('Lat');
      lng = preferences.getString('Lng');
      // slip = preferences.getString('Slip');
      urlPicture = preferences.getString('UrlPicture');
      // print('$nameUser $nicknameUser $phoneUser $addressUser $lat $lng $urlPicture');
    });
  }

  Future<Null> readProductMenu() async {
    idShop = '1';
    String url = '${MyConstant().domain}/champshop/getProductTypeAll.php?isAdd';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    // print('res ==> $result');
    for (var map in result) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        productModels.add(productModel);
      });
    }
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
          // print('NameShop = ${model.nameShop}');
          setState(() {
            userModels.add(model);
            // shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 202, 125),
      appBar: AppBar(
        
        title: Text( nickname == null ? 'ยินดีต้อนรับ *****' : 'ยินดีต้อนรับ $nickname' ,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
            )), actions: <Widget>[
               Padding(
      padding: EdgeInsets.only(right: 30.0),
      child: GestureDetector(
        onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShowInfarmationShop()));
              },
        child: Icon(
            Icons.chat
        ),
      )
    ),
    Padding(
      padding: EdgeInsets.only(right: 30.0),
      child: GestureDetector(
        onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return ShowCart();
                    }));
              },
        child: Icon(
            Icons.shopping_cart
        ),
      )
    ),
    
  ],
        backgroundColor: Color.fromARGB(255, 254, 202, 125),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                color: Color.fromARGB(236, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageOne()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageTwo()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageThree()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageFour()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner4.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageFive()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner5.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 

 

  Container showHeadText1() {
    return Container(
      width: 350,
      height: 60,
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, 205, 50, 205),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'สินค้าใหม่',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 241, 122, 89)),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowShopTypeAll(userModel: userModels[0])));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'ดูเพิ่มเติม >',
                    style: TextStyle(
                        fontSize: 13,
                        // fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 105, 105, 105)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  

 

  
}
