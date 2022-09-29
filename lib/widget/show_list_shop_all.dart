import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../screens/show_shop_product_menu.dart';
import '../utility/my_constant.dart';
import '../utility/my_style.dart';

class ShowListShopAll extends StatefulWidget {
  const ShowListShopAll({Key? key}) : super(key: key);

  @override
  State<ShowListShopAll> createState() => _ShowListShopAllState();
}

class _ShowListShopAllState extends State<ShowListShopAll> {

  List<UserModel> userModels = [];
  List<Widget> shopCards = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    readShop();
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
          print('NameShop = ${model.nameShop}');
          setState(() {
            userModels.add(model);
            shopCards.add(createCard(model, index));
            index++;
          });
        }
      }
    });
  }

  Widget createCard(UserModel userModel, int index) {
    return GestureDetector(
      onTap: () {
        print('You Click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => ShowShopProductMenu(
            userModel: userModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    '${MyConstant().domain}${userModel.urlPicture}'),
              ),
            ),
            MyStyle().mySizebox2(),
            MyStyle().showSubTitle(userModel.nameShop!),
          ],
        ),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return shopCards.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 250,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: shopCards,
            );
    
  }
}