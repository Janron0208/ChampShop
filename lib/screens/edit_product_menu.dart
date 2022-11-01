import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/product_model.dart';
import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';

class EditProductMenu extends StatefulWidget {
  final ProductModel productModel;
  const EditProductMenu({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<EditProductMenu> createState() => _EditProductMenuState();
}

class _EditProductMenuState extends State<EditProductMenu> {
  ProductModel? productModel;
  File? file;
  String? name,
      price,
      detail,
      pathImage,
      type,
      sale,
      size,
      color,
      stock,
      brand,
      model;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    productModel = widget.productModel;
    name = productModel!.nameProduct;

    brand = productModel!.brand;
    model = productModel!.model;

    price = productModel!.price;
    detail = productModel!.detail;
    pathImage = productModel!.pathImage;
    type = productModel!.type;
    sale = productModel!.sale;
    size = productModel!.size;
    color = productModel!.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขสินค้า ${productModel!.nameProduct}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            nameProduct(),
            brandProduct(),
            modelProduct(),
            sizeProduct(),
            colorProduct(),
            priceProduct(),
            typeProduct(),
            detailProduct(),
            groupImage(),
            uploadButton(),
          ],
        ),
      ),
    );
  }

  Widget uploadButton() {
    return Container(
      margin: EdgeInsets.only(bottom: 60, top: 20),
      width: 300,
      height: 50,
      child: RaisedButton.icon(
        onPressed: () {
          checkType();
          print('$name , $price , $detail , $type , $sale');
          if (name!.isEmpty || price!.isEmpty || detail!.isEmpty) {
            normalDialog(context, 'กรุณากรอกให้ครบ');
          } else {
            confirmEdit();
          }
        },
        icon: Icon(Icons.save),
        label: Text('บันทึก'),
      ),
    );
  }

  Future<Null> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการจะบันทึกหรือไม่ ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  editValueOnMySQL();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('ยืนยัน'),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ยกเลิก'),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editValueOnMySQL() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'editProduct$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/champshop/saveProduct.php';
    print('### $nameFile');

    await Dio().post(urlUpload, data: formData).then((value) async {
      pathImage = '/champshop/Product/$nameFile';

      String? id = productModel!.id;
      String url =
          '${MyConstant().domain}/champshop/editProductWhereId.php?isAdd=true&id=$id&NameProduct=$name&Brand=$brand&Model=$model&PathImage=$pathImage&Price=$price&Detail=$detail&Type=$type&Sale=$price&Size=$size&Color=$color';
      await Dio().get(url).then((value) {
        if (value.toString() == 'true') {
          Navigator.pop(context);
        } else {
          normalDialog(context, 'ผิดพลาด! กรุณาลองใหม่');
        }
      });
    });
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

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: Icon(Icons.add_a_photo),
        ),
        Container(
          padding: EdgeInsets.only(top: 16),
          width: 200.0,
          height: 200.0,
          child: file == null
              ? Image.network(
                  '${MyConstant().domain}${productModel!.pathImage}',
                  fit: BoxFit.cover,
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

  Container typeProduct() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: 300,
      height: 60,
      child: CustomDropdownButton2(
        hint: 'เลือกหมวดหมู่สินค้า',
        dropdownItems: items,
        value: selectedValue,
        // initialValue: productModel!.type,

        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
      ),
    );
  }

  Widget nameProduct() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 300,
            child: TextFormField(
              maxLines: 2,
              onChanged: (value) => name = value.trim(),
              initialValue: productModel!.nameProduct,
              decoration: InputDecoration(
                labelText: 'ชื่อสินค้า',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );


 Widget brandProduct() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 300,
            height: 50,
            child: TextFormField(
              maxLines: 1,
              onChanged: (value) => brand = value.trim(),
              initialValue: productModel!.brand,
              decoration: InputDecoration(
                labelText: 'ยี่ห้อ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

       Widget modelProduct() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 300,
            height: 50,
            child: TextFormField(
              maxLines: 1,
              onChanged: (value) => model = value.trim(),
              initialValue: productModel!.model,
              decoration: InputDecoration(
                labelText: 'รุ่น/รหัสสินค้า',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
  Widget sizeProduct() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 300,
            height: 50,
            child: TextFormField(
              maxLines: 1,
              onChanged: (value) => size = value.trim(),
              initialValue: productModel!.size,
              decoration: InputDecoration(
                labelText: 'ขนาด/ปริมาณ',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget colorProduct() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 300,height: 50,
            child: TextFormField(
              maxLines: 1,
              onChanged: (value) => color = value.trim(),
              initialValue: productModel!.size,
              decoration: InputDecoration(
                labelText: 'สี',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
  Widget priceProduct() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 300,height: 50,
            child: TextFormField(
              onChanged: (value) => price = value.trim(),
              keyboardType: TextInputType.number,
              initialValue: productModel!.price,
              decoration: InputDecoration(
                labelText: 'ราคาสินค้า',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget detailProduct() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 300,
            child: TextFormField(
              onChanged: (value) => detail = value.trim(),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              initialValue: productModel!.detail,
              decoration: InputDecoration(
                labelText: 'รายละเอียด',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
