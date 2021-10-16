import 'package:flutter/material.dart';
import 'package:flutter_project_app/Widgets/Show_progress.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/User.dart';
import 'package:flutter_project_app/model/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
//String uId;
  Userinfo udata;
  bool load = true; 
 
//connect server api
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

  Future onGoBack(dynamic value) {
    setState(() {
      _getProfile();
    });
  }

  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    // Call _getProfile
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('โปรไฟล์', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
           Navigator.pop(context,);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/update', arguments: {
                  'u_id': udata.uId,
                  'u_name': udata.uName,
                  'u_lastname': udata.uLastname,
                  'u_tel': udata.uTel,
                  'u_email': udata.uEmail
                }).then((onGoBack));
              }),
        ],
      ),
      // backgroundColor: Colors.amber,
      body: load ? ShowProgress() : buildCenter(),
      backgroundColor: Colors.grey[300],
    );
  }

  Center buildCenter() {
    return Center(
        child: Container(
              child: Column(
                children: [ 
                   ProfileHeader(
                avatar: AssetImage('assets/images/user.png'),
                coverImage: AssetImage('assets/images/background.png'),
              ),
                  UserInfo()
                ],
              ),
        ),
    );
  }

  Widget UserInfo () {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Card(
            child: Container(
              // alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Column(
                    children:[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          ListTile(
                            leading: Icon(Icons.person,size: 30,),
                            title: Text('ชื่อ',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                            subtitle: Text('${udata.uName}',
                            style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(Icons.person_outline,size: 30,),
                            title: Text('สกุล',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                            subtitle: Text('${udata.uLastname}',
                            style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(Icons.phone,size: 30,),
                            title: Text('เบอร์',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                            subtitle: Text('${udata.uTel}',
                            style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                          ListTile(
                            leading: Icon(Icons.email,size: 30,),
                            title: Text('อีเมล',
                    style: TextStyle(fontSize: 15,color: Colors.blue)),
                    subtitle: Text('${udata.uEmail}',
                    style: TextStyle(fontSize: 19,color: Colors.black87)),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            elevation: 10,
          )
        ],
      ),
    );
  }
}//class