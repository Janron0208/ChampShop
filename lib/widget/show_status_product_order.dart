import 'package:flutter/material.dart';

class ShowStatusProductOrder extends StatefulWidget {
  const ShowStatusProductOrder({Key? key}) : super(key: key);

  @override
  State<ShowStatusProductOrder> createState() => _ShowStatusProductOrderState();
}

class _ShowStatusProductOrderState extends State<ShowStatusProductOrder> {
  @override
  Widget build(BuildContext context) {
    return Text('รายการสินค้าที่สั่งซื้อ');
  }
}