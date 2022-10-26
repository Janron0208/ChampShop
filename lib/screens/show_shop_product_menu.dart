import 'package:champshop/widget/about_shop.dart';
import 'package:champshop/widget/show_menu_product.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../utility/my_style.dart';

class ShowShopProductMenu extends StatefulWidget {
  final UserModel userModel;
  const ShowShopProductMenu({Key? key, required this.userModel})
      : super(key: key);

  @override
  State<ShowShopProductMenu> createState() => _ShowShopProductMenuState();
}

class _ShowShopProductMenuState extends State<ShowShopProductMenu> {
  UserModel? userModel;
  List<Widget> listWidgets =[];
  int indexPage = 0;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    listWidgets.add(AboutShop(
      // userModel: userModel!,
    ));
    listWidgets.add(ShowMenuProduct(
      userModel: userModel!,
    ));
  }

  

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'รายละเอียดร้าน'
      // title: Text('รายละเอียดร้าน'),
    );
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: 'รายการสินค้า'
      // title: Text('เมนูอาหาร'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.nameShop!),
      ),
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
      bottomNavigationBar: showBottonNavigationBar(),
    );
  }

  BottomNavigationBar showBottonNavigationBar() => BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          aboutShopNav(),
          showMenuFoodNav(),
        ],
      );
}