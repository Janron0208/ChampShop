import 'dart:io';
import 'dart:math';

import 'package:champshop/utility/my_style.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/custom_dropdown_button2.dart';
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
  String? name, user, password, address, phone, urlpicture;
  String? district, county, zipcode, transport, sumAddress;
  String avatar = '';
  File? file;

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
                    Divider(),
                    MyStyle().mySizebox0(),
                    nameForm(),
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
    } 
 
    else {
      transport = '350';
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
            print('$address $district $selectedValue กทม. $zipcode ค่าส่ง $transport บาท');
            print(
                '## name = $name, address = $address $district $selectedValue $zipcode, transport = $transport, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');
            if (name == null ||
                name!.isEmpty ||
                user == null ||
                user!.isEmpty ||
                password == null ||
                password!.isEmpty ||
                address == null ||
                address!.isEmpty ||
                phone == null ||
                phone!.isEmpty) {
              print('Have Space');
              normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
            } else {
              if (chooseType == null) {
                normalDialog(context, 'โปรด เลือกชนิดของผู้สมัคร');
              } else {
                // uploadpictureThread();
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
        '## name = $name, address = $address, phone = $phone, user = $user, password = $password, type = $chooseType, avatar = $avatar');
    // print('### process Upload Avatar ==> $avatar');
    registerThread();
  }

  Future<Null> checkUser() async {
    String url =
        '${MyConstant().domain}/champshop/getUserWhereUser.php?isAdd=true&User=$user';
    try {
      Response response = await Dio().get(url);
      if (response.toString() == 'null') {
        uploadpictureThread();
        // registerThread();
      } else {
        normalDialog(
            context, 'User นี่ $user มีคนอื่นใช้ไปแล้ว กรุณาเปลี่ยน User ใหม่');
      }
    } catch (e) {}
  }

  Future<Null> registerThread() async {

      String sumAddress = '$address $district $selectedValue กทม. $zipcode';

    String url =
        '${MyConstant().domain}/champshop/addUser.php?isAdd=true&Name=$name&User=$user&Password=$password&ChooseType=$chooseType&Address=$address&Phone=$phone&UrlPicture=$avatar&District=$district&County=$selectedValue&Zipcode=$zipcode&Transport=$transport&SumAddress=$sumAddress';

    try {
      Response response = await Dio().get(url);
      print('res = $response');

      if (response.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(context, 'ไม่สามารถ สมัครได้ กรุณาลองใหม่ คะ');
      }
    } catch (e) {}
  }

  Widget nameForm() => Container(
        width: 300.0,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            prefixIcon:
                Icon(Icons.person, color: Color.fromARGB(255, 255, 181, 146)),
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
}
