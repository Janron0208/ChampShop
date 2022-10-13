import 'dart:io';
import 'dart:math';

import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String chooseType = 'User';
  String? name, user, password, address, phone, urlpicture;
  String avatar = '';
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 213, 201),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    
                    buildAvatar(),
                    Divider(),
                    MyStyle().mySizebox1(),
                    nameForm(),
                    MyStyle().mySizebox1(),
                    phoneForm(),
                    MyStyle().mySizebox1(),
                    addressForm(),
                    MyStyle().mySizebox1(),
                    userForm(),
                    MyStyle().mySizebox1(),
                    passwordForm(),
                    registerButton(),
                     MyStyle().mySizebox1(),
                  ],
                ),
              ),
            ],
          ),
        ),

        //เก่า
        // padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
        // children: <Widget>[
        //   buildAvatar(),
        // MyStyle().mySizebox1(),
        // nameForm(),
        // MyStyle().mySizebox1(),
        // phoneForm(),
        // MyStyle().mySizebox1(),
        // addressForm(),
        // MyStyle().mySizebox1(),
        // userForm(),
        // MyStyle().mySizebox1(),
        // passwordForm(),
        //   registerButton(),
        // ],
      ),
    );
  }

  Row buildAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20,bottom: 20),
          width: 100,
          child: file == null
              ? Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: ExactAssetImage(MyConstant.avatar),
                      )))

              // ShowImage(path: MyConstant.avatar)
              : Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: FileImage(file!)))),
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => chooseImage(ImageSource.camera),
                    child: Text('กล้องถ่ายรูป'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 255, 114, 104),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => chooseImage(ImageSource.gallery),
                    child: Text('อัลบัมภาพ'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 255, 114, 104),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     IconButton(
        //         onPressed: () => chooseImage(ImageSource.camera),
        //         icon: Icon(
        //           Icons.add_a_photo,
        //           size: 30,
        //           color: MyStyle().greenColor3,
        //         )),
        //     IconButton(
        //         onPressed: () => chooseImage(ImageSource.gallery),
        //         icon: Icon(
        //           Icons.add_photo_alternate,
        //           size: 30,
        //           color: MyStyle().greenColor3,
        //         )),
        //   ],
        // ),
      ],
    );
  }

  Widget registerButton() => Container(
        margin: EdgeInsets.only(bottom: 20, top: 50),
        width: 280,
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromARGB(255, 255, 155, 135),
          onPressed: () {
            // print(
            //     '## name = $name, address = $address, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');
            if (name == null ||
                name!.isEmpty ||
                user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty ||
                address == null ||
                address!.isEmpty ||
                phone == null ||
                phone!.isEmpty) {
              print('Have Space');
              normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
            } else {
              if (chooseType == null) {
                normalDialog(context, 'โปรด เลือกชนิดของผู้สมัคร');
              } else {
                // uploadpictureThread();
                checkUser();
              }
            }
          },
          child: Text(
            'สมัครสมาชิก',
            style: TextStyle(fontSize: 20,color: Colors.white, fontWeight: FontWeight.bold)
          ),
        ),
      );

  Future<Null> uploadpictureThread() async {
    String apiSaveAvatar = '${MyConstant().domain}/champshop/saveAvatar.php';
    int i = Random().nextInt(100000);
    String nameAvatar = 'avatar$i.jpg';
    Map<String, dynamic> map = Map();
    map['file'] =
        await MultipartFile.fromFile(file!.path, filename: nameAvatar);
    FormData data = FormData.fromMap(map);
    await Dio().post(apiSaveAvatar, data: data).then((value) {
      avatar = '/champshop/Avatar/$nameAvatar';
    });
    print(
        '## name = $name, address = $address, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');
    // print('### process Upload Avatar ==> $avatar');
    registerThread();
  }

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/champshop/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        uploadpictureThread();
        // registerThread();
      } else {
        normalDialog(
            context, 'User นี่ $user มีคนอื่นใช้ไปแล้ว กรุณาเปลี่ยน User ใหม่');
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        '${MyConstant().domain}/champshop/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=$chooseType&Address=$address&Phone=$phone&UrlPicture=$avatar';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถ สมัครได้ กรุณาลองใหม่ คะ');
      }
    } catch (e) {}
  }

  Widget nameForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.person, color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'ชื่อผู้ใช้',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget addressForm() => Container(
        width: 300.0,
        child: TextField(
          maxLines: 3,
          onChanged: (value) => address = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_city,
                color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'ที่อยู่ปัจจุบัน',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget phoneForm() => Container(
        width: 300.0,
        child: TextField(
          keyboardType: TextInputType.phone,
          onChanged: (value) => phone = value.trim(),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.phone, color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'เบอร์โทรศัพท์',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget userForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_add_alt_1,
                color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'บัญชีผู้ใช้',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.lock, color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'รหัสผ่าน',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyStyle().showTitle1('ChampShop'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }
}
