import 'package:flutter/material.dart';
import 'package:flutter_project_app/Widgets/Show_progress.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/OrderImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

class PaymentDetail extends StatefulWidget {
  const PaymentDetail({Key key}) : super(key: key);

  @override
  _PaymentDetailState createState() => _PaymentDetailState();
}

class _PaymentDetailState extends State<PaymentDetail> {
  var _sTATUS0 = 'ยังไม่ชำระเงิน';

  var _orId;
  var _checkId;
  var _sentId;
  var _sentDate;
  var _sentTime;
  var _sentSale;
  var _sentNum;
  var _orAddress;
  var _orstatus;

  var service;
  var total;

  Getorderimage _orImg;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  Map<String, dynamic> _rec_order;
  var token;
  // var or_id;

  // CameraPosition position;
  double _orlat, _orlng;
  bool load = true;

  Future getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;

    _orId = _rec_order['or_id'];
    _checkId = _rec_order['check_id'];
    _sentId = _rec_order['sent_id'];
    _sentDate = _rec_order['sent_date'];
    _sentTime = _rec_order['sent_time'];
    _sentSale = _rec_order['sent_sale'];
    _sentNum = _rec_order['sent_num'];
    _orAddress = _rec_order['or_address'];
    _orstatus = _rec_order['or_status'];

    service = _sentNum * 1.50;
    total = _sentSale + service;
    print(service);
    print(total);
  }

  Future<void> _getOrImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/getorderimage/$_orId';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียด',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[300],
      body: load ? ShowProgress() : buildCenter(),
    );
  }

  Center buildCenter() {
    DateTime checkDate = DateTime.parse(_sentDate);
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
                // color: Colors.grey[200],
                child: Container(
                  // alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 400,
                            height: 200,
                            child: _checkImage(_orImg.orImg),
                          ),
                          Container(
                              // alignment: Alignment.topLeft,
                              child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text('วันที่นำส่ง',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600])),
                                        Text('${formatter.format(checkDate)}',
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
                                        Text('เวลาที่นำส่ง',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600])),
                                        Text('${_sentTime}',
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
                                        Text('จำนวนที่ส่ง',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600])),
                                        Text('${_sentNum} กล่อง',
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
                            ],
                          )),
                          // elevation: 10,
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ค่าบริการรับฝากส่งพัสดุ : ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('${service} บาท',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black87,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ราคารวมค่าจัดส่งพัสดุ : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('${_sentSale} บาท',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black87,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ราคารวมสุทธิ : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('${total} บาท',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black87,
                                        ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('สถานะ : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    _status(context, _orstatus)
                                  ],
                                ),
                              ],
                            ),
                          )
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
                  // width: 500,
                  height: 450,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ธนาคารที่ให้บริการ',
                        style: TextStyle(fontSize: 22),
                      ),
                      Flexible(
                        // << Grid Dashboard
                        child: GridView.count(
                          // scrollDirection: Axis.vertical,
                          // shrinkWrap: true,
                          childAspectRatio: 1.0,
                          padding: EdgeInsets.all(10),
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          primary: true,
                          children: [
                            GridMenu(
                              press: () {
                                Navigator.pushNamed(context, '/thaibank',
                                    arguments: {
                                      'or_id': _orId,
                                      'total': total,
                                    });
                              },
                              img: 'assets/images/thai.png',
                              // icon: Icons.ac_unit_outlined,
                              title: "ธนาคารกรุงไทย",
                              // subtitle: "subtitle",
                            ),
                            GridMenu(
                              press: () {
                                Navigator.pushNamed(context, '/scbbank',
                                    arguments: {
                                      'or_id': _orId,
                                      'total': total,
                                    });
                              },
                              img: 'assets/images/SCB.png',
                              // icon: Icons.ac_unit_outlined,
                              title: "ธนาคารไทยพาณิช",
                              // subtitle: "subtitle",
                            ),
                            GridMenu(
                              press: () {
                                Navigator.pushNamed(context, '/kskbank',
                                    arguments: {
                                      'or_id': _orId,
                                      'total': total,
                                    });
                              },
                              img: 'assets/images/KSK.png',
                              // icon: Icons.ac_unit_outlined,
                              title: "ธนาคารกสิกรไทย",
                              // subtitle: "subtitle",
                            ),
                            GridMenu(
                              press: () {
                                Navigator.pushNamed(context, '/bkkbank',
                                    arguments: {
                                      'or_id': _orId,
                                      'total': total,
                                    });
                              },
                              img: 'assets/images/BKK.png',
                              // icon: Icons.ac_unit_outlined,
                              title: "ธนาคารกรุงเทพ",
                              // subtitle: "subtitle",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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
                child: Text('ยกเลิกรายการส่งสำเร็จ'),
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
    if (orStatus != '3') {
      child = Text(_sTATUS0, style: TextStyle(fontSize: 16, color: Colors.red));
    } else {}
    return new Container(child: child);
  }
} //class

//  Grid Menu Dashboard
class GridMenu extends StatelessWidget {
  const GridMenu({
    Key key,
    @required this.press,
    @required this.img,
    // @required this.icon,
    @required this.title,
    // @required this.subtitle,
  }) : super(key: key);

  final VoidCallback press;
  final String img;
  // final icon;
  final String title;
  // final String subtitle;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: press,
      child: Card(
        elevation: 5,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              img,
              width: 80,
            ),
            // Icon(icon),
            SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
