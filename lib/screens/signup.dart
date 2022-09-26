import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String chooseType = 'Buyer';
  String? name, user, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สมัครสมาชิก'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 40),
        children: <Widget>[
          // myLogo(),
          // showAppName(),
          // buildAvatar(),
          MyStyle().mySizebox1(),
          nameForm(),
          MyStyle().mySizebox1(),
          userForm(),
          MyStyle().mySizebox1(),
          passwordForm(),
          registerButton(),
        ],
      ),
    );
  }

  // Column buildAvatar() {
  //   return Column(
  //     children: [
  //       Container(
  //         margin: EdgeInsets.symmetric(vertical: 16),
  //         width: 250,
  //         child: file == null
  //             ? Container(
  //                 width: 200.0,
  //                 height: 200.0,
  //                 decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     image: DecorationImage(
  //                       fit: BoxFit.cover,
  //                       image: ExactAssetImage(MyConstant.avatar),
  //                     )))

  //             // ShowImage(path: MyConstant.avatar)
  //             : Container(
  //                 width: 200.0,
  //                 height: 200.0,
  //                 decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     image: DecorationImage(
  //                         fit: BoxFit.cover, image: FileImage(file!)))),
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           IconButton(
  //               onPressed: () => chooseImage(ImageSource.camera),
  //               icon: Icon(
  //                 Icons.add_a_photo,
  //                 size: 30,
  //                 color: MyStyle().greenColor3,
  //               )),
  //           IconButton(
  //               onPressed: () => chooseImage(ImageSource.gallery),
  //               icon: Icon(
  //                 Icons.add_photo_alternate,
  //                 size: 30,
  //                 color: MyStyle().greenColor3,
  //               )),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget registerButton() => Container(
        margin: EdgeInsets.only(bottom: 20, top: 50),
        width: 280,
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: MyStyle().greenColor9,
          onPressed: () {
            // print(
            //     '## name = $name, address = $address, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');
            if (name == null ||
                name!.isEmpty ||
                user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              print('Have Space');
              normalDialog(context, 'มีช่องว่าง คะ กรุณากรอกทุกช่อง คะ');
            } else if (chooseType == null) {
              normalDialog(context, 'โปรด เลือกชนิดของผู้สมัคร');
            } else {
              checkUser();
            }
          },
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  // Future<Null> uploadpictureThread() async {
  //   String apiSaveAvatar = '${MyConstant().domain}/champshop/saveAvatar.php';
  //   int i = Random().nextInt(100000);
  //   String nameAvatar = 'avatar$i.jpg';
  //   Map<String, dynamic> map = Map();
  //   map['file'] =
  //       await MultipartFile.fromFile(file!.path, filename: nameAvatar);
  //   FormData data = FormData.fromMap(map);
  //   await Dio().post(apiSaveAvatar, data: data).then((value) {
  //     avatar = '/champshop/avatar/$nameAvatar';
  //   });
  //   print(
  //       '## name = $name, address = $address, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');
  //   // print('### process Upload Avatar ==> $avatar');
  //   registerThread();
  // }

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/champshop/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        registerThread();
      } else {
        normalDialog(
            context, 'User นี่ $user มีคนอื่นใช้ไปแล้ว กรุณาเปลี่ยน User ใหม่');
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {
    String url =
        '${MyConstant().domain}/champshop/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=$chooseType';

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
            prefixIcon: Icon(
              Icons.person,
              color: MyStyle().greenColor5,
            ),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'ชื่อผู้ใช้',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );

  Widget userForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person_add_alt_1,
              color: MyStyle().greenColor5,
            ),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'บัญชีผู้ใช้',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: MyStyle().greenColor5,
            ),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'รหัสผ่าน',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyStyle().greenColor5),
              borderRadius: BorderRadius.circular(30),
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
}
