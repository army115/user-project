import 'package:flutter_project_app/model/CheckOrderUser.dart';
import 'package:flutter_project_app/model/OrderList.dart';
import 'package:flutter_project_app/model/OrderImage.dart';
import 'package:flutter_project_app/model/OrderSentUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Orderuser> dataorder = [];
  List<Checkuser> checkorder = [];
  List<Sentuser> sentorder = [];
  Getorderimage orimg;

  var uId;
  var _orstatus;
  var token;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  var _sTATUS0 = 'รอพนักงานเข้ารับพัสดุ';
  var _sTATUS1 = 'กำลังนำส่งบริษัทขนส่ง';
  var _sTATUS2 = 'ส่งพัสดุให้บริษัทขนส่งแล้ว';

  Future onGoBack(dynamic value) {
    setState(() {
      _getShowOrderuser();
      _getCheckOrderuser();
      _getSentOrderuser();
    });
  }

//Order User (รายการออเดอร์ที่แจ้งส่ง user)
  Future<void> _getShowOrderuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('uId = $uId');
    // print('token = $token');
    var url = '${Connectapi().domain}/ShowOrderuser/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      OrderListUser members =
          OrderListUser.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        dataorder = members.orderuser;
        // load = false;
      });
    }
  }

  //Check Order User (รายการออเดอร์ที่รับแล้ว user)
  Future<void> _getCheckOrderuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/CheckOderUser/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      CheckOrderUser members =
          CheckOrderUser.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        checkorder = members.checkuser;
        // load = false;
      });
    }
  }

  //Sent Order User (รายการออเดอร์ที่ส่งแล้ว user)
  Future<void> _getSentOrderuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    // uId = prefs.getInt('id');
    // print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/OderSentUser/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      OrderSentUser members =
          OrderSentUser.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        sentorder = members.sentuser;
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _getShowOrderuser();
    _getCheckOrderuser();
    _getSentOrderuser();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('รายการ', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.amber,
          bottom: TabBar(
            unselectedLabelColor: Colors.black,
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle: TextStyle(
              fontSize: 18.0,
              fontFamily: 'IBMPlexSansThai',
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: 'IBMPlexSansThai',
            ),
            tabs: [
              Tab(
                text: 'รอเข้ารับ',
              ),
              Tab(
                text: 'กำลังนำส่ง',
              ),
              Tab(
                text: 'นำส่งแล้ว',
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.grey[300],
          padding: EdgeInsets.all(5),
          child: TabBarView(
            children: [
              Container(
                child: dataorder.length <= 0
                    ? Container(
                        padding:
                            EdgeInsets.only(right: 120, left: 120, top: 20),
                        child: Opacity(
                            opacity: 0.5,
                            child: Column(
                              children: [
                                Image.asset('assets/images/noorder.png'),
                                Text(
                                  'ยังไม่มีรายการแจ้งส่ง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )
                              ],
                            )),
                      )
                    : Container(
                        child: ListView.builder(
                          itemCount: dataorder.length,
                          itemBuilder: (context, index) {
                            DateTime orDate =
                                DateTime.parse('${dataorder[index].orDate}');
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      // leading:
                                      //     Image.asset('assets/images/ps01.png'),
                                      title: Text(
                                        'วันที่แจ้งส่ง : ${formatter.format(orDate)}\nเวลาที่แจ้งส่ง : ${dataorder[index].orTime}',
                                      ),
                                      subtitle: Text(
                                        'จำนวนพัสดุที่แจ้งส่ง : ${dataorder[index].orNum} กล่อง',
                                      ),
                                      trailing:
                                          Image.asset('assets/images/ps01.png'),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/orderdetail',
                                            arguments: {
                                              'or_id': dataorder[index].orId,
                                              // 'or_sale': datamember[index].orSale,
                                              'or_date':
                                                  dataorder[index].orDate,
                                              'or_time':
                                                  dataorder[index].orTime,
                                              'or_num': dataorder[index].orNum,
                                              'or_address':
                                                  dataorder[index].orAddress,
                                              'or_office':
                                                  dataorder[index].orOffice,
                                              'or_detail':
                                                  dataorder[index].orDetail,
                                              'or_lat': dataorder[index].orLat,
                                              'or_lng': dataorder[index].orLng,
                                            }).then((onGoBack));
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 17),
                                      child: Row(
                                        children: [
                                          Text(
                                            'สถานะ : ',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          _status0(context,
                                              dataorder[index].orStatus)
                                        ],
                                      ),
                                    ),
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
              Container(
                child: checkorder.length <= 0
                    ? Container(
                        padding:
                            EdgeInsets.only(right: 120, left: 120, top: 20),
                        child: Opacity(
                            opacity: 0.5,
                            child: Column(
                              children: [
                                Image.asset('assets/images/noorder.png'),
                                Text(
                                  'ยังไม่มีรายการแจ้งส่ง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )
                              ],
                            )),
                      )
                    : Container(
                        child: ListView.builder(
                          itemCount: checkorder.length,
                          itemBuilder: (context, index) {
                            DateTime orDate =
                                DateTime.parse('${checkorder[index].orDate}');
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      // leading:
                                      //     Image.asset('assets/images/ps01.png'),
                                      title: Text(
                                        'วันที่เข้ารับ : ${formatter.format(orDate)}\nเวลาที่เข้ารับ : ${checkorder[index].checkTime}',
                                      ),
                                      subtitle: Text(
                                        'จำนวนพัสดุที่รับ : ${checkorder[index].checkNum} กล่อง',
                                      ),
                                      trailing:
                                          Image.asset('assets/images/ps01.png'),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/ordercheck',
                                            arguments: {
                                              'or_id': checkorder[index].orId,
                                              // 'or_sale': datamember[index].orSale,
                                              'or_date':
                                                  checkorder[index].orDate,
                                              'or_time':
                                                  checkorder[index].orTime,
                                              'or_num': checkorder[index].orNum,
                                              'or_address':
                                                  checkorder[index].orAddress,
                                              'or_office':
                                                  checkorder[index].orOffice,
                                              'or_detail':
                                                  checkorder[index].orDetail,
                                              'or_lat': checkorder[index].orLat,
                                              'or_lng': checkorder[index].orLng,
                                              'check_date' : checkorder[index].checkDate,
                                              'check_time' : checkorder[index].checkTime,
                                              'check_num' : checkorder[index].checkNum,
                                            }).then((onGoBack));
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 17),
                                      child: Row(
                                        children: [
                                          Text(
                                            'สถานะ : ',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          _status1(context,
                                              checkorder[index].orStatus)
                                        ],
                                      ),
                                    ),
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
              Container(
                child: sentorder.length <= 0
                    ? Container(
                        padding:
                            EdgeInsets.only(right: 120, left: 120, top: 20),
                        child: Opacity(
                            opacity: 0.5,
                            child: Column(
                              children: [
                                Image.asset('assets/images/noorder.png'),
                                Text(
                                  'ยังไม่มีรายการแจ้งส่ง',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                )
                              ],
                            )),
                      )
                    : Container(
                        child: ListView.builder(
                          itemCount: sentorder.length,
                          itemBuilder: (context, index) {
                            DateTime orDate =
                                DateTime.parse('${sentorder[index].orDate}');
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      // leading:
                                      //     Image.asset('assets/images/ps01.png'),
                                      title: Text(
                                        'วันที่นำส่ง : ${formatter.format(orDate)}\nเวลาที่นำส่ง : ${sentorder[index].sentTime}',
                                      ),
                                      subtitle: Text(
                                        'จำนวนพัสดุที่ส่ง : ${sentorder[index].sentNum} กล่อง',
                                      ),
                                      trailing:
                                          Image.asset('assets/images/ps01.png'),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/ordersent',
                                            arguments: {
                                              'or_id': sentorder[index].orId,
                                              // 'or_sale': datamember[index].orSale,
                                              'or_date':
                                                  sentorder[index].orDate,
                                              'or_time':
                                                  sentorder[index].orTime,
                                              'or_num': sentorder[index].orNum,
                                              'or_address':
                                                  sentorder[index].orAddress,
                                              'or_office':
                                                  sentorder[index].orOffice,
                                              'or_detail':
                                                  sentorder[index].orDetail,
                                              'or_lat': sentorder[index].orLat,
                                              'or_lng': sentorder[index].orLng,
                                              'sent_date' : sentorder[index].sentDate,
                                              'sent_time' : sentorder[index].sentTime,
                                              'sent_num' : sentorder[index].sentNum,
                                            }).then((onGoBack));
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 17),
                                      child: Row(
                                        children: [
                                          Text(
                                            'สถานะ : ',
                                            style: TextStyle(
                                                color: Colors.grey[600]),
                                          ),
                                          _status2(context,
                                              sentorder[index].orStatus)
                                        ],
                                      ),
                                    ),
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
          ),
        ),
      ),
    );
  }

  Widget _status0(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '0') {
      child = Text(_sTATUS0, style: TextStyle(fontSize: 14, color: Colors.red));
    } else {}
    return new Container(child: child);
  }

  Widget _status1(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '1') {
      child =
          Text(_sTATUS1, style: TextStyle(fontSize: 14, color: Colors.blue));
    } else {}
    return new Container(child: child);
  }

  Widget _status2(BuildContext context, orderStatus) {
    Widget child;
    if (orderStatus != '2') {
      child =
          Text(_sTATUS2, style: TextStyle(fontSize: 14, color: Colors.green));
    } else {}
    return new Container(child: child);
  }
}
