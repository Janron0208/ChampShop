import 'package:champshop/screens/home.dart';
import 'package:champshop/screens/signin.dart';
import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Prompt',
        scaffoldBackgroundColor: Color.fromARGB(255, 246, 241, 233),
      ),
      title: 'ChampShop ร้านจำหน่ายอุปกรณ์ก่อสร้าง',
      home: Home(),
    );
  }
}


 
