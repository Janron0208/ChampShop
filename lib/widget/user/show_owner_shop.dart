import 'package:champshop/utility/my_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class ShowOwnerShop extends StatefulWidget {
  const ShowOwnerShop({Key? key}) : super(key: key);

  @override
  State<ShowOwnerShop> createState() => _ShowOwnerShopState();
}

class _ShowOwnerShopState extends State<ShowOwnerShop> {
  Location location = Location();
  double? lat1, lng1;
  double? lat2 = 13.712754;
  double? lng2 = 100.434610;

  late CameraPosition position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('รายละเอียดข้อมูลร้านค้า',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color.fromARGB(255, 255, 173, 41))),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 173, 41)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MyStyle().mySizebox0(),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 45,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ข้อมูลเจ้าของร้าน',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 150,
                      // height: 300,
                      child: Image.network(
                          'https://www.pngitem.com/pimgs/m/80-800194_transparent-users-icon-png-flat-user-icon-png.png'),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text('ชื่อ : '),
                            Text('xxxxxxxxxxxxxxx'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('อายุ : '),
                            Text('xx'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('เบอร์โทรศัพท์ : '),
                            Text('09x-xxx-xxxx'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MyStyle().mySizebox0(),
            Container(
              width: MediaQuery.of(context).size.width * 1,
              height: 45,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ที่อยู่ร้านค้า',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 400,
                height: 80,
                color: Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'ที่อยู่ร้าน : ศูนย์การค้าซีคอนบางแค ชั้น 2 เลขที่ 108 ชั้น 1 ถ. เพชรเกษม บางหว้า เขตภาษีเจริญ กรุงเทพมหานคร 10160',
                        style: TextStyle(fontSize: 15)),
                  ),
                ),
              ),
            ),
            showMap()
          ],
        ),
      ),
    );
  }

  Column showMap() {
    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('shopMarker'),
        position: LatLng(13.712754, 100.434610),
        icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
        infoWindow: InfoWindow(title: 'ร้านค้า'),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[shopMarker()].toSet();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
            height: 250,
            child: GoogleMap(
               markers: {
            Marker(
                markerId: MarkerId("1"),
                position: LatLng(13.712754,100.434610),
                infoWindow: InfoWindow(title: "ร้านค้า ChampShop", snippet: "ร้านจำหน่ายอุปกรณืก่อสร้าง")),
          },
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(13.712754,100.434610),
                zoom: 16,
              ),
            ))
      ],
    );
  }
}
