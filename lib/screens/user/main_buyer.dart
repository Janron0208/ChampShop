import 'dart:convert';

import 'package:champshop/screens/show_cart.dart';
import 'package:champshop/screens/show_shop_product_menu.dart';
import 'package:champshop/widget/about_shop.dart';
import 'package:champshop/widget/product/show_shop_type_all.dart';
import 'package:champshop/widget/show_list_shop_all.dart';
import 'package:champshop/widget/user/show_first_page.dart';
import 'package:champshop/widget/user/show_menu_all.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';
import '../../widget/show_status_product_order.dart';
import '../../widget/user/show_setting.dart';

class MainBuyer extends StatefulWidget {
  const MainBuyer({Key? key}) : super(key: key);

  @override
  State<MainBuyer> createState() => _MainBuyerState();
}

class _MainBuyerState extends State<MainBuyer> {
  List<UserModel> userModels = [];
  UserModel? userModel;
  String? nameUser;
  String? phoneUser;
  String? addressUser;
  String? lat;
  String? lng;
  String? slip;
  String? urlPicture;
  bool load = true;
  int selectedPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userModel = widget.userModel;
    findUser();
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
            // shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  final _pageOptions = [
    ShowFirstPage(),
    // ShowListShopAll(),
    ShowMenuAll(),
    // ShowShopTypeAll(),
    ShowStatusProductOrder(),
    ShowCart(),
    // AboutShop()
  ];

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
      phoneUser = preferences.getString('Phone');
      addressUser = preferences.getString('Address');
      lat = preferences.getString('Lat');
      lng = preferences.getString('Lng');
      slip = preferences.getString('Slip');
      urlPicture = preferences.getString('UrlPicture');
      print('$nameUser $phoneUser $addressUser $lat $lng $slip $urlPicture');
    });
  }

  Future<Null> readApiAllShop() async {
    String urlAPI = '${MyConstant().domain}/champshop/getUserWhereSeller.php';
    await Dio().get(urlAPI).then((value) {
      setState(() {
        load = false;
      });
      // print('value ==> $value');
      var result = json.decode(value.data);
      // print('result = $result');
      for (var item in result) {
        // print('item ==> $item');
        UserModel model = UserModel.fromJson(item);
        // print('name ==>> ${model.name}');
        setState(() {
          userModels.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        // actions: [MyStyle().iconShowCart(context)],
        //   elevation: 0,
        //   backgroundColor: Colors.transparent,
        // ),
        body: _pageOptions[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 30),
              activeIcon: Icon(Icons.home, size: 30),
              label: 'หน้าแรก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined, size: 30),
              activeIcon: Icon(Icons.shopping_bag, size: 30),
              label: 'ร้านค้า',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_crash_outlined, size: 30),
              label: 'จัดส่ง',
              activeIcon: Icon(Icons.car_crash, size: 30),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined, size: 30),
              activeIcon: Icon(Icons.shopping_cart, size: 30),
              label: 'ตะกร้า',
            ),
           
          ],
          unselectedFontSize: 10,
          selectedFontSize: 15,
          showUnselectedLabels: mounted,
          selectedItemColor: Color.fromARGB(255, 255, 161, 98),
          elevation: 30.0,
          unselectedItemColor: Color.fromARGB(255, 122, 122, 122),
          currentIndex: selectedPage,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          onTap: (index) {
            setState(() {
              selectedPage = index;
            });
          },
        ));
  }
}
