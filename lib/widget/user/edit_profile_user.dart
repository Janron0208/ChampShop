import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';
import '../../utility/normal_dialog.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({Key? key}) : super(key: key);

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  UserModel? userModel;
  String? nameUser, address, phone, urlPicture;
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentInfo();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUSer = preferences.getString('id');
    print('idUser ==>> $idUSer');

    String url =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$idUSer';

    Response response = await Dio().get(url);
    // print('response ==>> $response');

    var result = json.decode(response.data);
    // print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameUser = userModel?.name;
        address = userModel?.address;
        phone = userModel?.phone;
        urlPicture = userModel?.urlPicture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'แก้ไขข้อมูลลูกค้า',
            style:
                TextStyle(color: Color.fromARGB(255, 61, 61, 61), fontSize: 20),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 61, 61, 61)),
        ),
        body: userModel == null
            ? MyStyle().showProgress()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    showImage(),
                    nameForm(),
                    phoneForm(),
                    addressForm(),
                    saveBtn(),
                  ],
                ),
              ));
  }

  Padding saveBtn() {
    return Padding(
                    padding: const EdgeInsets.only(top: 120),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                        child: Text(
                          'บันทึกข้อมูล',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 20),
                        ),
                        onPressed: () {
                          editThread();
                          
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 1,
                          primary: Color.fromARGB(255, 255, 152, 118),
                        ),
                      ),
                    ),
                  );
  }

  Padding showImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Container(
            width: 120.0,
            height: 120.0,
            child: file == null
                ? Image.network('${MyConstant().domain}$urlPicture',
                    fit: BoxFit.cover)
                : Image.file(
                    file!,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              child: Text(
                'เปลี่ยนรูปภาพ',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 122, 45), fontSize: 12),
              ),
              onPressed: () => chooseImage(ImageSource.gallery),
              style: ElevatedButton.styleFrom(
                elevation: 1,
                primary: Color.fromARGB(255, 239, 239, 239),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding nameForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 16),
      child: TextFormField(
        onChanged: (value) => nameUser = value,
        initialValue: nameUser,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อผู้ใช้',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Padding phoneForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        onChanged: (value) => phone = value,
        initialValue: phone,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'เบอร์โทรศัพท์',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Padding addressForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        maxLines: 4,
        onChanged: (value) => address = value,
        initialValue: address,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ที่อยู่',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker()
          .getImage(source: source, maxWidth: 800.0, maxHeight: 800.0);

      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

 Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ต้องการบันทึกหรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  editThread();
                  Navigator.pop(context);
                },
                child: Text('ยืนยัน'),
              ),
              MyStyle().mySizebox(),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          )
        ],
      ),
    );
  }

Future<Null> editThread() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'editAvatar$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/champshop/saveUser.php';
    print('### $nameFile');

    await Dio().post(urlUpload, data: formData).then((value) async {
      urlPicture = '/champshop/Avatar/$nameFile';

      String? id = userModel!.id!;

      // print('&id=$id&Name=$nameUser&Address=$address&Phone=$phone&UrlPicture=$urlPicture');

      String url =
          '${MyConstant().domain}/champshop/editBuyerWhereId.php?isAdd=true&id=$id&Name=$nameUser&Address=$address&Phone=$phone&UrlPicture=$urlPicture';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ยังอัพเดทไม่ได้ กรุณาลองใหม่');
      }
    });
  }


}
