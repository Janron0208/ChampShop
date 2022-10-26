// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:champshop/screens/signup.dart';
import 'package:champshop/screens/user/main_buyer.dart';
import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';
import 'main_shop.dart';
import 'main_user.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
 
  String? user, password;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 246, 143, 88),
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 246, 143, 88),
                    Color.fromARGB(255, 201, 241, 255),
                  ],
                ),
              ),
              child: Align(
                alignment: AlignmentDirectional(0, 1),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(1),
                      child: Container(
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyStyle().showLogo(),
                            
                            Column(
                              children: [
                                Text(
                                  'ChampShop',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text('ร้านจำหน่ายอุปกรณ์ก่อสร้าง',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 36, 0, 0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 3, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 16, 20, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'ยินดีต้อนรับ',
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 140, 140, 140)),
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                              newUserForm(),
                              newPasswordForm(),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 12, 30, 16),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                   
                                    newLoginBtn(context),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 2,
                                thickness: 2,
                                indent: 20,
                                endIndent: 20,
                                color: Color(0xFFDBE2E7),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0, 20, 0, 20),
                                child: Container(
                                  width: 170,
                                  height: 40,
                                  child: FlatButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SignUp(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'สมัครสมาชิก',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 255, 138, 92),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

//ใหม่
    );
  }

  Container newLoginBtn(BuildContext context) {
    return Container(
      width: 280,
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            if (user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'เข้าสู่ระบบ',
            style: MyStyle().headText18,
          ),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 255, 138, 92),
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          )),
    );
  }

  Container newChangePass() {
    return Container(
      width: 140,
      height: 40,
      child: FlatButton(
        onPressed: () async {},
        child: Text(
          'เปลี่ยนรหัสผ่าน ?',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Padding newPasswordForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (value) => password = value.trim(),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'รหัสผ่าน',
                hintText: 'กรอกรหัสผ่าน...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFDBE2E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFDBE2E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
                // suffix: InkWell(
                //   onTap: () {},
                //   focusNode: FocusNode(skipTraversal: true),
                //   child: Icon(Icons.visibility_outlined, size: 22),
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding newUserForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              onChanged: (value) => user = value.trim(),
              //  controller: emailAddressController,
              obscureText: false,
              decoration: InputDecoration(
                labelText: 'บัญชีผู้ใช้',
                hintText: 'กรอกบัญชีผู้ใช้ของคุณ...',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFDBE2E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFDBE2E7),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0x00000000),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsetsDirectional.fromSTEB(16, 24, 0, 24),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loginButton() => Container(
        width: 280,
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: MyStyle().greenColor9,
          onPressed: () {
            if (user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty) {
              normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'เข้าสู่ระบบ',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    String url =
        '${MyConstant().domain}/champshop/getUserWhereUser.php?isAdd=true&User=$user';
    // print('url ===>> $url');
    try {
      Response response = await Dio().get(url);
      // print('res = $response');

      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        UserModel userModel = UserModel.fromJson(map);
        if (password == userModel.password) {
          String? chooseType = userModel.chooseType;
          if (chooseType == 'User') {
            routeTuService(MainBuyer(), userModel);
          } else if (chooseType == 'Shop') {
            routeTuService(MainShop(), userModel);
          } else if (chooseType == 'Rider') {
            // routeTuService(MainRider(), userModel);
          } else {
            normalDialog(context, 'Error');
          }
        } else {
          normalDialog(context, 'Password ผิดกรุณาลองใหม่ ');
        }
      }
    } catch (e) {
      print('Have e Error ===>> ${e.toString()}');
    }
  }

  Future<Null> routeTuService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(MyConstant().keyId, userModel.id!);
    preferences.setString(MyConstant().keyType, userModel.chooseType!);
    preferences.setString(MyConstant().keyName, userModel.name!);
    preferences.setString(MyConstant().keyPhone, userModel.phone!);
    preferences.setString(MyConstant().keyAddress, userModel.address!);

    preferences.setString(MyConstant().keyLat, userModel.lat!);
    preferences.setString(MyConstant().keyLng, userModel.lng!);
    // preferences.setString(MyConstant().keySlip, userModel.slip!);
    preferences.setString(MyConstant().keyUrlPicture, userModel.urlPicture!);

    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  Widget userForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person_outline,
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
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
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
}
