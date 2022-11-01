import 'dart:async';

import 'package:champshop/screens/user/main_buyer.dart';
import 'package:champshop/widget/steppayment/order_status.dart';
import 'package:flutter/material.dart';

class OrderSuccess extends StatefulWidget {
  const OrderSuccess({Key? key}) : super(key: key);

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {
 late Timer timer;
 String? imagesuccess;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => showImageSuccess());
  }

  Future<Null> showImageSuccess() async {

    imagesuccess = 'images/Success.gif';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 255, 223),
      body: Center(
        child: Container(
          child: Column(
           
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 250),
                child: Text(
                  'สั่งซื้อสินค้าสำเร็จ',
                  style: TextStyle(fontSize: 35, color: Colors.green),
                ),
              ),
              showImage(),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: showButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Image showImage() {
    return Image.asset(
              "images/Success.gif",
              height: 200.0,
              width: 200.0,
            );
  }

  Container showButton(BuildContext context) {
    return Container(
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      child: Text("กลับไปหน้าแรก",
                          style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainBuyer()),
                            (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 103, 187, 72),
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        child: Text("สถานะจัดส่ง",
                            style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const OrderStatus(),
                      ),
                    );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 72, 168, 187),
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
  }
}
