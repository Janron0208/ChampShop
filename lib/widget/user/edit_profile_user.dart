import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import '../../utility/my_constant.dart';
import '../../utility/my_style.dart';
import '../../utility/normal_dialog.dart';

class EditProfileUser extends StatefulWidget {
  const EditProfileUser({Key? key}) : super(key: key);

  @override
  State<EditProfileUser> createState() => _EditProfileUserState();
}

class _EditProfileUserState extends State<EditProfileUser> {
  UserModel? userModel;
  String? nameUser, nickname, address, phone, urlPicture;
  String? district, county, zipcode, transport, sumAddress;
  File? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentInfo();
  }

  Future<Null> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idUSer = preferences.getString('id');
    print('idUser ==>> $idUSer');

    String url =
        '${MyConstant().domain}/champshop/getUserWhereId.php?isAdd=true&id=$idUSer';

    Response response = await Dio().get(url);
    // print('response ==>> $response');

    var result = json.decode(response.data);
    // print('result ==>> $result');

    for (var map in result) {
      print('map ==>> $map');
      setState(() {
        userModel = UserModel.fromJson(map);
        nameUser = userModel?.name;
        nickname = userModel?.nickname;
        address = userModel?.address;
        phone = userModel?.phone;
        urlPicture = userModel?.urlPicture;

        district = userModel?.district;
        county = userModel?.county;
        zipcode = userModel?.zipcode;
        transport = userModel?.transport;
        sumAddress = userModel?.sumAddress;
      });
    }
  }

  final List<String> items = [
    'เขตพระนคร(ค่าส่ง+160บาท)',
    'เขตดุสิต(ค่าส่ง+170บาท)',
    'เขตหนองจอก(ค่าส่ง+300บาท)',
    'เขตบางรัก(ค่าส่ง+160บาท)',
    'เขตบางเขน(ค่าส่ง+220บาท)',
    'เขตบางกะปิ(ค่าส่ง+220บาท)',
    'เขตปทุมวัน(ค่าส่ง+170บาท)',
    'เขตป้อมปราบศัตรูพ่าย(ค่าส่ง+160บาท)',
    'เขตพระโขนง(ค่าส่ง+200บาท)',
    'เขตมีนบุรี(ค่าส่ง+270บาท)',
    'เขตลาดกระบัง(ค่าส่ง+270บาท)',
    'เขตยานนาวา(ค่าส่ง+170บาท)',
    'เขตสัมพันธวงศ์(ค่าส่ง+160บาท)',
    'เขตพญาไท(ค่าส่ง+180บาท)',
    'เขตธนบุรี(ค่าส่ง+150บาท)',
    'เขตบางกอกใหญ่(ค่าส่ง+150บาท)',
    'เขตห้วยขวาง(ค่าส่ง+190บาท)',
    'เขตคลองสาน(ค่าส่ง+170บาท)',
    'เขตตลิ่งชัน(ค่าส่ง+120บาท)',
    'เขตบางกอกน้อย(ค่าส่ง+150บาท)',
    'เขตบางขุนเทียน(ค่าส่ง+140บาท)',
    'เขตภาษีเจริญ(ค่าส่ง+120บาท)',
    'เขตหนองแขม(ค่าส่ง+120บาท)',
    'เขตราษฎร์บูรณะ(ค่าส่ง+150บาท)',
    'เขตบางพลัด(ค่าส่ง+160บาท)',
    'เขตดินแดง(ค่าส่ง+180บาท)',
    'เขตบึงกุ่ม(ค่าส่ง+220บาท)',
    'เขตสาทร(ค่าส่ง+160บาท)',
    'เขตบางซื่อ(ค่าส่ง+180บาท)',
    'เขตจตุจักร(ค่าส่ง+200บาท)',
    'เขตบางคอแหล(ค่าส่ง+160บาท)',
    'เขตประเวศ(ค่าส่ง+220บาท)',
    'เขตคลองเตย(ค่าส่ง+180บาท)',
    'เขตสวนหลวง(ค่าส่ง+200บาท)',
    'เขตจอมทอง(ค่าส่ง+120บาท)',
    'เขตดอนเมือง(ค่าส่ง+250บาท)',
    'เขตราชเทวี(ค่าส่ง+180บาท)',
    'เขตลาดพร้าว(ค่าส่ง+220บาท)',
    'เขตวัฒนา(ค่าส่ง+180บาท)',
    'เขตบางแค(ค่าส่ง+100บาท)',
    'เขตหลักสี่(ค่าส่ง+220บาท)',
    'เขตสายไหม(ค่าส่ง+250บาท)',
    'เขตคันนายาว(ค่าส่ง+240บาท)',
    'เขตสะพานสูง(ค่าส่ง+240บาท)',
    'เขตวังทองหลาง(ค่าส่ง+200บาท)',
    'เขตคลองสามวา(ค่าส่ง+270บาท)',
    'เขตบางนา(ค่าส่ง+200บาท)',
    'เขตทวีวัฒนา(ค่าส่ง+120บาท)',
    'เขตทุ่งครุ(ค่าส่ง+140บาท)',
    'เขตบางบอน(ค่าส่ง+120บาท)',
    'เขตอื่น(ค่าส่ง+350บาท)'
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'แก้ไขข้อมูลลูกค้า',
            style:
                TextStyle(color: Color.fromARGB(255, 61, 61, 61), fontSize: 20),
          ),
          backgroundColor: Color.fromARGB(255, 247, 133, 88),
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 61, 61, 61)),
        ),
        body: userModel == null
            ? MyStyle().showProgress()
            : SingleChildScrollView(
                child: Container(
                  color: Color.fromARGB(255, 255, 230, 206),
                  child: Column(
                    children: [
                      showImage(),
                      nameForm(),
                      nicknameForm(),
                      phoneForm(),
                      addressForm(),
                      districtForm(),
                      countyForm(),
                      zipcodeForm(),
                      saveBtn(),
                    ],
                  ),
                ),
              ));
  }

  Padding saveBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 60, bottom: 60),
      child: SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
          child: Text(
            'บันทึกข้อมูล',
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
          ),
          onPressed: () {
            editThread();
          },
          style: ElevatedButton.styleFrom(
            elevation: 1,
            primary: Color.fromARGB(255, 255, 152, 118),
          ),
        ),
      ),
    );
  }

  Padding showImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          file == null
              ? Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(255, 254, 175, 101),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        '${MyConstant().domain}$urlPicture',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color.fromARGB(255, 254, 175, 101),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image.file(file!,
                          fit: BoxFit.cover, width: 150, height: 150),
                    ),
                  ),
                ),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 120,
                  child: ElevatedButton(
                    child: Text(
                      'ถ่ายรูป',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 122, 45), fontSize: 12),
                    ),
                    onPressed: () => chooseImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      primary: Color.fromARGB(255, 239, 239, 239),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
                  Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(width: 120,
                  child: ElevatedButton(
                    child: Text(
                      'แกลอรี่',
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 122, 45), fontSize: 12),
                    ),
                    onPressed: () => chooseImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      primary: Color.fromARGB(255, 239, 239, 239),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Padding nameForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 25, 20, 16),
      child: TextFormField(
        onChanged: (value) => nameUser = value,
        initialValue: nameUser,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อ-นามสกุลผู้ใช้',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Padding nicknameForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        onChanged: (value) => nickname = value,
        initialValue: nickname,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ชื่อผู้ใช้',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Padding phoneForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        onChanged: (value) => phone = value,
        initialValue: phone,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'เบอร์โทรศัพท์',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Padding addressForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 5),
      child: TextFormField(
        maxLines: 2,
        onChanged: (value) => address = value,
        initialValue: address,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'ที่อยู่',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Padding districtForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 5),
      child: TextFormField(
        maxLines: 1,
        onChanged: (value) => district = value,
        initialValue: district,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'แขวง',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline countyForm() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: [
            // Icon(
            //   Icons.list,
            //   size: 23,
            //   color: Color.fromARGB(255, 255, 155, 135),
            // ),
            SizedBox(
              width: 5,
            ),
            Text(
              '$county (ค่าส่ง+$transportบาท)',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value as String;
          });
        },
        icon: const Icon(
          Icons.arrow_forward_ios_outlined,
        ),
        iconSize: 16,
        iconEnabledColor: Color.fromARGB(255, 217, 217, 217),
        // iconDisabledColor: Colors.grey,
        buttonHeight: 65,
        buttonWidth: 300,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromARGB(255, 217, 217, 217),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        buttonElevation: 0,
        itemHeight: 50,
        
        itemPadding: const EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: 300,
        dropdownWidth: 300,
        dropdownPadding: null,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        dropdownElevation: 8,
        scrollbarRadius: const Radius.circular(40),
        scrollbarThickness: 6,
        scrollbarAlwaysShow: true,
        offset: const Offset(-20, 0),
      ),
    );
  }

  Padding zipcodeForm() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 5),
      child: TextFormField(
        maxLines: 1,
        onChanged: (value) => zipcode = value,
        initialValue: zipcode,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'รหัสไปรษณีย์',
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 217, 217, 217),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
      ),
    );
  }

  Future<Null> checkTransport() async {
    if (selectedValue == 'เขตพระนคร(ค่าส่ง+160บาท)') {
      transport = '160';
      county = 'เขตพระนคร';
    } else if (selectedValue == 'เขตดุสิต(ค่าส่ง+170บาท)') {
      transport = '170';
      county = 'เขตดุสิต';
    } else if (selectedValue == 'เขตหนองจอก(ค่าส่ง+300บาท)') {
      transport = '300';
      county = 'เขตหนองจอก';
    } else if (selectedValue == 'เขตบางรัก(ค่าส่ง+160บาท)') {
      transport = '160';
      county = 'เขตบางรัก';
    } else if (selectedValue == 'เขตบางเขน(ค่าส่ง+220บาท)') {
      transport = '220';
      county = 'เขตบางเขน';
    } else if (selectedValue == 'เขตบางกะปิ(ค่าส่ง+220บาท)') {
      transport = '220';
      county = 'เขตบางกะปิ';
    } else if (selectedValue == 'เขตปทุมวัน(ค่าส่ง+170บาท)') {
      transport = '170';
      county = 'เขตปทุมวัน';
    } else if (selectedValue == 'เขตป้อมปราบศัตรูพ่าย(ค่าส่ง+160บาท)') {
      transport = '160';
      county = 'เขตป้อมปราบศัตรูพ่าย';
    } else if (selectedValue == 'เขตพระโขนง(ค่าส่ง+200บาท)') {
      transport = '200';
      county = 'เขตพระโขนง';
    } else if (selectedValue == 'เขตมีนบุรี(ค่าส่ง+270บาท)') {
      transport = '270';
      county = 'เขตมีนบุรี';
    } else if (selectedValue == 'เขตลาดกระบัง(ค่าส่ง+270บาท)') {
      transport = '270';
      county = 'เขตลาดกระบัง';
    } else if (selectedValue == 'เขตยานนาวา(ค่าส่ง+170บาท)') {
      transport = '170';
      county = 'เขตยานนาวา';
    } else if (selectedValue == 'เขตสัมพันธวงศ์(ค่าส่ง+160บาท)') {
      transport = '160';
      county = 'เขตสัมพันธวงศ์';
    } else if (selectedValue == 'เขตพญาไท(ค่าส่ง+180บาท)') {
      transport = '180';
      county = 'เขตพญาไท';
    } else if (selectedValue == 'เขตธนบุรี(ค่าส่ง+150บาท)') {
      transport = '150';
      county = 'เขตธนบุรี';
    } else if (selectedValue == 'เขตบางกอกใหญ่(ค่าส่ง+150บาท)') {
      transport = '150';
      county = 'เขตบางกอกใหญ่';
    } else if (selectedValue == 'เขตห้วยขวาง(ค่าส่ง+190บาท)') {
      transport = '190';
      county = 'เขตห้วยขวาง';
    } else if (selectedValue == 'เขตคลองสาน(ค่าส่ง+170บาท)') {
      transport = '170';
      county = 'เขตคลองสาน';
    } else if (selectedValue == 'เขตตลิ่งชัน(ค่าส่ง+120บาท)') {
      transport = '120';
      county = 'เขตตลิ่งชัน';
    } else if (selectedValue == 'เขตบางกอกน้อย(ค่าส่ง+150บาท)') {
      transport = '150';
      county = 'เขตบางกอกน้อย';
    } else if (selectedValue == 'เขตบางขุนเทียน(ค่าส่ง+140บาท)') {
      transport = '140';
      county = 'เขตบางขุนเทียน';
    } else if (selectedValue == 'เขตภาษีเจริญ(ค่าส่ง+120บาท)') {
      transport = '120';
      county = 'เขตภาษีเจริญ';
    } else if (selectedValue == 'เขตหนองแขม(ค่าส่ง+120บาท)') {
      transport = '120';
      county = 'เขตหนองแขม';
    } else if (selectedValue == 'เขตราษฎร์บูรณะ(ค่าส่ง+150บาท)') {
      transport = '150';
      county = 'เขตราษฎร์บูรณะ';
    } else if (selectedValue == 'เขตบางพลัด(ค่าส่ง+160บาท)') {
      transport = '160';
      county = 'เขตบางพลัด';
    } else if (selectedValue == 'เขตดินแดง(ค่าส่ง+180บาท)') {
      transport = '180';
      county = 'เขตดินแดง';
    } else if (selectedValue == 'เขตบึงกุ่ม(ค่าส่ง+220บาท)') {
      transport = '220';
      county = 'เขตบึงกุ่ม';
    } else if (selectedValue == 'เขตสาทร(ค่าส่ง+160บาท)') {
      transport = '160';
      county = 'เขตสาทร';
    } else if (selectedValue == 'เขตบางซื่อ(ค่าส่ง+180บาท)') {
      transport = '180';
      county = 'เขตบางซื่อ';
    } else if (selectedValue == 'เขตจตุจักร(ค่าส่ง+200บาท)') {
      transport = '200';
      county = 'เขตจตุจักร';
    } else if (selectedValue == 'เขตบางคอแหล(ค่าส่ง+160บาท)') {
      transport = '160';
      county = 'เขตบางคอแหลม';
    } else if (selectedValue == 'เขตประเวศ(ค่าส่ง+220บาท)') {
      transport = '220';
      county = 'เขตประเวศ';
    } else if (selectedValue == 'เขตคลองเตย(ค่าส่ง+180บาท)') {
      transport = '180';
      county = 'เขตคลองเตย';
    } else if (selectedValue == 'เขตสวนหลวง(ค่าส่ง+200บาท)') {
      transport = '200';
      county = 'เขตสวนหลวง';
    } else if (selectedValue == 'เขตจอมทอง(ค่าส่ง+120บาท)') {
      transport = '120';
      county = 'เขตจอมทอง';
    } else if (selectedValue == 'เขตดอนเมือง(ค่าส่ง+250บาท)') {
      transport = '250';
      county = 'เขตดอนเมือง';
    } else if (selectedValue == 'เขตราชเทวี(ค่าส่ง+180บาท)') {
      transport = '180';
      county = 'เขตราชเทวี';
    } else if (selectedValue == 'เขตลาดพร้าว(ค่าส่ง+220บาท)') {
      transport = '220';
      county = 'เขตลาดพร้าว';
    } else if (selectedValue == 'เขตวัฒนา(ค่าส่ง+180บาท)') {
      transport = '180';
      county = 'เขตวัฒนา';
    } else if (selectedValue == 'เขตบางแค(ค่าส่ง+100บาท)') {
      transport = '100';
      county = 'เขตบางแค';
    } else if (selectedValue == 'เขตหลักสี่(ค่าส่ง+220บาท)') {
      transport = '220';
      county = 'เขตหลักสี่';
    } else if (selectedValue == 'เขตสายไหม(ค่าส่ง+250บาท)') {
      transport = '250';
      county = 'เขตสายไหม';
    } else if (selectedValue == 'เขตคันนายาว(ค่าส่ง+240บาท)') {
      transport = '240';
      county = 'เขตคันนายาว';
    } else if (selectedValue == 'เขตสะพานสูง(ค่าส่ง+240บาท)') {
      transport = '240';
      county = 'เขตสะพานสูง';
    } else if (selectedValue == 'เขตวังทองหลาง(ค่าส่ง+200บาท)') {
      transport = '200';
      county = 'เขตวังทองหลาง';
    } else if (selectedValue == 'เขตคลองสามวา(ค่าส่ง+270บาท)') {
      transport = '270';
      county = 'เขตคลองสามวา';
    } else if (selectedValue == 'เขตบางนา(ค่าส่ง+200บาท)') {
      transport = '200';
      county = 'เขตบางนา';
    } else if (selectedValue == 'เขตทวีวัฒนา(ค่าส่ง+120บาท)') {
      transport = '120';
      county = 'เขตทวีวัฒนา';
    } else if (selectedValue == 'เขตทุ่งครุ(ค่าส่ง+140บาท)') {
      transport = '140';
      county = 'เขตทุ่งครุ';
    } else if (selectedValue == 'เขตบางบอน(ค่าส่ง+120บาท)') {
      transport = '120';
      county = 'เขตบางบอน';
    } else if (selectedValue == 'เขตอื่น(ค่าส่ง+350บาท)') {
      transport = '350';
      county = 'เขตอื่น';
    } else {
      transport = userModel?.transport;
      county = userModel?.county;
    }
  }

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var object = await ImagePicker()
          .getImage(source: source, maxWidth: 800.0, maxHeight: 800.0);

      setState(() {
        file = File(object!.path);
      });
    } catch (e) {}
  }

  Future<Null> confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ต้องการบันทึกหรือไม่'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  checkTransport();
                  editThread();
                  Navigator.pop(context);
                },
                child: Text('ยืนยัน'),
              ),
              MyStyle().mySizebox(),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> editThread() async {
    print(file);

    if (file == null) {
      String? id = userModel!.id!;
      print(id);
      checkTransport();
      print('ไมมีรูปใหม่');
      print(
          'name = $nameUser, nickname = $nickname, address = $address $district $county $zipcode, transport = $transport, phone = $phone, avatar = $urlPicture');
      checkTransport();
      String sumAddress = '$address แขวง$district $county กทม. $zipcode';
      print(sumAddress);
      String url =
          '${MyConstant().domain}/champshop/editBuyerWhereId.php?isAdd=true&id=$id&Name=$nameUser&Nickname=$nickname&Address=$address&Phone=$phone&UrlPicture=$urlPicture&District=$district&County=$county&Zipcode=$zipcode&Transport=$transport&SumAddress=$sumAddress';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        showToast("บันทึกข้อมูลสำเร็จแล้ว");
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ยังอัพเดทไม่ได้ กรุณาลองใหม่');
      }
    } else {
      print('มีรูปใหม่');
      Random random = Random();
      int i = random.nextInt(100000);
      String nameFile = 'editAvatar$i.jpg';

      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      String urlUpload = '${MyConstant().domain}/champshop/saveUser.php';
      print('### $nameFile');
      urlPicture = '/champshop/Avatar/$nameFile';
      print('### $urlPicture');

      await Dio().post(urlUpload, data: formData).then((value) async {
        urlPicture = '/champshop/Avatar/$nameFile';

        String? id = userModel!.id!;

        checkTransport();
        String sumAddress = '$address แขวง$district $county กทม. $zipcode';

        print('$sumAddress');
        print(
            '## name = $nameUser, nickname = $nickname, address = $address $district $county $zipcode, transport = $transport, phone = $phone, avatar = $urlPicture');

        String url =
            '${MyConstant().domain}/champshop/editBuyerWhereId.php?isAdd=true&id=$id&Name=$nameUser&Nickname=$nickname&Address=$address&Phone=$phone&UrlPicture=$urlPicture&District=$district&County=$county&Zipcode=$zipcode&Transport=$transport&SumAddress=$sumAddress';

        Response response = await Dio().get(url);
        if (response.toString() == 'true') {
          showToast("บันทึกข้อมูลสำเร็จแล้ว");
          Navigator.pop(context);
        } else {
          normalDialog(context, 'ยังอัพเดทไม่ได้ กรุณาลองใหม่');
        }
      });
    }
  }

  void showToast(String? string) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(string!),
        // action: SnackBarAction(

        //     label: 'ปิด', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
