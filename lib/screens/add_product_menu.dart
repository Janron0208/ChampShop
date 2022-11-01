import 'dart:io';
import 'dart:math';

import 'package:champshop/utility/my_style.dart';
import 'package:champshop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class AddProductMenu extends StatefulWidget {
  const AddProductMenu({Key? key}) : super(key: key);

  @override
  State<AddProductMenu> createState() => _AddProductMenuState();
}

class _AddProductMenuState extends State<AddProductMenu> {
  File? file;
  String? nameProduct,
      price,
      detail,
      type,
      advice,
      guild,
      size,
      color,
      stock,
      brand,
      model;
  String? sale;

  final List<String> items = [
    'โครง,ล้อ',
    'งานประปา',
    'งานสวน',
    'รถเข็น',
    'โครงรถเข็นปูน',
    'เปล',
    'กระเบื้องยาง',
    'ถังปูน',
    'ปูน',
    'เครื่องมือ',
    'สีทาภายในภายนอก',
    'งานสีอื่นๆ',
    'สเปรย์',
    'อื่นๆ',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มสินค้า'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'รูปภาพสินค้า',
              style: TextStyle(fontSize: 20),
            ),
            groupImage(),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: showTitleProduct('รายละเอียด'),
            ),
            nameForm(),
            MyStyle().mySizebox1(),
            brandForm(),
            MyStyle().mySizebox1(),
            modelForm(),
            MyStyle().mySizebox1(),
            sizeForm(),
            MyStyle().mySizebox1(),
            colorForm(),
            MyStyle().mySizebox1(),
            priceForm(),
            MyStyle().mySizebox1(),
            Container(
              width: 300,
              height: 60,
              child: CustomDropdownButton2(
                hint: 'เลือกหมวดหมู่สินค้า',
                dropdownItems: items,
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
            ),
            MyStyle().mySizebox1(),
            detailForm(),
            MyStyle().mySizebox2(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 60, top: 20),
      width: 300,
      height: 50,
      child: RaisedButton.icon(
        onPressed: () {
          checkType();
          // print('$nameProduct , $price , $detail , $type');
          if (file == null) {
            normalDialog(context, 'กรุณาเลือกรูปภาพสินค้า');
          } else if (nameProduct == null ||
              nameProduct!.isEmpty ||
              price == null ||
              price!.isEmpty ||
              detail == null ||
              detail!.isEmpty) {
            normalDialog(context, 'กรุณากรอกรายละเอียดให้ครบ');
          } else {
            uploadProductAndInsertData();
          }
        },
        icon: Icon(Icons.save),
        label: Text('เพิ่มรายการ'),
      ),
    );
  }

  Future<Null> uploadProductAndInsertData() async {
    
    String urlUpload = '${MyConstant().domain}/champshop/saveProduct.php';
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'product$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) async {
        String urlPathImage = '/champshop/Product/$nameFile';
        print('urlPathImage = ${MyConstant().domain}$urlPathImage');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        String? idShop = preferences.getString('id');

        // String? sale = '0';
        String? advice = '';
        String? guild = '';
        String? stock = '';

        // print('$price');

        // print(formatAmount());

        String urlInsertData =
            '${MyConstant().domain}/champshop/addProduct.php?isAdd=true&idShop=$idShop&NameProduct=$nameProduct&Brand=$brand&Model=$model&Size=$size&Color=$color&Stock=$stock&PathImage=$urlPathImage&Price=$price&Detail=$detail&Type=$type&Sale=$price&Advice=$advice&Guild=$guild';

        await Dio().get(urlInsertData).then((value) => Navigator.pop(context));
      });
    } catch (e) {}
  }

  Widget brandForm() => Container(
        width: 300,
        height: 50,
        child: TextField(
          onChanged: (value) => brand = value.trim(),
          decoration: InputDecoration(
            labelText: 'ยี่ห้อ',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget modelForm() => Container(
        width: 300,
        height: 50,
        child: TextField(
          onChanged: (value) => model = value.trim(),
          decoration: InputDecoration(
            labelText: 'รุ่นสินค้า',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget nameForm() => Container(
        width: 300,
        child: TextField(
          maxLines: 2,
          onChanged: (value) => nameProduct = value.trim(),
          decoration: InputDecoration(
            labelText: 'ชื่อสินค้า',
            border: OutlineInputBorder(),
          ),
        ),
      );
  Widget sizeForm() => Container(
        width: 300,
        height: 50,
        child: TextField(
          onChanged: (value) => size = value.trim(),
          decoration: InputDecoration(
            labelText: 'ขนาด/ปริมาณ',
            border: OutlineInputBorder(),
          ),
        ),
      );
  Widget colorForm() => Container(
        width: 300,
        height: 50,
        child: TextField(
          onChanged: (value) => color = value.trim(),
          decoration: InputDecoration(
            labelText: 'สี',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceForm() => Container(
        width: 300,
        height: 50,
        child: TextField(
          // inputFormatters: [],
          keyboardType: TextInputType.number,
          onChanged: (value) => price = value.trim(),
          decoration: InputDecoration(
            labelText: 'ราคาสินค้า',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget detailForm() => Container(
        width: 300,
        child: TextField(
          onChanged: (value) => detail = value.trim(),
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'รายละเอียดของสินค้า',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Column groupImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 150.0,
          height: 150.0,
          child: file == null
              ? Image.asset(
                  'images/product.png',
                )
              : Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover, image: FileImage(file!)))),
        ),
        ElevatedButton(
            onPressed: () => chooseImage(ImageSource.gallery),
            child: Text('เลือกรูปภาพ'))
      ],
    );
  }

  Future<Null> checkType() async {
    if (selectedValue == 'โครง,ล้อ') {
      type = 'A';
    } else if (selectedValue == 'งานประปา') {
      type = 'B';
    } else if (selectedValue == 'งานสวน') {
      type = 'C';
    } else if (selectedValue == 'รถเข็น') {
      type = 'D';
    } else if (selectedValue == 'โครงรถเข็นปูน') {
      type = 'E';
    } else if (selectedValue == 'เปล') {
      type = 'F';
    } else if (selectedValue == 'กระเบื้องยาง') {
      type = 'G';
    } else if (selectedValue == 'ถังปูน') {
      type = 'H';
    } else if (selectedValue == 'ปูน') {
      type = 'I';
    } else if (selectedValue == 'เครื่องมือ') {
      type = 'J';
    } else if (selectedValue == 'สีทาภายในภายนอก') {
      type = 'K';
    } else if (selectedValue == 'งานสีอื่นๆ') {
      type = 'L';
    } else if (selectedValue == 'สเปรย์') {
      type = 'M';
    } else {
      type = 'Z';
    }
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(
        source: source,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Widget showTitleProduct(String string) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Row(
        children: [
          MyStyle().showTitle1(string),
        ],
      ),
    );
  }
}
