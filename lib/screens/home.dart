import 'package:champshop/screens/signin.dart';
import 'package:champshop/screens/signup.dart';
import 'package:champshop/screens/user/main_buyer.dart';
import 'package:champshop/utility/my_api.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';
import '../utility/normal_dialog.dart';
import 'main_shop.dart';
import 'main_user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? idLogin;
  String? chooseType;

  @override
  void initState() {
    super.initState();
    checkPreferance();
  }

  Future<void> checkPreferance() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      String? token = await firebaseMessaging.getToken();
      print('token ==>> $token');

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? chooseType = preferences.getString('ChooseType');
      String? idLogin = preferences.getString('id');
      print('idLogin = $idLogin');

      if (idLogin != null && idLogin.isNotEmpty) {
        String url =
            '${MyConstant().domain}/champshop/editTokenWhereId.php?isAdd=true&id=$idLogin&Token=$token';
        await Dio()
            .get(url)
            .then((value) => print('###### Update Token Success #####'));
      } else {
         routeToService(SignIn());
      }



      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'User') {
          routeToService(MainBuyer());
        } else if (chooseType == 'Shop') {
          routeToService(MainShop());
        } else if (chooseType == '5') {
          // routeToService(MainRider());
        } else {
          normalDialog(context, 'Error User Type');
        }
      }
    } catch (e) {
  
    }
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        // drawer: showDrawer(),
        body: MyStyle().showProgress()
        // MyStyle().showProgress(),
        );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('เข้าสู่ระบบ'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('สมัครสมาชิก'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      // decoration: MyStyle().myBoxDecoration('guest.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text('Guest'),
      accountEmail: Text('Please Login'),
    );
  }
}
