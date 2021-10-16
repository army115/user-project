import 'package:flutter/material.dart';
import 'package:flutter_project_app/Widgets/Show_progress.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/OrderImage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class OrderSent extends StatefulWidget {
  const OrderSent({Key key}) : super(key: key);

  @override
  _OrderSentState createState() => _OrderSentState();
}

class _OrderSentState extends State<OrderSent> {
  final _formkey = GlobalKey<FormState>();
  var _sTATUS2 = 'ส่งพัสดุให้บริษัทขนส่งแล้ว';

  var orid;
  var _ordate;
  var _ortime;
  var _ornum;
  var _orstatus;
  var _oraddress;
  var _oroffice;
  var _ordetail;
  var _sentnum;
  var _sentdate;
  var _senttime;
  
  Getorderimage _orImg;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  Map<String, dynamic> _rec_order;
  var token;
  // var or_id;

  // CameraPosition position;
  Position userLocation;
  Set<Marker> _markers = {};
  double _orlat, _orlng;
  bool load = true;
  GoogleMapController mapController;

  Future getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;
    orid = _rec_order['or_id'];
    _ordate = _rec_order['or_date'];
    _ortime = _rec_order['or_time'];
    _ornum = _rec_order['or_num'];
    _orstatus = _rec_order['or_status'];
    _oraddress = _rec_order['or_address'];
    _oroffice = _rec_order['or_office'];
    _ordetail = _rec_order['or_detail'];
    _orlat = _rec_order['or_lat'];
    _orlng = _rec_order['or_lng'];
    _sentnum = _rec_order['sent_num'];
    _sentdate = _rec_order['sent_date'];
    _senttime = _rec_order['sent_time'];
  }

    Future getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // psId = prefs.getInt('psid');
    print('token = $token');
    print('orid = $orid');
  }

  //Delete
  Future<void> _cancelorder(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/deleteperson/$orid';
    var response = await http.delete(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Delete Success!');
    } else {
      print('Delete Fail!!');
    }
  }

  Future<void> _getOrImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/getorderimage/$orid';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      OrderImage images =
          OrderImage.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        _orImg = images.getorderimage;
        load = false;
      });
    }
  }

  Future<Null> findLatLan() async {
    Position position = await findPosition();
    setState(() {
      _orlat = position.latitude;
      _orlng = position.longitude;
      load = false;
    });
    print('lat = $_orlat, lng = $_orlng, load = $load');
  }

  Future<Position> findPosition() async {
    try {
      userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      userLocation = null;
    }
    return userLocation;
  }

  void _onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(Utils.mapStyle);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('id'),
          position: LatLng(_orlat, _orlng),
        ),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getOrImage();
    // findLatLan();
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    getPrefs();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แสดงออเดอร์',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[300],
      body: load ? ShowProgress() : buildCenter(),
    );
  }

  Center buildCenter() {
    DateTime orDate = DateTime.parse(_ordate);
    DateTime checkDate = DateTime.parse(_sentdate);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: 400,
                    height: 200,
                    child: _checkImage(_orImg.orImg),
                  ),
                ),
                Card(
                   shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    // alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text('วันที่แจ้งส่ง',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${formatter.format(orDate)}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87))
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    endIndent: 5,
                                    indent: 5,
                                    thickness: 1,
                                  ),
                                  Column(
                                    children: [
                                      Text('เวลาที่แจ้งส่ง',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${_ortime}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              endIndent: 10,
                              indent: 10,
                              height: 20,
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                Text('ที่อยู่ที่แจ้งเข้ารับ',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[600])),
                                Text('${_oraddress}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ))
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              endIndent: 10,
                              indent: 10,
                              height: 20,
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text('จำนวนที่แจ้งส่ง',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${_ornum} กล่อง',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87))
                                    ],
                                  ),
                                  VerticalDivider(
                                    color: Colors.grey,
                                    endIndent: 5,
                                    indent: 5,
                                    thickness: 1,
                                  ),
                                  Column(
                                    children: [
                                      Text('บริษัทขนส่งที่เลือก',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[600])),
                                      Text('${_oroffice}',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              endIndent: 10,
                              indent: 10,
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('รายละเอียดเพิ่มเติม : ',
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[600])),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('${_ordetail}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black87,
                                    ))
                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('สถานะ : ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[600])),
                                SizedBox(
                                  width: 10,
                                ),
                                _status(context, _orstatus)
                              ],
                            ),
                            // Divider(
                            //   color: Colors.grey,
                            //   thickness: 1,
                            //   endIndent: 10,
                            //   indent: 10,
                            //   height: 20,
                            // ),
                          ],
                        )
                      ],
                    ),
                  ),
                  elevation: 10,
                ),
                Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                    // alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('วันที่นำส่ง',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  Text('${formatter.format(checkDate)}',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black87))
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                endIndent: 5,
                                indent: 5,
                                thickness: 1,
                              ),
                              Column(
                                children: [
                                  Text('เวลาที่นำส่ง',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  Text('${_senttime}',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black87))
                                ],
                              ),
                              VerticalDivider(
                                color: Colors.grey,
                                endIndent: 5,
                                indent: 5,
                                thickness: 1,
                              ),
                              Column(
                                children: [
                                  Text('จำนวนที่ส่ง',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  Text('${_sentnum} กล่อง',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.black87))
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey,
                          thickness: 1,
                          endIndent: 10,
                          indent: 10,
                          height: 20,
                        ),
                      ],
                    )),
                // elevation: 10,
              ),
              ],
            ),
        ),
      ),
    );
  }


  Widget _checkImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null
        // || imageName == ''
        ) {
      child = Image.network('${Connectapi().orImageDomain}$imageName');
    } else {
      child = Image.asset('assets/images/noimg.png');
    }
    return new Container(child: child);
  }

  Widget _status(BuildContext context, orStatus) {
    Widget child;
    if (orStatus != '2') {
      child =
          Text(_sTATUS2, style: TextStyle(fontSize: 16, color: Colors.green));
    } else {
    }
    return new Container(child: child);
  }
} //class