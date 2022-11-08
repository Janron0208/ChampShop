import 'package:champshop/screens/admin/order_list_shop_await.dart';
import 'package:champshop/screens/admin/order_list_shop_delivery.dart';
import 'package:champshop/screens/admin/order_list_shop_success.dart';
import 'package:flutter/material.dart';

class StepOrder extends StatefulWidget {
  const StepOrder({Key? key}) : super(key: key);

  @override
  State<StepOrder> createState() => _StepOrderState();
}

class _StepOrderState extends State<StepOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 255, 224, 203),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 350,
              height: 150,
              child: ElevatedButton.icon(
                onPressed: () {Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OrderListShopAwait(),
                    ),
                  );
                },
                icon: Icon(Icons.priority_high,size: 35),
                label: Text(
                  ' รอยืนยัน',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 249, 81, 81),
                ),
              ),
            ),
            Container(
              width: 350,
              height: 150,
              child: ElevatedButton.icon(
                onPressed: () {Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OrderListShopDelivery(),
                    ),
                  );
                },
                icon: Icon(Icons.motorcycle,size: 35),
                label: Text(
                  ' กำลังจัดส่ง',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 249, 179, 81),
                ),
              ),
            ),
            Container(
              width: 350,
              height: 150,
              child: ElevatedButton.icon(
                onPressed: () {Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const OrderListShopSuccess(),
                    ),
                  );
                },
                icon: Icon(Icons.verified,size: 35),
                label: Text(
                  ' ส่งสำเร็จแล้ว',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 81, 176, 249),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
