import 'dart:convert';
import 'package:champshop/widget/imageslide/guild_page_five.dart';
import 'package:champshop/widget/imageslide/guild_page_four.dart';
import 'package:champshop/widget/imageslide/guild_page_three.dart';
import 'package:champshop/widget/imageslide/guild_page_two.dart';
import 'package:champshop/widget/user/show_information_shop.dart';

import '';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:champshop/model/user_model.dart';
import 'package:champshop/utility/my_api.dart';
import 'package:champshop/widget/about_shop.dart';
import 'package:champshop/widget/product/show_shop_type_all.dart';
import 'package:champshop/widget/user/show_setting.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/product_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';
import '../../utility/signout_process.dart';
import '../imageslide/guild_page_one.dart';

class ShowFirstPage extends StatefulWidget {
  const ShowFirstPage({Key? key}) : super(key: key);

  @override
  State<ShowFirstPage> createState() => _ShowFirstPageState();
}

class _ShowFirstPageState extends State<ShowFirstPage> {
  List<UserModel> userModels = [];
  UserModel? userModel;
  String? idShop = '1';
  List<ProductModel> productModels = [];
  String? nameUser;
  String? phoneUser;
  String? addressUser;
  String? lat;
  String? lng;
  String? urlPicture;

  Location location = Location();
  double? lat1, lng1;
  double? lat2 = 13.712754;
  double? lng2 = 100.434610;
  String? distanceString;
  int? transport;
  late CameraPosition position;

  @override
  void initState() {
    super.initState();
    readShop();
    readProductMenu();
    checkPreferance();
    findLat1Lng1();
   
  }

  Future<Null> findLat1Lng1() async {
    LocationData? locationData = await findLocationData();
    setState(() {
      lat1 = locationData!.latitude!;
      lng1 = locationData.longitude!;
      // lat2 = double.parse(userModel.lat);
      print('lat1 = $lng1, lng1 = $lng1, lat2 = $lat2, lng2 = $lng2');
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

  Future<void> checkPreferance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nameUser = preferences.getString('Name');
      phoneUser = preferences.getString('Phone');
      addressUser = preferences.getString('Address');
      lat = preferences.getString('Lat');
      lng = preferences.getString('Lng');
      // slip = preferences.getString('Slip');
      urlPicture = preferences.getString('UrlPicture');
      print('$nameUser $phoneUser $addressUser $lat $lng $urlPicture');
    });
  }

  Future<Null> readProductMenu() async {
    idShop = '1';
    String url = '${MyConstant().domain}/champshop/getProductTypeAll.php?isAdd';
    Response response = await Dio().get(url);
    var result = json.decode(response.data);
    // print('res ==> $result');
    for (var map in result) {
      ProductModel productModel = ProductModel.fromJson(map);
      setState(() {
        productModels.add(productModel);
      });
    }
  }

