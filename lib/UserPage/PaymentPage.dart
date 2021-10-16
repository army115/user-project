import 'package:flutter/material.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/Nonpay.dart';
import 'package:flutter_project_app/model/OrderImage.dart';
import 'package:flutter_project_app/model/Payment.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<Nonuser> nonpay = [];
  List<Pay> payment = [];

  var uId;
  var token;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');
  
  var _sTATUS1 = 'ยังไม่ชำระเงิน';
  var _sTATUS2 = 'ชำระเงินแล้ว';

  //Payment (รายการที่ต้องชำระเงิน )
  Future<void> _ShowNonpayuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/ShowNonpayuser/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Nonpay members = Nonpay.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        nonpay = members.nonuser;
        // load = false;
      });
    }
  }

  //CheckPayment (รายการชำระเงินแล้ว )
  Future<void> _ShowPayment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/Paymentuser/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      Payment members = Payment.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        payment = members.pay;
        // load = false;
      });
    }
  }

  Future onGoBack(dynamic value) {
    setState(() {
      _ShowNonpayuser();
      _ShowPayment();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _ShowNonpayuser();
    _ShowPayment();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              title: Text(
                'ชำระเงิน',
                style: TextStyle(color: Colors.black),
              ),
              bottom: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 18.0,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.0,
                ),
                tabs: [
                  Tab(
                    text: 'ยังไม่ชำระเงิน',
                  ),
                  Tab(
                    text: 'ชำระเงินแล้ว',
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.grey[300],
            body: TabBarView(
              children: [
                // Tab ยังไม่ชำระเงิน
                Container(
                  child: nonpay.length <= 0
                      ? Container(
                          padding:
                              EdgeInsets.only(right: 110, left: 110, top: 20),
                          child: Opacity(
                              opacity: 0.5,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/nopay.png'),
                                  Text(
                                    'ยังไม่มีรายการชำระเงิน',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              )),
                        )
                      : Container(
                          padding: const EdgeInsets.all(5.0),
                          child: ListView.builder(
                            itemCount: nonpay.length,
                            itemBuilder: (context, index) {
                              DateTime orDate =
                                  DateTime.parse('${nonpay[index].sentDate}');
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        // leading: Image.asset(
                                        //   'assets/images/ps01.png',
                                        // ),
                                        title: Text(
                                          'วันที่ส่งพัสดุ : ${formatter.format(orDate)}\nเวลาที่ส่งพัสดุ : ${nonpay[index].sentTime}',
                                        ),
                                        subtitle: Text(
                                          'จำนวนพัสดที่ส่ง : ${nonpay[index].sentNum} กล่อง',
                                        ),
                                        trailing: Image.asset(
                                          'assets/images/dollar.png',
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/paymentdetail',
                                              arguments: {
                                                'or_id': nonpay[index].orId,
                                                'check_id':
                                                    nonpay[index].checkId,
                                                'sent_id':
                                                    nonpay[index].sentId,
                                                'sent_date':
                                                    nonpay[index].sentDate,
                                                'sent_time':
                                                    nonpay[index].sentTime,
                                                'sent_num':
                                                    nonpay[index].sentNum,
                                                'sent_sale':
                                                    nonpay[index].sentSale,
                                                'or_address':
                                                    nonpay[index].orAddress,
                                                'or_status':
                                                    nonpay[index].orStatus,
                                                // 'save_img': orimg,
                                              }).then((onGoBack));
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18),
                                        child: Row(
                                          children: [
                                            Text(
                                              'สถานะ : ',
                                              style: TextStyle(color: Colors.grey[600]),
                                            ),
                                            _status1(context, nonpay[index].orStatus)
                                          ],
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // )
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              );
                            },
                            // separatorBuilder: (context, index) => Divider(
                            //   color: Colors.grey,
                            // ),
                          ),
                        ),
                ),
                // Tab ชำระเงินแล้ว
                Container(
                  child: payment.length <= 0
                      ? Container(
                          padding:
                              EdgeInsets.only(right: 110, left: 110, top: 20),
                          child: Opacity(
                              opacity: 0.5,
                              child: Column(
                                children: [
                                  Image.asset('assets/images/nopay.png'),
                                  Text(
                                    'ยังไม่มีรายการชำระเงิน',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )
                                ],
                              )),
                        )
                      : Container(
                          padding: const EdgeInsets.all(5.0),
                          child: ListView.builder(
                            itemCount: payment.length,
                            itemBuilder: (context, index) {
                              DateTime orDate =
                                  DateTime.parse('${payment[index].payDate}');
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        // leading: Image.asset(
                                        //   'assets/images/ps01.png',
                                        // ),
                                        title: Text(
                                          'วันที่ชำระเงิน : ${formatter.format(orDate)}\nเวลาที่ชำระเงิน : ${payment[index].payTime}',
                                        ),
                                        subtitle: Text(
                                          'ยอดที่ชำระ : ${payment[index].paySale} บาท',
                                        ),
                                        trailing: Image.asset(
                                          'assets/images/dollar.png',
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/checkpayment',
                                              arguments: {
                                                'or_id': payment[index].orId,
                                                'pay_date':
                                                    payment[index].payDate,
                                                'pay_time':
                                                    payment[index].payTime,
                                                'pay_sale':
                                                    payment[index].paySale,
                                                'pay_bank':
                                                    payment[index].payBank,
                                                'or_address':
                                                    payment[index].orAddress,
                                                'or_status': payment[index].orStatus,
                                                // 'save_img': orimg,
                                              }).then((onGoBack));
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 18),
                                        child: Row(
                                          children: [
                                            Text(
                                              'สถานะ : ',
                                              style: TextStyle(color: Colors.grey[600]),
                                            ),
                                            _status2(context, payment[index].orStatus)
                                          ],
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 5,
                                      // )
                                    ],
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              );
                            },
                            // separatorBuilder: (context, index) => Divider(
                            //   color: Colors.grey,
                            // ),
                          ),
                        ),
                ),
              ],
            )));
  }
    Widget _status1(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '3') {
      child =
          Text(_sTATUS1, style: TextStyle(fontSize: 14, color: Colors.red));
    } else {}
    return new Container(child: child);
  }

  Widget _status2(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '4') {
      child =
          Text(_sTATUS2, style: TextStyle(fontSize: 14, color: Colors.green));
    } else {}
    return new Container(child: child);
  }
}
