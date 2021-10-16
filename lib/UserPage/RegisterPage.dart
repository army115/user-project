import 'package:flutter/material.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/utility/my_dialog.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //เช็คการกรอกข้อมูล
  final _formkey = GlobalKey<FormState>();
  final _uuser = TextEditingController();
  final _upass = TextEditingController();
  final _uname = TextEditingController();
  final _ulastname = TextEditingController();
  final _utel = TextEditingController();
  final _uemail = TextEditingController();

//connect server api
  void _register(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/register';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Register Success');
      Navigator.pop(context, true);
      _showSnack();
      // normalDialog(context, 'สมัครสมาชิกเรียบร้อย', '');
    } else {
      print('Register not Success!!');
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar (title: Text('สมัครสมาชิก',
      // style: TextStyle(color: Colors.black)),
      // backgroundColor: Colors.amber,
      // ),
      body: Container(
        // width: double.infinity,
        color: Colors.amber,
        //ไล่ระดับสี
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(begin: Alignment.topCenter, colors: [
        //   Colors.orange[900]!,
        //   Colors.orange[800]!,
        //   Colors.orange[400]!
        // ])
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(30)),
            Center(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/images/Logo.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              username(),
                              SizedBox(height: 10),
                              password(),
                              SizedBox(height: 10),
                              uname(),
                              SizedBox(height: 10),
                              ulastname(),
                              SizedBox(height: 10),
                              phone(),
                              SizedBox(height: 10),
                              email(),
                              SizedBox(height: 40),
                            ],
                          ),
                           Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                btncancel(),
                                btnSubmit(),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget username() {
    return TextFormField(
      controller: _uuser,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'ชื่อผู้ใช้',
        hintText: 'กรอกชื่อผู้ใช้',
        prefixIcon: Icon(Icons.account_circle, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      },
    );
  }

  Widget password() {
    return TextFormField(
      controller: _upass,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'รหัสผ่าน',
        hintText: 'กรอกรหัสผ่าน อย่างน้อย 8 ตัว',
        prefixIcon: Icon(Icons.vpn_key, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกรหัสผ่าน';
        } else if (values.length < 8) {
          return "รหัสผ่านอย่างน้อย 8 ตัว";
        } else {
          return null;
        }
      },
    );
  }

  Widget uname() {
    return TextFormField(
      controller: _uname,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'ชื่อ',
        hintText: 'กรอกชื่อ',
        prefixIcon: Icon(Icons.person, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
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
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'นามสกุล',
        hintText: 'กรอกนามสกุล',
        prefixIcon: Icon(Icons.person_outline, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกนามสกุล';
      },
    );
  }

  Widget phone() {
    return TextFormField(
      maxLength: 10,
      controller: _utel,
      decoration: InputDecoration(
        counter: Offstage(),
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'เบอร์โทร',
        hintText: 'กรอกเบอร์โทร',
        prefixIcon: Icon(Icons.phone_iphone, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกเบอร์โทร';
        } else if (values.length < 10) {
          return "กรุณากรอกเบอร์โทรให้ครบ 10 ตัว";
        } else {
          return null;
        }
      },
    );
  }

  Widget email() {
    return TextFormField(
      controller: _uemail,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
        labelText: 'อีเมล',
        hintText: 'กรอกอีเมล',
        prefixIcon: Icon(Icons.email, size: 25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) {
          return 'กรุณากรอกอีเมล';
        } else if (values.isEmpty || !values.contains("@")) {
          return "รูปแบบอีเมลไม่ถูกต้อง";
        } else {
          return null;
        }
      },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 150,
      height: 45,
      child: RaisedButton(
        child: Text(
          'ยืนยัน',
          style: TextStyle(fontSize: 20),
        ),
        color: Colors.amber,
        onPressed: () {
          //ถ้ากรอกครบทุกช่องมันจะเข้า if
          if (_formkey.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            valuse['u_user'] = _uuser.text;
            valuse['u_pass'] = _upass.text;
            valuse['u_name'] = _uname.text;
            valuse['u_lastname'] = _ulastname.text;
            valuse['u_email'] = _uemail.text;
            valuse['u_tel'] = _utel.text;

            print(_uuser.text);
            print(_upass.text);
            print(_uname.text);
            print(_ulastname.text);
            print(_uemail.text);
            print(_utel.text);

            _register(valuse);
            // Navigator.pushNamed(context, '/');
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
    );
  }

  Widget btncancel() {
    return SizedBox(
      width: 150,
      height: 45,
      child: RaisedButton(
        child: Text(
          'ยกเลิก',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          Navigator.pop(context, '/');
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
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
                child: Text('สมัครสมาชิกเรียบร้อย'),
              ),
            ],
          ),
          duration: const Duration(milliseconds: 1500),
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