  Future<Null> readShop() async {
    String url =
        '${MyConstant().domain}/champshop/getUserWhereChooseType.php?isAdd=true&ChooseType=Shop';
    await Dio().get(url).then((value) {
      // print('$value');
      var result = json.decode(value.data);
      int index = 0;
      for (var map in result) {
        UserModel model = UserModel.fromJson(map);
        String? nameShop = model.nameShop;
        if (nameShop!.isNotEmpty) {
          // print('NameShop = ${model.nameShop}');
          setState(() {
            userModels.add(model);
            // shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 202, 125),
      appBar: AppBar(
        
        title: Text('สวัสดี $nameUser',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color.fromARGB(255, 255, 255, 255),
            )), actions: <Widget>[
               Padding(
      padding: EdgeInsets.only(right: 30.0),
      child: GestureDetector(
        onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShowInfarmationShop()));
              },
        child: Icon(
            Icons.chat
        ),
      )
    ),
    Padding(
      padding: EdgeInsets.only(right: 30.0),
      child: GestureDetector(
        onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return ShowSetting();
                    }));
              },
        child: Icon(
            Icons.settings
        ),
      )
    ),
    
  ],
        backgroundColor: Color.fromARGB(255, 254, 202, 125),
        elevation: 0,
      ),
      // body: SingleChildScrollView(
      //   child: Container(
      //     child: Column(
      //       children: [
      //         showBaner(),
      //         showImageSlide(),
      //         // showHeadText1(),
      //         // showLastProduct(),
      //         // showMap(),
      //       ],
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                color: Color.fromARGB(236, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageOne()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageTwo()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner2.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageThree()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner3.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageFour()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner4.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuildPageFive()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(),
                        width: 300,
                        height: 150,
                        child: Image.asset(
                          'images/banner5.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  MyStyle().mySizebox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CarouselSlider showImageSlide() {
    return CarouselSlider(
      items: [
        //1st Image of Slider
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GuildPageOne()));
          },
          child: Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: new DecorationImage(
                image: new AssetImage('images/banner1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        //2nd Image of Slider
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GuildPageTwo()));
          },
          child: Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: new DecorationImage(
                image: new AssetImage('images/banner2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        //3rd Image of Slider
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GuildPageThree()));
          },
          child: Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: new DecorationImage(
                image: new AssetImage('images/banner3.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GuildPageFour()));
          },
          child: Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: new DecorationImage(
                image: new AssetImage('images/banner4.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GuildPageFive()));
          },
          child: Container(
            margin: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: new DecorationImage(
                image: new AssetImage('images/banner5.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],

      //Slider Container properties
      options: CarouselOptions(
        height: 200.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 2000),
        viewportFraction: 0.8,
      ),
    );
  }

  showLastProduct() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 150,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(95, 211, 211, 211),
                    width: 1, //                   <--- border width here
                  ),
                  color: Color.fromARGB(255, 251, 236, 216),
                  borderRadius: BorderRadius.circular(1)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: NetworkImage(
                              '${MyConstant().domain}${productModels[0].pathImage!}'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Container(
                      child: new Text(
                        '${productModels[0].nameProduct!}',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 96, 96, 96),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${productModels[0].price!} บาท.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 228, 126, 92))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 150,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(95, 211, 211, 211),
                    width: 1, //                   <--- border width here
                  ),
                  color: Color.fromARGB(255, 251, 236, 216),
                  borderRadius: BorderRadius.circular(1)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: NetworkImage(
                              '${MyConstant().domain}${productModels[1].pathImage!}'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Container(
                      child: new Text(
                        '${productModels[1].nameProduct!}',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 96, 96, 96),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${productModels[1].price!} บาท.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 228, 126, 92))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 150,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(95, 211, 211, 211),
                    width: 1, //                   <--- border width here
                  ),
                  color: Color.fromARGB(255, 251, 236, 216),
                  borderRadius: BorderRadius.circular(1)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: NetworkImage(
                              '${MyConstant().domain}${productModels[2].pathImage!}'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Container(
                      child: new Text(
                        '${productModels[2].nameProduct!}',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 96, 96, 96),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${productModels[2].price!} บาท.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 228, 126, 92))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 150,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(95, 211, 211, 211),
                    width: 1, //                   <--- border width here
                  ),
                  color: Color.fromARGB(255, 251, 236, 216),
                  borderRadius: BorderRadius.circular(1)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: NetworkImage(
                              '${MyConstant().domain}${productModels[3].pathImage!}'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Container(
                      child: new Text(
                        '${productModels[3].nameProduct!}',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 96, 96, 96),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${productModels[3].price!} บาท.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 228, 126, 92))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Container(
              width: 150,
              height: 180,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(95, 211, 211, 211),
                    width: 1, //                   <--- border width here
                  ),
                  color: Color.fromARGB(255, 251, 236, 216),
                  borderRadius: BorderRadius.circular(1)),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: NetworkImage(
                              '${MyConstant().domain}${productModels[4].pathImage!}'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: new Container(
                      child: new Text(
                        '${productModels[4].nameProduct!}',
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                          fontSize: 15.0,
                          color: Color.fromARGB(255, 96, 96, 96),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('${productModels[4].price!} บาท.',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 228, 126, 92))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container showHeadText1() {
    return Container(
      width: 350,
      height: 60,
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, 205, 50, 205),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text(
                  'สินค้าใหม่',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 241, 122, 89)),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ShowShopTypeAll(userModel: userModels[0])));
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'ดูเพิ่มเติม >',
                    style: TextStyle(
                        fontSize: 13,
                        // fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 105, 105, 105)),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container showSearchBox() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
          // color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(18, 8, 18, 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                width: 330,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFF3F2F3),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4,
                      color: Color(0x33000000),
                      offset: Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: TextFormField(
                          // controller: textController,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            // hintStyle: FlutterFlowTheme.of(context).bodyText2,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x00000000),
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0),
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 22,
                            ),
                            suffixIcon: Icon(
                              Icons.filter_alt,
                              // color: FlutterFlowTheme.of(context).darkSeaGreen,
                              size: 22,
                            ),
                          ),
                          // style: FlutterFlowTheme.of(context).bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Stack showBaner() {
    return Stack(
      children: [
        // CarouselSlider(
        //   items: [
        //     Container(
        //          width: 392.5,
        //   height: 250,
        //       decoration: BoxDecoration(
        //         image: new DecorationImage(
        //           image: new AssetImage('images/pngegg.png'),
        //           fit: BoxFit.cover,
        //         ),
        //       ),
        //     ),
        //   ],
        //   options: CarouselOptions(

        //     height: 250.0,
        //     autoPlay: true,
        //     aspectRatio: 16 / 9,
        //     autoPlayCurve: Curves.fastOutSlowIn,
        //     enableInfiniteScroll: true,
        //     autoPlayAnimationDuration: Duration(milliseconds: 2000),
        //     viewportFraction: 0.8,
        //   ),
        // ),
        Container(
          width: 392.5,
          height: 250,
          child: Image.asset('images/pngegg.png',
              fit: BoxFit.cover, colorBlendMode: BlendMode.darken),
        ),
        Positioned(
          top: 40.0,
          right: 10.0,
          child: Container(
            child: IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ShowSetting()));
              },
              icon: Icon(
                Icons.settings,
                color: Color.fromARGB(180, 60, 60, 60),
              ),
            ),
          ),
        ),
        //  Positioned(
        //   bottom: 40.0,
        //   left: 20.0,
        //    child: Container(
        //           width: 100.0,
        //           height: 100.0,
        //           child: CircleAvatar(
        //             backgroundImage: NetworkImage(
        //                 "${MyConstant().domain}$urlPicture"), //NetworkImage
        //             radius: 100,
        //           ),
        //         ),
        //  ),
        Positioned(
          bottom: 0.0,
          // left: 20.0,
          child: Container(
            width: 392.5,
            height: 30,
            color: Color.fromARGB(45, 91, 91, 91),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '  ยินดีต้อนรับ',
                      style: TextStyle(
                        fontSize: 19,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
                Text(
                  ' $nameUser',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column showMap() {
    if (lat1 != null) {
      LatLng latLng1 = LatLng(lat1!, lng2!);
      position = CameraPosition(
        target: latLng1,
        zoom: 12.0,
      );
    }

    Marker userMarker() {
      return Marker(
        markerId: MarkerId('userMarker'),
        position: LatLng(lat1!, lng1!),
        icon: BitmapDescriptor.defaultMarkerWithHue(1.0),
        infoWindow: InfoWindow(title: 'คุณอยู่ที่นี่'),
      );
    }

    Marker shopMarker() {
      return Marker(
        markerId: MarkerId('shopMarker'),
        position: LatLng(lat2!, lng2!),
        icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
        infoWindow: InfoWindow(title: 'ร้านค้า'),
      );
    }

    Set<Marker> mySet() {
      return <Marker>[userMarker(), shopMarker()].toSet();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text('ที่อยู่ร้านค้า ',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 241, 122, 89))),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
          height: 250,
          child: lat1 == null
              ? MyStyle().showProgress()
              : GoogleMap(
                  initialCameraPosition: position,
                  mapType: MapType.normal,
                  onMapCreated: (controller) {},
                  markers: mySet(),
                ),
        ),
      ],
    );
  }
}
