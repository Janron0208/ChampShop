import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/show_cart.dart';

class MyStyle {
  Color fontColor1 = Color.fromARGB(255, 78, 108, 6);
  Color fontColor2 = Color.fromARGB(255, 131, 172, 35);
  Color fontColor3 = Color.fromARGB(255, 159, 189, 87);
  Color fontColor4 = Color.fromARGB(255, 177, 201, 122);

  Color greenColor1 = Color.fromARGB(255, 108, 204, 38);
  Color greenColor2 = Color.fromARGB(255, 125, 193, 70);
  Color greenColor3 = Color.fromARGB(255, 148, 210, 97);
  Color greenColor4 = Color.fromARGB(255, 166, 220, 122);
  Color greenColor5 = Color.fromARGB(255, 187, 227, 153);
  Color greenColor6 = Color.fromARGB(255, 222, 255, 193);
  Color greenColor7 = Color.fromARGB(255, 231, 245, 219);
  Color greenColor8 = Color.fromARGB(255, 239, 245, 234);
  Color greenColor9 = Color.fromARGB(255, 224, 238, 171);

  SizedBox mySizebox() => SizedBox(
        width: 8.0,
        height: 16.0,
      );
  SizedBox mySizebox1() => SizedBox(
        width: 8.0,
        height: 12.0,
      );
  SizedBox mySizebox2() => SizedBox(
        width: 8.0,
        height: 20.0,
      );

      SizedBox mySizebox0() => SizedBox(
        width: 8.0,
        height: 4.0,
      );

  Widget iconShowCart(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add_shopping_cart),
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowCart(),
        );
        Navigator.push(context, route);
      },
    );
  }

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

   

  Text showTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 40.0,
            color: Color.fromARGB(255, 177, 201, 122),
            fontWeight: FontWeight.bold),
      );

  Text showSubTitle(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 18.0,
            color: Color.fromARGB(255, 177, 201, 122),
            fontWeight: FontWeight.bold),
      );

  Text showTitle1(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 24.0,
            color: Color.fromARGB(255, 177, 201, 122),
            fontWeight: FontWeight.bold),
      );

  Text showerror1(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 20.0,
            color: Color.fromARGB(255, 202, 79, 79),
            fontWeight: FontWeight.bold),
      );
  Text showHeadText1(String title) => Text(
        title,
        style: TextStyle(
            fontSize: 16.0,
            color: Color.fromARGB(255, 74, 138, 9),
            fontWeight: FontWeight.bold),
      );

  TextStyle headText16 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
  TextStyle headText18 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );
  TextStyle headText20 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
  );
  TextStyle headText25 = TextStyle(
    fontSize: 25.0,
    fontWeight: FontWeight.bold,
  );

  TextStyle Text16 = TextStyle(
    fontSize: 16.0,
  );
  TextStyle Text18 = TextStyle(
    fontSize: 18.0,
  );
  TextStyle Text20 = TextStyle(
    fontSize: 20.0,
  );
  TextStyle Text25 = TextStyle(
    fontSize: 25.0,
  );

  Container showLogo() {
    return Container(
      width: 120,
      child: Image.asset('images/logo.png'),
    );
  }

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/$namePic'),
        fit: BoxFit.cover,
      ),
    );
  }

  MyStyle();
}
