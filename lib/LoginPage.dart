import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_project_app/BottomBar.dart';
import 'package:flutter_project_app/UserPage/HomePage.dart';
import 'package:flutter_project_app/model/Login.dart';
import 'package:flutter_project_app/utility/my_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool redEye = true;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Login login = Login();

  Future doLogin() async {
    if (_formkey.currentState.validate()) {
      try {
        var rs = await login.doLogin(_username.text, _password.text);
        if (rs.statusCode == 200) {
          print(rs.body);
          var jsonRes = json.decode(rs.body);
          if (jsonRes['ok']) {
            String token = jsonRes['token'];
            var uId = jsonRes['id'];
            print(token);
            print(uId);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token);
            await prefs.setInt('id', uId);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => BottomBar()));
              _showSnack();
          } else {
            print(jsonRes['error']);
            normalDialog(context, 'ชื่อผู้ใช้หรือ\nรหัสผ่านไม่ถูกต้อง','โปรดลองอีกครั้ง'); 
          }
        } else {
          print('Connection Fail');
        }
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      body: Stack(fit: StackFit.expand, children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  color: Theme.of(context).primaryColor,
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 10,
                ),
              ), 
              Spacer()
            ],
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.only(top: 30, left: 10, right: 10),
          child: SafeArea(
            child: Form(
              key: _formkey,
              child: Column(children: [
                Container(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage('assets/images/Logo.png'),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'แอปพลิเคชันบริการรับฝากส่งพัสดุ',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Card(
                          margin: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.amberAccent[400],
                          elevation: 10,
                          child: Column(children: [
                            SizedBox(height: 10),
                            username(),
                            SizedBox(height: 10),
                            password(),
                            SizedBox(height: 20),
                            btnSubmit(),
                            // btnForgotPass(),
                            // Container(
                            //   width: 290,
                            //   child: Divider(
                            //     color: Colors.grey[600],
                            //   ),
                            // ),
                            SizedBox(height: 20),
                            btnRegister(),
                            SizedBox(height: 15),
                          ])),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget username() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white60, borderRadius: BorderRadius.circular(10.0)),
      width: 300,
      child: TextFormField(
        // cursorColor: Colors.amber,
        controller: _username,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          labelText: 'ชื่อผู้ใช้',
          hintText: 'กรอกชื่อผู้ใช้',
          prefixIcon: Icon(Icons.person,
              //prefixIcon ใส่กรอบครอบไอคอน
              size: 25,),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
        ),
        validator: (values) {
          if (values == null || values.isEmpty) {
            return 'กรุณากรอกชื่อผู้ใช้';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget password() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white60, borderRadius: BorderRadius.circular(10.0)),
      // margin: EdgeInsets.only(top: 16),
      width: 300,
      child: TextFormField(
        // cursorColor: Colors.amber,
        controller: _password,
        obscureText: redEye,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          labelText: 'รหัสผ่าน',
          hintText: 'กรอกรหัสผ่าน',
          prefixIcon: Icon(
            Icons.lock,
            //prefixIcon ใส่กรอบครอบไอคอน
            size: 25,
          ),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                redEye = !redEye;
              });
            },
            icon: redEye
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
          if (values == null || values.isEmpty) {
            return 'กรุณากรอกรหัสผ่าน';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 280,
      height: 45,
      child: RaisedButton(
        child: Text('เข้าสู่ระบบ',
            style: TextStyle(
              fontSize: 20,fontWeight: FontWeight.bold
            )),
        color: Theme.of(context).primaryColor,
        onPressed: () {
          doLogin();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
    );
  }

  Widget btnRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('หากไม่มีบัญชีผู้ใช้?',
            style: TextStyle(
              fontSize: 16,color: Colors.black
            )),
        TextButton(
            child: Text('สมัครสมาชิก',
                style: TextStyle(
                  fontSize: 16,color: Colors.black,
                  fontWeight: FontWeight.bold
                )),
            // color: Colors.cyan,
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            })
      ],
    );
  }

  Widget btnForgotPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            child: Text('ลืมรหัสผ่าน?',
                style: TextStyle(
                  fontSize: 15,
                )),
            //color: Colors.cyan,
            onPressed: () {
              Navigator.pushNamed(context, '');
            }),
      ],
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
                child: Text('เข้าสู่ระบบสำเร็จ'),
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