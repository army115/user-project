import 'package:flutter/material.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formkey = GlobalKey<FormState>();

  //  TextEditingController _uuser;
  //  TextEditingController _upass;
  TextEditingController _uname;
  TextEditingController _ulastname;
  TextEditingController _utel;
  TextEditingController _uemail;

  Map<String, dynamic> rec_user;
  // var u_id;
  var token;
  var uId;

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('token = $token');
    print('uId = $uId');
  }

  //connect server api
  Future<void> _update(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/update/$uId';
    print(uId);
    var response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Accept Success!');
      Navigator.pop(context, true);
      _showSnack();
    } else {
      print('Accept Fail!!');
    }
  }

  Future getInfo() async {
    rec_user = ModalRoute.of(context).settings.arguments;

    uId = rec_user['id'];
    // _uuser = TextEditingController (text: rec_user['u_user']);
    // _upass = TextEditingController (text: rec_user['u_pass']);
    _uname = TextEditingController(text: rec_user['u_name']);
    _ulastname = TextEditingController(text: rec_user['u_lastname']);
    _utel = TextEditingController(text: rec_user['u_tel']);
    _uemail = TextEditingController(text: rec_user['u_email']);
  }

  @override
  Widget build(BuildContext context) {
    getPrefs();
    getInfo();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('แก้ไขโปรไฟล์', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    // username(),
                    // SizedBox(height: 10),
                    uname(),
                    SizedBox(height: 10),
                    ulastname(),
                    SizedBox(height: 10),
                    phone(),
                    SizedBox(height: 10),
                    email(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  btncancel(),
                  btnSubmit(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Widget username(){
  //   return TextFormField(
  //      controller: _uuser,
  //     decoration: InputDecoration(
  //         contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
  //           labelText: 'ชื่อผู้ใช้',
  //           hintText: 'กรอกชื่อผู้ใช้',
  //           icon: Icon(Icons.account_circle,
  //           size: 25),
  //           border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(5.0),
  //           ),
  //     ),
  //     validator: (values){
  //       if (values.isEmpty)
  //       return 'กรุณากรอกชื่อผู้ใช';
  //     },
  //   );
  // }

  // Widget password(){
  //   return TextFormField(
  //     controller: _upass,
  //     decoration: InputDecoration(
  //         contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
  //           labelText: 'รหัสผ่าน',
  //           hintText: 'กรอกรหัสผ่าน',
  //           icon: Icon(Icons.vpn_key,
  //           size: 25),
  //           border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(5.0),
  //           ),
  //     ),
  //     validator: (values){
  //       if (values.isEmpty)
  //       return 'กรุณากรอกรหัสผ่าน';
  //     },
  //   );
  // }

  Widget uname() {
    return TextFormField(
      controller: _uname,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'ชื่อ',
        hintText: 'กรอกชื่อ',
        icon: Icon(Icons.person, size: 25),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกชื่อ';
      },
    );
  }

  Widget ulastname() {
    return TextFormField(
      controller: _ulastname,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'นามสกุล',
        hintText: 'กรอกนามสกุล',
        icon: Icon(Icons.person, size: 25),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกนามสกุล';
      },
    );
  }

  Widget phone() {
    return TextFormField(
      controller: _utel,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'เบอร์โทร',
        hintText: 'กรอกเบอร์โทร',
        icon: Icon(Icons.phone_iphone, size: 25),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกเบอร์';
      },
    );
  }

  Widget email() {
    return TextFormField(
      controller: _uemail,
      decoration: InputDecoration(
        // contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
        labelText: 'อีเมล',
        hintText: 'กรอกอีเมล',
        icon: Icon(Icons.email, size: 25),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(5.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกอีเมล';
      },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 140,
      height: 38,
      child: RaisedButton(
        child: Text('ยืนยัน',
            style: TextStyle(
              fontSize: 18,
            )),
        color: Colors.amber,
        onPressed: () {
          //ถ้ากรอกครบทุกช่องมันจะเข้า if

          Map<String, dynamic> valuse = Map();
          valuse['u_id'] = uId;
          // valuse['u_user'] = _uuser.text;
          // valuse['u_pass'] = _upass.text;
          valuse['u_name'] = _uname.text;
          valuse['u_lastname'] = _ulastname.text;
          valuse['u_email'] = _uemail.text;
          valuse['u_tel'] = _utel.text;

          print(uId);
          // print(_uuser.text);
          print(_uname.text);
          // print(_upass.text);
          print(_ulastname.text);
          print(_uemail.text);
          print(_utel.text);

          print(valuse);
          _update(valuse);
          // Navigator.pop(context, '/profile');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
      ),
    );
  }

  Widget btncancel() {
    return SizedBox(
      width: 140,
      height: 38,
      child: RaisedButton(
        child: Text('ยกเลิก',
            style: TextStyle(
              fontSize: 18,
            )),
        onPressed: () {
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

   void _showSnack() => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          // action: SnackBarAction(
          //   label: 'Action',
          //   onPressed: () {
          //     // Code to execute.
          //   },
          // ),
          content: Row(
            children: [
              Icon(Icons.check,
              color: Colors.white,
              size: 30.0,),
              Expanded(
                child: Text('แก้ไขข้อมูลสำเร็จ'),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1700),
          width: 350, // Width of the SnackBar.
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0, // Inner padding for SnackBar content.
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      );
}//class
