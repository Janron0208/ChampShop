import 'dart:io';
import 'dart:math';

import 'package:champshop/utility/my_style.dart';
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
  String? showtype;
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
    print('$type , $pathImage');
    checktypeshow();
  }

   Future<Null> checktypeshow() async {
    if (productModel!.type == 'A') {
      showtype = 'โครง,ล้อ';
    } else if (productModel!.type == 'B') {
      showtype = 'งานประปา';
    } else if (productModel!.type == 'C') {
      showtype = 'งานสวน';
    } else if (productModel!.type == 'D') {
      showtype = 'รถเข็น';
    } else if (productModel!.type == 'E') {
      showtype = 'โครงรถเข็นปูน';
    } else if (productModel!.type == 'F') {
      showtype = 'เปล';
    } else if (productModel!.type == 'G') {
      showtype = 'กระเบื้องยาง';
    } else if (productModel!.type == 'H') {
      showtype = 'ถังปูน';
    } else if (productModel!.type == 'I') {
      showtype = 'ปูน';
    } else if (productModel!.type == 'J') {
      showtype = 'เครื่องมือ';
    } else if (productModel!.type == 'K') {
      showtype = 'สีทาภายในภายนอก';
    } else if (productModel!.type == 'L') {
      showtype = 'งานสีอื่นๆ';
    } else if (productModel!.type == 'M') {
      showtype = 'สเปรย์';
    } else if (productModel!.type == 'Z') {
      showtype = 'อื่นๆ';
    } else {
      showtype = productModel!.type;
    }

    print(showtype);
    
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
            groupImage(),
            nameProduct(),
            brandProduct(),
            modelProduct(),
            sizeProduct(),
            colorProduct(),
            priceProduct(),
            typeProduct(),
            detailProduct(),
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
          print('$name , $price , $detail , $type , $sale, $pathImage , $file');

          if (name!.isEmpty || price!.isEmpty || detail!.isEmpty) {
            normalDialog(context, 'กรุณากรอกให้ครบ');
          } else {
            checkType();
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
    if (file == null) {
      print('ไม่ได้เลือกรูปใหม่');
      String? id = productModel!.id;
      print('$id');
      // print('$pathImage');
      print(
          '$name ,$brand ,$model, $size, $color, $price, $type ,detal ,$pathImage ');

      // Random random = Random();
      // int i = random.nextInt(100000);
      // String nameFile = 'editProduct$i.jpg';

      // // Map<String, dynamic> map = Map();
      // // map['file'] =
      //     await MultipartFile.fromFile(file!.path, filename: nameFile);
      // // FormData formData = FormData.fromMap(map);

      // String urlUpload = '${MyConstant().domain}/champshop/saveProduct.php';

      // await Dio().post(urlUpload).then((value) async {
      //  pathImage = '$pathImage';
      //  print('$pathImage');
      // String? id = productModel!.id;
      String url =
          '${MyConstant().domain}/champshop/editProductWhereId.php?isAdd=true&id=$id&NameProduct=$name&Brand=$brand&Model=$model&PathImage=$pathImage&Price=$price&Detail=$detail&Type=$type&Sale=$price&Size=$size&Color=$color';
      await Dio().get(url).then((value) {
        if (value.toString() == 'true') {
          Navigator.pop(context);
        } else {
          normalDialog(context, 'ผิดพลาด! กรุณาลองใหม่');
        }
      });
      // });
    } else {
      Random random = Random();
      int i = random.nextInt(100000);
      String nameFile = 'editProduct$i.jpg';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
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
    } else if (selectedValue == 'อื่นๆ') {
      type = 'Z';
    } else {
      type = productModel!.type;
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

  Column groupImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(top: 16),
          width: 150.0,
          height: 150.0,
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
        MyStyle().mySizebox1(),
        ElevatedButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          child: Text('เลือกรูปภาพ'),
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
        dropdownHeight: 500,
        dropdownWidth: 200,
       
        hint: '$showtype',
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
            width: 300,
            height: 50,
            child: TextFormField(
              maxLines: 1,
              onChanged: (value) => color = value.trim(),
              initialValue: productModel!.color,
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
            width: 300,
            height: 50,
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
              maxLines: 5,
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
