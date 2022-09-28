import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:champshop/model/user_model.dart';
import 'package:champshop/screens/add_info_shop.dart';
import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/edit_info_shop.dart';
import '../utility/my_constant.dart';

class InfomationShop extends StatefulWidget {
  const InfomationShop({Key? key}) : super(key: key);

  @override
  State<InfomationShop> createState() => _InfomationShopState();
}

class _InfomationShopState extends State<InfomationShop> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      // print('value = $value');
      var result = json.decode(value.data);
      // print('result = $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
        print('ชื่อร้าน : ${userModel!.nameShop}');
      }
    });
  }

    void routeToAddInfo() {
    
    Widget widget = userModel!.nameShop!.isEmpty ? AddInfoShop()  :EditInfoShop()  ;
    MaterialPageRoute materialPageRoute = MaterialPageRoute(
      builder: (context) => widget,
    );
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        userModel == null
            ? MyStyle().showProgress()
            : userModel!.nameShop!.isEmpty
                ? showNoData(context)
                : showListInfoShop(),
        addAndEditButton(),
      ],
    );
  }

  Widget showListInfoShop() => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            MyStyle().showTitle1('รายละเอียดร้าน ${userModel!.nameShop}'),
            showImage(),
            Row(
              children: <Widget>[
                MyStyle().showTitle1('ที่อยู่ของร้าน'),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  // add this
                  child: Text(
                    (userModel!.address!),
                    maxLines: 2, // you can change it accordingly
                    overflow: TextOverflow.ellipsis, // and this
                  ),
                ),
              ],
            ),
            MyStyle().mySizebox(),
            showMap(),
          ],
        ),
      );

  Container showImage() {
    // return Container(
    //   width: 200.0,
    //   height: 200.0,
    //   child: Image.network('${MyConstant().domain}${userModel!.urlPicture}'),
    // );
    return Container(
        width: 200.0,
        height: 200.0,
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
              '${MyConstant().domain}${userModel!.urlPicture}'),
        ));
  }

  Set<Marker> shopMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('shopID'),
          position: LatLng(
            double.parse(userModel!.lat!),
            double.parse(userModel!.lng!),
          ),
          infoWindow: InfoWindow(
              title: 'ตำแหน่งร้าน',
              snippet:
                  'ละติจูต = ${userModel!.lat}, ลองติจูต = ${userModel!.lng}'))
    ].toSet();
  }

  Widget showMap() {
    double lat = double.parse(userModel!.lat!);
    double lng = double.parse(userModel!.lng!);
    print('lat = $lat, lng = $lng');

    LatLng latLng = LatLng(lat, lng);
    CameraPosition position = CameraPosition(target: latLng, zoom: 16.0);

    return Expanded(
      child: GoogleMap(
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: shopMarker(),
      ),
    );
  }

  Widget showNoData(BuildContext context) {
    return MyStyle()
        .titleCenter(context, 'ยังไม่มี ข้อมูล กรุณาเพิ่มข้อมูลด้วย คะ');
  }

  Row addAndEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20, bottom: 20),
              child: FloatingActionButton(
                child: Icon(Icons.edit),
                onPressed: () => routeToAddInfo(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
