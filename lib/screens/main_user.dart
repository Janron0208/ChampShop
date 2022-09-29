import 'dart:convert';
import 'dart:io';

import 'package:champshop/screens/show_cart.dart';
import 'package:champshop/screens/show_shop_product_menu.dart';
import 'package:champshop/utility/my_constant.dart';
import 'package:champshop/utility/signout_process.dart';
import 'package:champshop/widget/show_status_product_order.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../utility/my_style.dart';
import '../widget/show_list_shop_all.dart';

class MainUser extends StatefulWidget {
  const MainUser({Key? key}) : super(key: key);

  @override
  State<MainUser> createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  String? nameUser;

  Widget? currentWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWidget = ShowListShopAll();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(nameUser == null ? 'ลูกค้า' : 'ยินดีต้อนรับ $nameUser'),
          actions: [
            MyStyle().iconShowCart(context)
          ],
        ),
        drawer: showDrawer(),
        body: currentWidget);
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                showHead(),
                menuListShop(),
                menuCart(),
                menuStatusProductOrder(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                menuSignOut(),
              ],
            ),
          ],
        ),
      );

  ListTile menuListShop() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.pop(context);
          currentWidget = ShowListShopAll();
        });
      },
      leading: Icon(Icons.home),
      title: Text('แสดงสินค้าทั้งหมด'),
    );
  }

  ListTile menuStatusProductOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          Navigator.pop(context);
          currentWidget = ShowStatusProductOrder();
        });
      },
      leading: Icon(Icons.card_giftcard_sharp),
      title: Text('แสดงรายการสินค้าที่สั่ง'),
    );
  }

  Widget menuSignOut() {
    return Container(
      decoration: BoxDecoration(color: Color.fromARGB(255, 255, 101, 109)),
      child: ListTile(
        onTap: () => signOutProcess(context),
        leading: Icon(
          Icons.exit_to_app,
          color: Colors.white,
          size: 30,
        ),
        title: Text('ออกจากระบบ',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    );
  }

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      // decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        nameUser ?? 'Name Login',
        style: TextStyle(color: MyStyle().greenColor2),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: MyStyle().fontColor3),
      ),
    );
  }
  
  Widget menuCart() {
    return ListTile(
      leading: Icon(Icons.add_shopping_cart),
      title: Text('ตะกร้าสินค้า'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowCart(),
        );
        Navigator.push(context, route);
      },
    );
  }
}
