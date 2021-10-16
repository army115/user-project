import 'package:flutter/material.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  Password({Key key}) : super(key: key);

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final _formkey = GlobalKey<FormState>();
  final _oldpass = TextEditingController();
  final _newpass = TextEditingController();
  final _conpass = TextEditingController();
  // TextEditingController uPass;
  bool redEyeold = true;
  bool redEyenew = true;
  bool redEyecon = true;
  var confirmPass;

  Map<String, dynamic> rec_user;
  // var u_id;
  var token;
  var uId;
  var uPass;

  Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('token = $token');
    print('uId = $uId');
  }

  Future<void> _update(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/updatepass/$uId';
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
      // Navigator.pop(context, true);
      _showSnack();
    } else {
      print('Accept Fail!!');
    }
  }

  Future getInfo() async {
    rec_user = ModalRoute.of(context).settings.arguments;
    uId = rec_user['u_id'];
    uPass = rec_user['u_pass'];
    print('ไอดี $uId');
    print('รหัส $uPass');
  }

  @override
  Widget build(BuildContext context) {
    getPrefs();
    getInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text('เปลี่ยนรหัสผ่าน'),
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
                    oldpass(),
                    SizedBox(height: 10),
                    newpass(),
                    SizedBox(height: 10),
                    conpass(),
                    SizedBox(height: 40),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  btnSubmit(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget oldpass() {
    return TextFormField(
      controller: _oldpass,
      obscureText: redEyeold,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        labelText: 'รหัสผ่านปัจจุบัน',
        // hintText: 'กรอกชื่อ',
        // icon: Icon(Icons.person, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              redEyeold = !redEyeold;
            });
          },
          icon: redEyeold
              ? Icon(
                  Icons.visibility,
                  // color: MyConstant.dark,
                )
              : Icon(
                  Icons.visibility_off,
                  // color: MyConstant.dark,
                ),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรอกรหัสผ่านปัจจุบัน';
        } else if (values != uPass) {
          return "รหัสผ่านปัจจุบันไม่ถูกต้อง";
        } else {
          return null;
        }
      },
    );
  }

  Widget newpass() {
    return TextFormField(
      controller: _newpass,
      obscureText: redEyenew,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        labelText: 'รหัสผ่านใหม่',
        // hintText: 'กรอกนามสกุล',
        // icon: Icon(Icons.person, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              redEyenew = !redEyenew;
            });
          },
          icon: redEyenew
              ? Icon(
                  Icons.visibility,
                  // color: MyConstant.dark,
                )
              : Icon(
                  Icons.visibility_off,
                  // color: MyConstant.dark,
                ),
        ),
      ),
      validator: (values) {
        confirmPass = values;
        if (values.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        } else if (values == uPass) {
          return "ซ้ำกับรหัสผ่านปัจจุบัน กรุณากรอกรหัสผ่านใหม่";
        } else if (values.length < 8) {
          return "รหัสผ่านอย่างน้อย 8 ตัว";
        } else {
          return null;
        }
      },
    );
  }

  Widget conpass() {
    return TextFormField(
      controller: _conpass,
      obscureText: redEyecon,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        labelText: 'ยืนยันรหัสผ่าน',
        // hintText: 'กรอกเบอร์โทร',
        // icon: Icon(Icons.phone_iphone, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              redEyecon = !redEyecon;
            });
          },
          icon: redEyecon
              ? Icon(
                  Icons.visibility,
                  // color: MyConstant.dark,
                )
              : Icon(
                  Icons.visibility_off,
                  // color: MyConstant.dark,
                ),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        } else if (values != confirmPass) {
          return "รหัสผ่านไม่ตรงกัน";
        } else {
          return null;
        }
      },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 150,
      height: 38,
      child: RaisedButton(
        child: Text('เปลี่ยนรหัสผ่าน',
            style: TextStyle(
              fontSize: 18,
            )),
        color: Colors.amber,
        onPressed: () {
          //ถ้ากรอกครบทุกช่องมันจะเข้า if
          if (_formkey.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            valuse['u_id'] = uId;
            valuse['u_pass'] = _conpass.text;

            print(valuse);
            _update(valuse);
            Navigator.pop(context, '/homepage');
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
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
                child: Text('เปลี่ยนรหัสผ่านสำเร็จ'),
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
}
