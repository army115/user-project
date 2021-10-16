import 'package:flutter/material.dart';
import 'package:flutter_project_app/LoginPage.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/User.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Userinfo udata;
  bool load = true;

  Future<void> _getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var uId = prefs.getInt('id');
    print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/getprofile/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      User members = User.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        udata = members.userinfo;
        load = false;
      });
    }
  }

    @override
  void initState() {
    //TODO: implement initState
    super.initState();
    // Call _getProfile
    _getProfile();
  }

  @override
  Future _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
    _showSnack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนู', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Column(
                children: [
                  btnprofile(),
                  SizedBox(
                    height: 10,
                  ),
                  // btnorder (),
                  // SizedBox(height: 10,),
                  btnpassword(),
                  SizedBox(
                    height: 10,
                  ),
                  btnlogout()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnprofile() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'โปรไฟล์',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.amber,
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  Widget btnorder() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'ประวัติรายการส่ง',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.amber,
        onPressed: () {
          Navigator.pushNamed(context, '/history');
        },
      ),
    );
  }

  Widget btnpassword() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vpn_key,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'รหัสผ่าน',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.arrow_forward_ios)
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.amber,
        onPressed: () {
          Navigator.pushNamed(context, '/password', arguments: {
            'u_id': udata.uId,
            'u_pass': udata.uPass,
          });
        },
      ),
    );
  }

  Widget btnlogout() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 30,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(fontSize: 18),
              ),
            ),
            // Icon(Icons.arrow_forward_ios)
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.amber,
        onPressed: () {
          return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          size: 30,
                          color: Colors.red,
                        ),
                        Expanded(
                          child: Text('ต้องการออกจากระบบ'),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'ไม่ใช่',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: Text(
                          'ใช่',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () {
                          _logOut();
                        },
                      ),
                    ],
                  ));
        },
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
              Icon(
                Icons.check,
                color: Colors.white,
                size: 30.0,
              ),
              Expanded(
                child: Text('ออกจากระบบสำเร็จ'),
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
