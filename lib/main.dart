import 'package:champshop/screens/home.dart';
import 'package:champshop/splashpage.dart';
import 'package:flutter/material.dart';



main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Prompt',
        scaffoldBackgroundColor: Color.fromARGB(255, 246, 241, 233),
      ),
      title: 'ChampShop ร้านจำหน่ายอุปกรณ์ก่อสร้าง',
      home: SplashPage(),
    );
  }
}


 
