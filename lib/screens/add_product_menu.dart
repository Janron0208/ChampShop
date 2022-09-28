import 'dart:io';
import 'dart:math';

import 'package:champshop/utility/my_style.dart';
import 'package:champshop/utility/normal_dialog.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class AddProductMenu extends StatefulWidget {
  const AddProductMenu({Key? key}) : super(key: key);

  @override
  State<AddProductMenu> createState() => _AddProductMenuState();
}

class _AddProductMenuState extends State<AddProductMenu> {
  File? file;
  String? nameProduct, price, detail, type;

  final List<String> items = [
    'รถเข็น',
    'ทราย',
    'ค้อน',
    'ขวาน',
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
            showTitleProduct('รูปภาพสินค้า'),
            groupImage(),
            showTitleProduct('รายละเอียด'),
            nameForm(),
            MyStyle().mySizebox(),
            priceForm(),
            MyStyle().mySizebox(),
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
            MyStyle().mySizebox(),
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
          print('$nameProduct , $price , $detail , $type');
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

        String urlInsertData =
            '${MyConstant().domain}/champshop/addProduct.php?isAdd=true&idShop=$idShop&NameProduct=$nameProduct&PathImage=$urlPathImage&Price=$price&Detail=$detail&Type=$type';

        await Dio().get(urlInsertData).then((value) => Navigator.pop(context));
      });
    } catch (e) {}
  }

  Widget nameForm() => Container(
        width: 300,
        child: TextField(
          onChanged: (value) => nameProduct = value.trim(),
          decoration: InputDecoration(
            labelText: 'ชื่อสินค้า',
            border: OutlineInputBorder(),
          ),
        ),
      );

  Widget priceForm() => Container(
        width: 300,
        child: TextField(
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

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(Icons.add_a_photo),
        ),
        Container(
          width: 200.0,
          height: 200.0,
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
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: Icon(Icons.add_photo_alternate),
        ),
      ],
    );
  }

  Future<Null> checkType() async {
    if (selectedValue == 'รถเข็น') {
      type = 'A';
    } else if (selectedValue == 'ทราย') {
      type = 'B';
    } else if (selectedValue == 'ค้อน') {
      type = 'C';
    } else if (selectedValue == 'ขวาน') {
      type = 'D';
    } else if (selectedValue == 'อื่นๆ') {
      type = 'Z';
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
      margin: EdgeInsets.all(20),
      child: Row(
        children: [
          MyStyle().showTitle1(string),
        ],
      ),
    );
  }
}
