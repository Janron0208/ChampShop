import 'dart:convert';

import 'package:champshop/model/product_model.dart';
import 'package:champshop/utility/my_constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SearchListExample extends StatefulWidget {
  const SearchListExample({Key? key}) : super(key: key);

  @override
  State<SearchListExample> createState() => _SearchListExampleState();
}

class _SearchListExampleState extends State<SearchListExample> {
  Widget appBarTitle = new Text(
    "",
    style: new TextStyle(color: Colors.white),
  );


  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );


  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  late List<dynamic> _list;
  bool? _isSearching;
  String _searchText = "";
  List searchresult = [];


  _SearchListExampleState() {
    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controller.text;
        });
      }
    });
  }
  @override
  void initState() {
    super.initState();
    _isSearching = false;
    values();
    readProductMenu();
  }

  String? idShop, title, showtext;
  List<ProductModel> productModels = [];

  Future<Null> readProductMenu() async {
    idShop = '1';
    String type = 'All';
    print(type);
    _list = [];
    if (type == 'Sale') {
      String url =
          '${MyConstant().domain}/champshop/apishowproducttype/getProductTypeSale.php?isAdd=true';

      Response response = await Dio().get(url);
      // print('res ==> $response');

      var result = json.decode(response.data);

      print('res ==> $result');

      for (var map in result) {
        ProductModel productModel = ProductModel.fromJson(map);
        setState(() {
          productModels.add(productModel);
        });
      }
    } else if (type == 'All') {
      idShop = '1';
      String url =
          '${MyConstant().domain}/champshop/getProductTypeAll.php?isAdd';
      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      for (var map in result) {
        ProductModel productModel = ProductModel.fromJson(map);
        setState(() {
          productModels.add(productModel);

          // print(productModel.nameProduct);
          _list;

          _list.add(productModel.nameProduct);

          print(_list);
        });
      }
    } else {
      String url =
          '${MyConstant().domain}/champshop/getproductapi/getProductWhereIdShopAndType.php?isAdd=true&Type=$type';
      Response response = await Dio().get(url);
      var result = json.decode(response.data);
      for (var map in result) {
        ProductModel productModel = ProductModel.fromJson(map);
        setState(() {
          productModels.add(productModel);
        });
      }
    }

    if (type == 'A') {
      showtext = 'โครง,ล้อ';
    } else if (type == 'B') {
      showtext = 'งานประปา';
    } else if (type == 'C') {
      showtext = 'งานสวน';
    } else if (type == 'D') {
      showtext = 'รถเข็น';
    } else if (type == 'E') {
      showtext = 'โครงรถเข็นปูน';
    } else if (type == 'F') {
      showtext = 'เปล';
    } else if (type == 'G') {
      showtext = 'กระเบื้องยาง';
    } else if (type == 'H') {
      showtext = 'ถังปูน';
    } else if (type == 'I') {
      showtext = 'ปูน';
    } else if (type == 'J') {
      showtext = 'เครื่องมือ';
    } else if (type == 'K') {
      showtext = 'สีทาภายในภายนอก';
    } else if (type == 'L') {
      showtext = 'งานสีอื่นๆ';
    } else if (type == 'M') {
      showtext = 'สเปรย์';
    } else if (type == 'Z') {
      showtext = 'อื่นๆ';
    } else if (type == 'All') {
      showtext = 'สินค้าทั้งหมด';
    } else {
      showtext = 'สินค้าลดราคา';
    }
  }

  void values() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
          new IconButton(
            icon: icon,
            onPressed: () {
              setState(() {
                if (this.icon.icon == Icons.search) {
                  this.icon = new Icon(
                    Icons.close,
                    color: Colors.white,
                  );
                  this.appBarTitle = new TextField(
                    controller: _controller,
                    style: new TextStyle(
                      color: Colors.white,
                    ),
                    decoration: new InputDecoration(
                        prefixIcon: new Icon(Icons.search, color: Colors.white),
                        hintText: "ค้นหา...",
                        hintStyle: new TextStyle(color: Colors.white)),
                    onChanged: searchOperation,
                  );
                  _handleSearchStart();
                } else {
                  _handleSearchEnd();
                }
              });
            },
          ),
        ]),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Flexible(
                  child: searchresult.length != 0 || _controller.text.isNotEmpty
                      ? new ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchresult.length,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = searchresult[index];
                            return new ListTile(
                              title: new Text(listData.toString()),
                            );
                          },
                        )
                      : new ListView.builder(
                          shrinkWrap: true,
                          itemCount: _list.length,
                          itemBuilder: (BuildContext context, int index) {
                            String listData = _list[index];
                            return new ListTile(
                              title: new Text(listData.toString()),
                            );
                          },
                        ))
            ],
          ),
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _controller,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "ค้นหา...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controller.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < _list.length; i++) {
        String data = _list[i];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(data);
        }
      }
    }
  }
}
