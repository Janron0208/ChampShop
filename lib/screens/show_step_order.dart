import 'package:flutter/material.dart';

import '../model/order_model.dart';
import '../utility/my_style.dart';
import '../widget/order_list_shop.dart';
import '../widget/steporder/order_list_shop_rider.dart';

class ShowStepOrder extends StatefulWidget {
  final OrderModel orderModel;
  const ShowStepOrder({Key? key, required this.orderModel}) : super(key: key);

  @override
  State<ShowStepOrder> createState() => _ShowStepOrderState();
}

class _ShowStepOrderState extends State<ShowStepOrder> {
  OrderModel? orderModel;
  List<Widget> listWidgets = [];
  int indexPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderModel = widget.orderModel;
    listWidgets.add(OrderListShop(
      // orderModel: orderModel!,
    ));
    listWidgets.add(OrderListShopRider(
      // orderModel: orderModel!,
    ));
  }

  BottomNavigationBarItem aboutShopNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.restaurant), label: 'รอยืนยัน'
        // title: Text('รายละเอียดร้าน'),
        );
  }

  BottomNavigationBarItem showMenuFoodNav() {
    return BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu), label: 'กำลังจัดส่ง'
        // title: Text('เมนูอาหาร'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(orderModel!.nameShop!),
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
