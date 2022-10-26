import 'dart:math';

class MyAPI {

double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double distance = 0;

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    distance = 12742 * asin(sqrt(a));

    return distance;
  }

  int calculateTransport(double distance) {
    int transport;
    if (distance < 1.0) {
      transport = 60;
      return transport;
    } else {
      transport = 60 + (distance - 1).round() * 10;
      return transport;
    }
  }

  List<String> createStringArray(String string) {
    String resultString = string.substring(1, string.length - 1);
    List<String> list = resultString.split(',');
    int index = 0;
    for (var item in list) {
      list[index] = item.trim();
      index++;
    }
    return list;
  }

  //  Future<String> checkTransport(String selectedValue) async {
  //   String transport;
  //   if (selectedValue == 'เขตพระนคร') {
  //     transport = '160';return transport;
  //   } else if (selectedValue == 'เขตดุสิต') {
  //     transport = '170';
  //   } else if (selectedValue == 'เขตหนองจอก') {
  //     transport = '300';
  //   } else if (selectedValue == 'เขตบางรัก') {
  //     transport = '160';
  //   } else if (selectedValue == 'เขตบางเขน') {
  //     transport = '220';
  //   } else if (selectedValue == 'เขตบางกะปิ') {
  //     transport = '220';
  //   } else if (selectedValue == 'เขตปทุมวัน') {
  //     transport = '170';
  //   } else if (selectedValue == 'เขตป้อมปราบศัตรูพ่าย') {
  //     transport = '160';
  //   } else if (selectedValue == 'เขตพระโขนง') {
  //     transport = '200';
  //   } else if (selectedValue == 'เขตมีนบุรี') {
  //     transport = '270';
  //   } else if (selectedValue == 'เขตลาดกระบัง') {
  //     transport = '270';
  //   } else if (selectedValue == 'เขตยานนาวา') {
  //     transport = '170';
  //   } else if (selectedValue == 'เขตสัมพันธวงศ์') {
  //     transport = '160';
  //   } else if (selectedValue == 'เขตพญาไท') {
  //     transport = '180';
  //   } else if (selectedValue == 'เขตธนบุรี') {
  //     transport = '150';
  //   } else if (selectedValue == 'เขตบางกอกใหญ่') {
  //     transport = '150';
  //   } else if (selectedValue == 'เขตห้วยขวาง') {
  //     transport = '190';
  //   } else if (selectedValue == 'เขตคลองสาน') {
  //     transport = '170';
  //   } else if (selectedValue == 'เขตตลิ่งชัน') {
  //     transport = '120';
  //   } else if (selectedValue == 'เขตบางกอกน้อย') {
  //     transport = '150';
  //   } else if (selectedValue == 'เขตบางขุนเทียน') {
  //     transport = '140';
  //   } else if (selectedValue == 'เขตภาษีเจริญ') {
  //     transport = '120';
  //   } else if (selectedValue == 'เขตหนองแขม') {
  //     transport = '120';
  //   } else if (selectedValue == 'เขตราษฎร์บูรณะ') {
  //     transport = '150';
  //   } else if (selectedValue == 'เขตบางพลัด') {
  //     transport = '160';
  //   } else if (selectedValue == 'เขตดินแดง') {
  //     transport = '180';
  //   } else if (selectedValue == 'เขตบึงกุ่ม') {
  //     transport = '220';
  //   } else if (selectedValue == 'เขตสาทร') {
  //     transport = '160';
  //   } else if (selectedValue == 'เขตบางซื่อ') {
  //     transport = '180';
  //   } else if (selectedValue == 'เขตจตุจักร') {
  //     transport = '200';
  //   } else if (selectedValue == 'เขตบางคอแหลม') {
  //     transport = '160';
  //   } else if (selectedValue == 'เขตประเวศ') {
  //     transport = '220';
  //   } else if (selectedValue == 'เขตคลองเตย') {
  //     transport = '180';
  //   } else if (selectedValue == 'เขตสวนหลวง') {
  //     transport = '200';
  //   } else if (selectedValue == 'เขตจอมทอง') {
  //     transport = '120';
  //   } else if (selectedValue == 'เขตดอนเมือง') {
  //     transport = '250';
  //   } else if (selectedValue == 'เขตราชเทวี') {
  //     transport = '180';
  //   } else if (selectedValue == 'เขตลาดพร้าว') {
  //     transport = '220';
  //   } else if (selectedValue == 'เขตวัฒนา') {
  //     transport = '180';
  //   } else if (selectedValue == 'เขตบางแค') {
  //     transport = '100';
  //   } else if (selectedValue == 'เขตหลักสี่') {
  //     transport = '220';
  //   } else if (selectedValue == 'เขตสายไหม') {
  //     transport = '250';
  //   } else if (selectedValue == 'เขตคันนายาว') {
  //     transport = '240';
  //   } else if (selectedValue == 'เขตสะพานสูง') {
  //     transport = '240';
  //   } else if (selectedValue == 'เขตวังทองหลาง') {
  //     transport = '200';
  //   } else if (selectedValue == 'เขตคลองสามวา') {
  //     transport = '270';
  //   } else if (selectedValue == 'เขตบางนา') {
  //     transport = '200';
  //   } else if (selectedValue == 'เขตทวีวัฒนา') {
  //     transport = '120';
  //   } else if (selectedValue == 'เขตทุ่งครุ') {
  //     transport = '140';
  //   } else if (selectedValue == 'เขตบางบอน') {
  //     transport = '120';
  //   } else {
  //     transport = '350';
  //   }
  // }

  int checkTransport(String selectedValue) {
    int transport;
    if (selectedValue == 'เขตพระนคร') {
      transport = 160; return transport;
    } else {
      transport = 60;
      return transport;
    }
  }


  
  MyAPI();
}