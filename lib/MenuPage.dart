import 'package:flutter/material.dart';
import 'package:flutter_project_app/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  
  
  @override
  Future _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil
    (MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
    (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                image: ExactAssetImage('assets/images/Bg123.jpg'),
                  fit:BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/itrmu.jpg'),
                  ),
                ],
              ),
              ),

              ListTile(
              leading: Icon(Icons.person,
              color: Colors.black,),
            title: Text('โปรไฟล์'),
            // subtitle: Text('ประวัติส่วนตัว'),
            onTap: (){
              Navigator.pushNamed(context, '/profile');
            },
            ),

            ListTile(
              leading: Icon(Icons.receipt_outlined,
              color: Colors.black),
            title: Text('รายการ'),
            onTap: (){
              Navigator.pushNamed(context, '/order');
            },
            ),

            ListTile(
              leading: Icon(Icons.location_on,
              color: Colors.black),
            title: Text('ที่อยู่'),
            onTap: (){
              Navigator.pushNamed(context, '/address');
            },
            ),

            ListTile(
              leading: Icon(Icons.vpn_key,
              color: Colors.black),
            title: Text('รหัสผ่าน'),
            onTap: (){
              
            },
            ),

            ListTile(
              leading: Icon(Icons.library_add_check_rounded ,
              color: Colors.black),
            title: Text('สถานะพัสดุ'),
            onTap: (){
              
            },
            ),

            ListTile(
              leading: Icon(Icons.keyboard_backspace_rounded,
              color: Colors.black),
            title: Text('ออกจากระบบ'),
            onTap: (){
              _logOut();
            },
            ),
          ],
      ),
    );
  }
}