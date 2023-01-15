import 'dart:io';
import 'dart:math';
import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utility/my_constant.dart';
import '../utility/normal_dialog.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final String chooseType = 'User';
  String? name, nickname, user, password, address, phone, urlpicture;
  String? district, county, zipcode, transport, sumAddress;
  String avatar = '';
  File? file;

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
        
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 213, 201),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    buildAvatar(),
                    MyStyle().mySizebox0(),
                    nameForm(),
                    MyStyle().mySizebox0(),
                    nameForm2(),
                    MyStyle().mySizebox0(),
                    phoneForm(),
                    MyStyle().mySizebox2(),
                    addressForm(),
                    MyStyle().mySizebox0(),
                    districtForm(),
                    MyStyle().mySizebox0(),
                    countyForm(),
                    MyStyle().mySizebox0(),
                    zipcodeForm(),
                    MyStyle().mySizebox2(),
                    userForm(),
                    MyStyle().mySizebox0(),
                    passwordForm(),
                    registerButton(),
                    MyStyle().mySizebox1(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonHideUnderline countyForm() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        isExpanded: true,
        hint: Row(
          children: const [
            Icon(
              Icons.list,
              size: 23,
              color: Color.fromARGB(255, 255, 155, 135),
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                ' เลือกเขต',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 15,
                      // fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 60, 60, 60),
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
        iconEnabledColor: Color.fromARGB(195, 255, 155, 135),
        // iconDisabledColor: Colors.grey,
        buttonHeight: 65,
        buttonWidth: 300,
        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
        buttonDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color.fromARGB(166, 255, 155, 135),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        buttonElevation: 0,
        itemHeight: 40,
        itemPadding: const EdgeInsets.only(left: 14, right: 14),
        dropdownMaxHeight: 300,
        dropdownWidth: 200,
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
    } else {
      transport = '350';
      county = 'เขตอื่น';
    }
  }

  Row buildAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          width: 100,
          child: file == null
              ? Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: ExactAssetImage(MyConstant.avatar),
                      )))

              // ShowImage(path: MyConstant.avatar)
              : Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover, image: FileImage(file!)))),
        ),
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => chooseImage(ImageSource.camera),
                    child: Text('กล้องถ่ายรูป'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 255, 114, 104),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => chooseImage(ImageSource.gallery),
                    child: Text('อัลบัมภาพ'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 255, 114, 104),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget nameForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.person, color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'ชื่อ-นามสกุล',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget nameForm2() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => nickname = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_pin,
                color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'ชื่อผู้ใช้',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget addressForm() => Container(
        width: 300.0,
        child: TextField(
          maxLines: 2,
          onChanged: (value) => address = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_city,
                color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'ที่อยู่บ้านเลขที่/ซอย/ถนน',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget districtForm() => Container(
        width: 300.0,
        child: TextField(
          maxLines: 1,
          onChanged: (value) => district = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.local_activity,
                color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'แขวง',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget zipcodeForm() => Container(
        width: 200,
        child: TextField(
          maxLines: 1,
          onChanged: (value) => zipcode = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.comments_disabled,
                color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'รหัสไปรษณีย์',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget phoneForm() => Container(
        width: 300.0,
        child: TextField(
          keyboardType: TextInputType.phone,
          onChanged: (value) => phone = value.trim(),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.phone, color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'เบอร์โทรศัพท์',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget userForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => user = value.trim(),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_add_alt_1,
                color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'บัญชีผู้ใช้',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 244, 54, 54)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Widget passwordForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.lock, color: Color.fromARGB(255, 255, 181, 146)),
            labelStyle: TextStyle(color: MyStyle().fontColor1),
            labelText: 'รหัสผ่าน',
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 253, 192, 159)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  Row showAppName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyStyle().showTitle1('ChampShop'),
      ],
    );
  }

  Widget myLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyStyle().showLogo(),
        ],
      );

  Future<Null> chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().getImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Widget registerButton() => Container(
        margin: EdgeInsets.only(bottom: 20, top: 50),
        width: 280,
        height: 50,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromARGB(255, 255, 155, 135),
          onPressed: () {
            checkTransport();
            print(
                '$address $district $county กทม. $zipcode ค่าส่ง $transport บาท');
            print(
                '## name = $name($nickname), address = $address $district $county $zipcode, transport = $transport, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');

           

            if (name == null ||
                name!.isEmpty ||
                nickname == null ||
                nickname!.isEmpty ||
                address == null ||
                address!.isEmpty ||
                district == null ||
                district!.isEmpty ||
                county == null ||
                county!.isEmpty ||
                zipcode == null ||
                zipcode!.isEmpty ||
                user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty ||
                address == null ||
                address!.isEmpty ||
                phone == null ||
                phone!.isEmpty 
                
                ) {
              print('Have Space');
              normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
            } else {
              if (chooseType == null) {
                normalDialog(context, 'โปรด เลือกชนิดของผู้สมัคร');
              } else {
                checkUser();
              }
            }
          },
          child: Text('สมัครสมาชิก',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      );

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/champshop/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        uploadpictureThread();
      } else {
        normalDialog(
            context, 'User นี่ $user มีคนอื่นใช้ไปแล้ว กรุณาเปลี่ยน User ใหม่');
      }
    } catch (e) {}
  }

  Future<Null> uploadpictureThread() async {
    String apiSaveAvatar = '${MyConstant().domain}/champshop/saveAvatar.php';
    int i = Random().nextInt(100000);
    String nameAvatar = 'avatar$i.jpg';
    Map<String, dynamic> map = Map();
    map['file'] =
        await MultipartFile.fromFile(file!.path, filename: nameAvatar);
    FormData data = FormData.fromMap(map);
    await Dio().post(apiSaveAvatar, data: data).then((value) {
      avatar = '/champshop/Avatar/$nameAvatar';
    });
    print(
        '## name = $name($nickname), address = $address, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');

    registerThread();
  }

  Future<Null> registerThread() async {
    String sumAddress = '$address $district $county กทม. $zipcode';

    String url =
        '${MyConstant().domain}/champshop/addUser.php?isAdd=true&Name=$name&Nickname=$nickname&User=$user&Password=$password&ChooseType=$chooseType&Address=$address&Phone=$phone&UrlPicture=$avatar&District=$district&County=$county&Zipcode=$zipcode&Transport=$transport&SumAddress=$sumAddress';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        showToast('สมัครสมาชิกสำเร็จ');
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถ สมัครได้ กรุณาลองใหม่ คะ');
      }
    } catch (e) {}
  }

  void showToast(String? string) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(string!),
      ),
    );
  }
}
