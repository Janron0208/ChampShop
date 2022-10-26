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
  String? nameUser, address, phone, urlPicture;
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
    'เขตพระนคร',
    'เขตดุสิต',
    'เขตหนองจอก',
    'เขตบางรัก',
    'เขตบางเขน',
    'เขตบางกะปิ',
    'เขตปทุมวัน',
    'เขตป้อมปราบศัตรูพ่าย',
    'เขตพระโขนง',
    'เขตมีนบุรี',
    'เขตลาดกระบัง',
    'เขตยานนาวา',
    'เขตสัมพันธวงศ์',
    'เขตพญาไท',
    'เขตธนบุรี',
    'เขตบางกอกใหญ่',
    'เขตห้วยขวาง',
    'เขตคลองสาน',
    'เขตตลิ่งชัน',
    'เขตบางกอกน้อย',
    'เขตบางขุนเทียน',
    'เขตภาษีเจริญ',
    'เขตหนองแขม',
    'เขตราษฎร์บูรณะ',
    'เขตบางพลัด',
    'เขตดินแดง',
    'เขตบึงกุ่ม',
    'เขตสาทร',
    'เขตบางซื่อ',
    'เขตจตุจักร',
    'เขตบางคอแหลม',
    'เขตประเวศ',
    'เขตคลองเตย',
    'เขตสวนหลวง',
    'เขตจอมทอง',
    'เขตดอนเมือง',
    'เขตราชเทวี',
    'เขตลาดพร้าว',
    'เขตวัฒนา',
    'เขตบางแค',
    'เขตหลักสี่',
    'เขตสายไหม',
    'เขตคันนายาว',
    'เขตสะพานสูง',
    'เขตวังทองหลาง',
    'เขตคลองสามวา',
    'เขตบางนา',
    'เขตทวีวัฒนา',
    'เขตทุ่งครุ',
    'เขตบางบอน',
    'เขตอื่น'
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color.fromARGB(255, 61, 61, 61)),
        ),
        body: userModel == null
            ? MyStyle().showProgress()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    showImage(),
                    nameForm(),
                    phoneForm(),
                    addressForm(),
                    districtForm(),
                    countyForm(),
                    zipcodeForm(),
                    saveBtn(),
                  ],
                ),
              ));
  }

  Padding saveBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
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
                  width: 200,
                  height: 200,
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
                  width: 200,
                  height: 200,
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
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ElevatedButton(
              child: Text(
                'เปลี่ยนรูปภาพ',
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
                // style: TextStyle(
                //   fontSize: 14,
                //   fontWeight: FontWeight.bold,
                //   color: Color.fromARGB(255, 119, 119, 119),
                // ),
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
    if (selectedValue == 'เขตพระนคร') {
      transport = '160';
    } else if (selectedValue == 'เขตดุสิต') {
      transport = '170';
    } else if (selectedValue == 'เขตหนองจอก') {
      transport = '300';
    } else if (selectedValue == 'เขตบางรัก') {
      transport = '160';
    } else if (selectedValue == 'เขตบางเขน') {
      transport = '220';
    } else if (selectedValue == 'เขตบางกะปิ') {
      transport = '220';
    } else if (selectedValue == 'เขตปทุมวัน') {
      transport = '170';
    } else if (selectedValue == 'เขตป้อมปราบศัตรูพ่าย') {
      transport = '160';
    } else if (selectedValue == 'เขตพระโขนง') {
      transport = '200';
    } else if (selectedValue == 'เขตมีนบุรี') {
      transport = '270';
    } else if (selectedValue == 'เขตลาดกระบัง') {
      transport = '270';
    } else if (selectedValue == 'เขตยานนาวา') {
      transport = '170';
    } else if (selectedValue == 'เขตสัมพันธวงศ์') {
      transport = '160';
    } else if (selectedValue == 'เขตพญาไท') {
      transport = '180';
    } else if (selectedValue == 'เขตธนบุรี') {
      transport = '150';
    } else if (selectedValue == 'เขตบางกอกใหญ่') {
      transport = '150';
    } else if (selectedValue == 'เขตห้วยขวาง') {
      transport = '190';
    } else if (selectedValue == 'เขตคลองสาน') {
      transport = '170';
    } else if (selectedValue == 'เขตตลิ่งชัน') {
      transport = '120';
    } else if (selectedValue == 'เขตบางกอกน้อย') {
      transport = '150';
    } else if (selectedValue == 'เขตบางขุนเทียน') {
      transport = '140';
    } else if (selectedValue == 'เขตภาษีเจริญ') {
      transport = '120';
    } else if (selectedValue == 'เขตหนองแขม') {
      transport = '120';
    } else if (selectedValue == 'เขตราษฎร์บูรณะ') {
      transport = '150';
    } else if (selectedValue == 'เขตบางพลัด') {
      transport = '160';
    } else if (selectedValue == 'เขตดินแดง') {
      transport = '180';
    } else if (selectedValue == 'เขตบึงกุ่ม') {
      transport = '220';
    } else if (selectedValue == 'เขตสาทร') {
      transport = '160';
    } else if (selectedValue == 'เขตบางซื่อ') {
      transport = '180';
    } else if (selectedValue == 'เขตจตุจักร') {
      transport = '200';
    } else if (selectedValue == 'เขตบางคอแหลม') {
      transport = '160';
    } else if (selectedValue == 'เขตประเวศ') {
      transport = '220';
    } else if (selectedValue == 'เขตคลองเตย') {
      transport = '180';
    } else if (selectedValue == 'เขตสวนหลวง') {
      transport = '200';
    } else if (selectedValue == 'เขตจอมทอง') {
      transport = '120';
    } else if (selectedValue == 'เขตดอนเมือง') {
      transport = '250';
    } else if (selectedValue == 'เขตราชเทวี') {
      transport = '180';
    } else if (selectedValue == 'เขตลาดพร้าว') {
      transport = '220';
    } else if (selectedValue == 'เขตวัฒนา') {
      transport = '180';
    } else if (selectedValue == 'เขตบางแค') {
      transport = '100';
    } else if (selectedValue == 'เขตหลักสี่') {
      transport = '220';
    } else if (selectedValue == 'เขตสายไหม') {
      transport = '250';
    } else if (selectedValue == 'เขตคันนายาว') {
      transport = '240';
    } else if (selectedValue == 'เขตสะพานสูง') {
      transport = '240';
    } else if (selectedValue == 'เขตวังทองหลาง') {
      transport = '200';
    } else if (selectedValue == 'เขตคลองสามวา') {
      transport = '270';
    } else if (selectedValue == 'เขตบางนา') {
      transport = '200';
    } else if (selectedValue == 'เขตทวีวัฒนา') {
      transport = '120';
    } else if (selectedValue == 'เขตทุ่งครุ') {
      transport = '140';
    } else if (selectedValue == 'เขตบางบอน') {
      transport = '120';
    } else {
      transport = '350';
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
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'editAvatar$i.jpg';

    Map<String, dynamic> map = Map();
    map['file'] = await MultipartFile.fromFile(file!.path, filename: nameFile);
    FormData formData = FormData.fromMap(map);

    String urlUpload = '${MyConstant().domain}/champshop/saveUser.php';
    print('### $nameFile');

    await Dio().post(urlUpload, data: formData).then((value) async {
      urlPicture = '/champshop/Avatar/$nameFile';

      String? id = userModel!.id!;

      checkTransport();
      String sumAddress = '$address $district $selectedValue กทม. $zipcode';

      print('$sumAddress');
      print(
          '## name = $nameUser, address = $address $district $selectedValue $zipcode, transport = $transport, phone = $phone, avatar = $urlPicture');

      String url =
          '${MyConstant().domain}/champshop/editBuyerWhereId.php?isAdd=true&id=$id&Name=$nameUser&Address=$address&Phone=$phone&UrlPicture=$urlPicture&District=$district&County=$county&Zipcode=$zipcode&Transport=$transport&SumAddress=$sumAddress';

      Response response = await Dio().get(url);
      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ยังอัพเดทไม่ได้ กรุณาลองใหม่');
      }
    });
  }
}
