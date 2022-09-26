import 'package:flutter/material.dart';

class ListProductMenuList extends StatefulWidget {
  const ListProductMenuList({Key? key}) : super(key: key);

  @override
  State<ListProductMenuList> createState() => _ListProductMenuListState();
}

class _ListProductMenuListState extends State<ListProductMenuList> {
  @override
  Widget build(BuildContext context) {
    return Text(
      'รายการสินค้าทั้งหมด'
    );
  }
}