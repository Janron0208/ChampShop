import 'package:champshop/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
        seconds: 3,
        navigateAfterSeconds: Home(),
        title: Text(
          'ร้านจำหน่ายอุปกรณ์ก่อสร้าง',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,color: Color.fromARGB(255, 255, 255, 255)),
        ),
        image: Image.asset('images/logo.png'),
        backgroundColor: Color.fromARGB(255, 255, 228, 207),
        styleTextUnderTheLoader: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        photoSize: 100.0,
        loaderColor: Color.fromARGB(255, 255, 255, 255));
  }
}