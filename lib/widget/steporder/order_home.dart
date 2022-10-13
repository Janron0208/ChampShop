// ignore_for_file: prefer_const_constructors

import 'package:champshop/widget/steporder/order_list_shop_await.dart';
import 'package:champshop/widget/steporder/order_list_shop_finish.dart';
import 'package:champshop/widget/steporder/order_list_shop_rider.dart';
import 'package:flutter/material.dart';
import '../../utility/my_style.dart';

class OrderHome extends StatefulWidget {
  const OrderHome({Key? key}) : super(key: key);

  @override
  State<OrderHome> createState() => _OrderHomeState();
}

class _OrderHomeState extends State<OrderHome> {
  int indexPage = 0;
  List<Widget> listWidgets = [];

  @override
  void initState() {
    super.initState();

    listWidgets.add(OrderListShopAwait());
    listWidgets.add(OrderListShopRider());
    listWidgets.add(OrderListShopFinish());
  }

  BottomNavigationBarItem awaitOrderNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.priority_high), label: 'รอยืนยัน');
  }

  BottomNavigationBarItem riderOrderNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.motorcycle), label: 'กำลังจัดส่ง');
  }

  BottomNavigationBarItem finishOrderNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.verified), label: 'สำเร็จ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listWidgets.length == 0
          ? MyStyle().showProgress()
          : listWidgets[indexPage],
      bottomNavigationBar: showBottonNavigationBar(),
    );
  }

  BottomNavigationBar showBottonNavigationBar() => BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 224, 224, 224),
        // selectedFontSize: 20,
        selectedItemColor: Color.fromARGB(255, 86, 185, 56),
        unselectedItemColor: Color.fromARGB(255, 121, 126, 119),
        currentIndex: indexPage,
        onTap: (value) {
          setState(() {
            indexPage = value;
          });
        },
        items: <BottomNavigationBarItem>[
          awaitOrderNav(),
          riderOrderNav(),
          finishOrderNav(),
        ],
      );
}
