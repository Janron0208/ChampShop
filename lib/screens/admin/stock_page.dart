import 'dart:convert';

import 'package:champshop/model/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../utility/my_constant.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<ProductModel> productModels = [];
  List<ProductModel> stockModels = [];
  // int? resultstocks;

  Future<Null> readProductMenu() async {
    String url = '${MyConstant().domain}/champshop/getProductTypeAll.php?isAdd';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    for (var map in result) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        productModels.add(productModel);
      });
    }
  }

  Future<Null> readProductStock() async {
    String url =
        '${MyConstant().domain}/champshop/getproductapi/getProductWhereStock.php?isAdd=true';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    for (var map in result) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        stockModels.add(productModel);
        print(stockModels.length);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readProductMenu();
    readProductStock();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('จำนวนสินค้าหมด : ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontSize: 16)),
                    Text('${productModels.length}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 51, 211, 88),
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Text('จำนวนรายการที่สินค้าหมด : ',
                        style: TextStyle(
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontSize: 16)),
                    Text('${stockModels.length}',
                        style: TextStyle(
                            color: Color.fromARGB(255, 211, 54, 51),
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width * 1.80,
            child: ListView.builder(
                itemCount: productModels.length,
                itemBuilder: (context, index) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 8),
                                width: MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${MyConstant().domain}${productModels[index].pathImage!}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                productModels[index].nameProduct!,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 57, 57, 57),
                                    fontSize: 16),
                              )),
                              Container(
                                width: 50,
                                height: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    productModels[index].stock! == '0'
                                        ? Text('หมด',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 230, 6, 6),
                                                fontSize: 20))
                                        : Text(
                                            '${productModels[index].stock!} ชิ้น',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 222, 125, 80),
                                                fontSize: 16)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider()
                      ],
                    )),
          ),
        ],
      ),
    );
  }
}
