import 'package:flutter/material.dart';

class ShowDetailProduct extends StatefulWidget {
  const ShowDetailProduct({Key? key}) : super(key: key);

  @override
  State<ShowDetailProduct> createState() => _ShowDetailProductState();
}

class _ShowDetailProductState extends State<ShowDetailProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('รายระเอียดสินค้า'),
    );
  }
}