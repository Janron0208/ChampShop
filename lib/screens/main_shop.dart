import 'dart:io';

import 'package:champshop/widget/infomation_shop.dart';
import 'package:champshop/widget/list_product_menu_shop.dart';
import 'package:champshop/widget/order_list_shop.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../utility/my_style.dart';
import '../utility/signout_process.dart';

class MainShop extends StatefulWidget {
  const MainShop({Key? key}) : super(key: key);

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  Widget currentWidget = OrderListShop();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // aboutNotification();
  }

  // Future<Null> aboutNotification() async {
  //   if (Platform.isAndroid) {
  //     print('aboutNoti Work Android');

  //     FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //     await firebaseMessaging.configure(
  //       onLaunch: (message) async {
  //         print('Noti onLaunch');
  //       },
  //       onResume: (message) async {
  //         String title = message['data']['title'];
  //         String body = message['data']['body'];
  //         print('Noti onResume ${message.toString()}');
  //         print('title = $title, body = $body');
  //         normalDialog2(context, title, body);
  //       },
  //       onMessage: (message) async {
  //         print('Noti onMessage ${message.toString()}');
  //         String title = message['notification']['title'];
  //         String notiMessage = message['notification']['body'];
  //         normalDialog2(context, title, notiMessage);
  //       },
  //     );
  //   } else if (Platform.isIOS) {
  //     print('aboutNoti Work iOS');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เจ้าของร้าน'),
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHead(),
            homeMenu(),
            productMenu(),
            infomationMenu(),
            signOutMenu(),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.production_quantity_limits),
        title: Text('สินค้าที่ถูกสั่งซื้อ'),
        // subtitle: Text('รายการอาหารที่ยังไม่ได้ ทำส่งลูกค้า'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile productMenu() => ListTile(
        leading: Icon(Icons.list_alt),
        title: Text('รายการสินค้าทั้งหมด'),
        // subtitle: Text('รายการอาหาร ของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = ListProductMenuList();
          });
          Navigator.pop(context);
        },
      );

  ListTile infomationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายละเอียดของร้าน'),
        // subtitle: Text('รายละเอียด ของร้าน พร้อม Edit'),
        onTap: () {
          setState(() {
            currentWidget = InfomationShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('Sign Out และกลับไปหน้าแรก'),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      // decoration: MyStyle().myBoxDecoration('user.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text('Name Login'
          // nameUser == null ? 'Name Login' : nameUser,
          // style: TextStyle(color: MyStyle().darkColor),
          ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: MyStyle().fontColor3),
      ),
    );
  }
}
