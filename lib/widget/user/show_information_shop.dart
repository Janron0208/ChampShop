import 'dart:convert';

import 'package:champshop/widget/about_shop.dart';
import 'package:champshop/widget/user/show_owner_shop.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/signout_process.dart';
import 'edit_profile_user.dart';
import 'order_history_shop.dart';

class ShowInfarmationShop extends StatefulWidget {
  const ShowInfarmationShop({Key? key}) : super(key: key);

  @override
  State<ShowInfarmationShop> createState() => _ShowInfarmationShopState();
}

class _ShowInfarmationShopState extends State<ShowInfarmationShop> {
  UserModel? userModel;
  String? nameUser;
  String? phoneUser;
  String? addressUser;
  String? lat;
  String? lng;
  String? urlPicture;
  String? address, phone;
  List<UserModel> userModels = [];
  @override
  void initState() {
    super.initState();
    checkPreferance();
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
  Future<void> checkPreferance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
      phoneUser = preferences.getString('Phone');
      addressUser = preferences.getString('Address');
      lat = preferences.getString('Lat');
      lng = preferences.getString('Lng');
      // slip = preferences.getString('Slip');
      urlPicture = preferences.getString('UrlPicture');
      print('$nameUser $phoneUser $addressUser $lat $lng $urlPicture');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        title: Text('ข้อมูลร้านค้า',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 34, 34, 34))),
        actions: [],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          showCol1(),
          showText1(),
          showEditProfile(),
          showEditProfile1(),
          Spacer(),
        
        ],
      ),
    );
  }

  Padding showEditProfile() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowOwnerShop(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x3416202A),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  color: Color.fromARGB(255, 106, 106, 106),
                  size: 24,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Text(
                    'รายละเอียดร้านค้า',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 122, 122, 122)),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.9, 0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(255, 106, 106, 106),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding showEditProfile1() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AboutShop(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x3416202A),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.paypal,
                  color: Color.fromARGB(255, 106, 106, 106),
                  size: 24,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Text(
                    'การชำระเงิน',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 122, 122, 122)),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.9, 0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(255, 106, 106, 106),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding showText1() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 16, 0, 0),
      child: Row(
        children: [
          Text('เมนู',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 122, 122, 122))),
        ],
      ),
    );
  }

  Padding showEditProfile2() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderHistoryShop(),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Color(0x3416202A),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.av_timer,
                  color: Color.fromARGB(255, 106, 106, 106),
                  size: 24,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Text(
                    'ประวัติการสั่งซื้อ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 122, 122, 122)),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(0.9, 0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(255, 106, 106, 106),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding showCol1() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: Color.fromARGB(255, 247, 183, 80),
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
  padding: EdgeInsetsDirectional.fromSTEB(2, 2, 2, 2),
  child: Image.asset(
    'images/logo.png',
    width: 80,
    height: 80,
    fit: BoxFit.cover,
  ),
),
                
                
                
           
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ChampShop',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Text('เบอร์ติดต่อร้าน 097-xxx-xxxx',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 122, 122, 122))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
