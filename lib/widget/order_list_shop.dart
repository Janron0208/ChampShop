import 'package:champshop/model/user_model.dart';
import 'package:flutter/material.dart';

class OrderListShop extends StatefulWidget {
  const OrderListShop({Key? key}) : super(key: key);

  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Text('แสดงสินค้าที่ลูกค้าสั่ง');
  }
}
