import 'package:champshop/model/user_model.dart';
import 'package:champshop/utility/my_api.dart';
import 'package:champshop/utility/my_style.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

class AboutShop extends StatefulWidget {
  AboutShop({Key? key}) : super(key: key);

  @override
  State<AboutShop> createState() => _AboutShopState();
}

class _AboutShopState extends State<AboutShop> {
  UserModel? userModel;
  double? lat1, lng1, lat2, lng2, distance;
  String? distanceString;
  int? transport;
  late CameraPosition position;

  @override
  void initState() {
    super.initState();
    findLat1Lng1();
  }

  Future<Null> findLat1Lng1() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat1 = locationData!.latitude!;
      lng1 = locationData.longitude!;
      lat2 = double.parse(userModel!.lat!);
      lng2 = double.parse(userModel!.lng!);
      print('lat1 = $lng1, lng1 = $lng1, lat2 = $lng2, lng2 = $lng2');

      distance = MyAPI().calculateDistance(lat1!, lng1!, lat2!, lng2!);

      var myFormat = NumberFormat('#0.0#', 'en_US');
      distanceString = myFormat.format(distance);

      transport = MyAPI().calculateTransport(distance!);

      print('distance = $distance');
      print('transport = $transport');
    });
  }

  Future<LocationData?> findLocationData() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      icon: Icon(Icons.arrow_back_ios_new)),
                ),
                Text('การชำระเงิน', style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
                height: 50,
                width: 300,
                child: Image.network(
                    'https://www.designil.com/wp-content/uploads/2022/02/prompt-pay-logo.jpg')),
          ),
          Container(
              width: 300,
              height: 300,
              child: Image.network(
                  'https://www.investopedia.com/thmb/KfGSwVyV8mOdTHFxL1T0aS3xpE8=/1148x1148/smart/filters:no_upscale()/qr-code-bc94057f452f4806af70fd34540f72ad.png')),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              color: Color.fromARGB(255, 200, 200, 200),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child: Image.network(
                        'https://media.thaigov.go.th/uploads/thumbnail/news/2019/07/IMG_21633_20190718141213000000.jpg'),
                  ),
                  Container(
                     width: MediaQuery.of(context).size.width * 0.56,
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('1234567891112',
                            style: TextStyle(fontSize: 17)),
                        Text('ออมทรัพย์', style: TextStyle(fontSize: 17)),
                        Text('นายณัฐพล จันทร์รอน',
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  Spacer(),
                  Card(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () {
                            clipboard1();
                          }, icon: Icon(Icons.copy)),
                          Text('คัดลอก')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 1,
              color: Color.fromARGB(255, 200, 200, 200),
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    child:  Image.network('http://innews.news/images/1612503758-1.jpg'),
                  ),
                  Container(
                     width: MediaQuery.of(context).size.width * 0.56,
                    
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('1234567891112',
                            style: TextStyle(fontSize: 17)),
                        Text('ออมทรัพย์', style: TextStyle(fontSize: 17)),
                        Text('นายณัฐพล จันทร์รอน',
                            style: TextStyle(fontSize: 17)),
                      ],
                    ),
                  ),
                  Spacer(),
                  Card(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: () {
                            clipboard2();
                          }, icon: Icon(Icons.copy)),
                          Text('คัดลอก')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
         
        ],
      ),
    );
  }

  Container showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1!, lng2!);
      position = CameraPosition(
        target: latLng1,
        zoom: 16.0,
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('shopMarker'),
        position: LatLng(lat2!, lng2!),
        icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
        infoWindow: InfoWindow(title: userModel!.nameShop),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[shopMarker()].toSet();
    }

    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      height: 250,
      child: lat1 == null
          ? MyStyle().showProgress()
          : GoogleMap(
              initialCameraPosition: position,
              mapType: MapType.normal,
              onMapCreated: (controller) {},
              markers: mySet(),
            ),
    );
  }
  
  void clipboard1() {
     FlutterClipboard.copy('1234567891112').then(( value ) => showToast('คัดลอกเลขบัญชีสำเร็จ'));
  }
  void clipboard2() {
     FlutterClipboard.copy('1234567891358').then(( value ) => showToast('คัดลอกเลขบัญชีสำเร็จ'));
  }

   void showToast(String? string) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(string!),
        action: SnackBarAction(
            label: 'ปิด', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

}
