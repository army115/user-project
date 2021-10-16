import 'package:flutter/material.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/OrderImage.dart';
import 'package:flutter_project_app/model/PaymentImages.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_project_app/Widgets/Show_progress.dart';

class CheckPayment extends StatefulWidget {
  CheckPayment({Key key}) : super(key: key);

  @override
  _CheckPaymentState createState() => _CheckPaymentState();
}

class _CheckPaymentState extends State<CheckPayment> {
  var _sTATUS0 = 'ชำระเงินแล้ว';

  var _orId;
  var _payDate;
  var _payTime;
  var _paySale;
  var _payBank;
  var _orAddress;
  var _orstatus;

  Getorderimage _orImg;
  Getpayimage _payImg;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  Map<String, dynamic> _rec_order;
  var token;
  // var or_id;
  bool load = true;

  Future getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;

    _orId = _rec_order['or_id'];
    _payDate = _rec_order['pay_date'];
    _payTime = _rec_order['pay_time'];
    _paySale = _rec_order['pay_sale'];
    _payBank = _rec_order['pay_bank'];
    _orAddress = _rec_order['or_address'];
    _orstatus = _rec_order['or_status'];
  }

  Future<void> _getpayImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // var uId = prefs.getInt('id');
    // print('uId = $uId');
    // print('token = $token');
    var url = '${Connectapi().domain}/getorderimagePm/$_orId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    //check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Paymentimage images =
          Paymentimage.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        _payImg = images.getpayimage;
        load = false;
      });
    }
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
    _getpayImage();
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
    DateTime orDate = DateTime.parse(_payDate);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                // color: Colors.grey[200],
                child: Container(
                  // alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            // width: 400,
                            height: 480,
                            child: _payImage(_payImg.payImg),
                          ),
                          Container(
                              // alignment: Alignment.topLeft,
                              child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Text('วันที่ชำระเงิน',
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
                                        Text('เวลาที่ชำระเงิน',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey[600])),
                                        Text('${_payTime}',
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
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ยอดที่ชำระ : ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('${_paySale} บาท',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black87,
                                        ))
                                  ],
                                ),
                                // SizedBox(heiht: 10,),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ธนาคารที่ชำระ : ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[600])),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('${_payBank}',
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
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('รอพนักงานตรวจสอบการชำระเงิน ',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.red)),
                          SizedBox(
                            height: 5,
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
        ),
      ),
    );
  }

  Widget btntrack() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: RaisedButton(
        child: Text('ตรวจเลขพัสดุ', style: TextStyle(fontSize: 20)),
        color: Colors.amber,
        onPressed: () {
          Navigator.pushNamed(context, '/track', arguments: {
            'or_id': _orId,
          });
        },
      ),
    );
  }

  Widget _payImage(imageName) {
    Widget child;
    print('Imagename : $imageName');
    if (imageName != null
        // || imageName == ''
        ) {
      child = Image.network('${Connectapi().payImagesDomain}$imageName');
    } else {
      child = Image.asset('assets/images/noimg.png');
    }
    return new Container(child: child);
  }

  Widget _status(BuildContext context, orStatus) {
    Widget child;
    if (orStatus != '4') {
      child =
          Text(_sTATUS0, style: TextStyle(fontSize: 16, color: Colors.green));
    } else {}
    return new Container(child: child);
  }
}
