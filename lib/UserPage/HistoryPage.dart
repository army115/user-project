import 'package:flutter/material.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:flutter_project_app/model/History.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HistoryPage extends StatefulWidget {
  HistoryPage({Key key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Hisuser> his = [];

  var uId;
  var token;
  var formatter = DateFormat('dd/MM/y');
  var formattime = DateFormat('HH:mm');

  //Payment (รายการที่ต้องชำระเงิน )
  Future<void> _ShowHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('uId = $uId');
    print('token = $token');
    var url = '${Connectapi().domain}/Showhistoryuser/$uId';
    //conect
    var response = await http.get(Uri.parse(url), headers: {
      'Connect-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

//check response
    if (response.statusCode == 200) {
      //แปลงjson ให้อยู่ในรูปแบบ model members
      History members = History.fromJson(convert.jsonDecode(response.body));
      //รับค่า ข้อมูลทั้งหมดไว้ในตัวแปร
      setState(() {
        his = members.hisuser;
        // load = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //call _getAPI
    _ShowHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('ประวัติรายการแจ้งส่ง'),
      ),
      backgroundColor: Colors.grey[300],
      body: Container(
        child: his.length <= 0
            ? Container(
                padding: EdgeInsets.only(right: 110, left: 110, top: 20),
                child: Opacity(
                    opacity: 0.5,
                    child: Column(
                      children: [
                        Image.asset('assets/images/order.png'),
                        Text(
                          'ยังไม่มีประวัติรายการส่ง',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        )
                      ],
                    )),
              )
            : Container(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: his.length,
                  itemBuilder: (context, index) {
                    DateTime orDate = DateTime.parse('${his[index].payDate}');
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
                                'วันที่แจ้งส่ง : ${formatter.format(orDate)}\nเวลาที่แจ้งส่ง : ${his[index].payTime}',
                              ),
                              subtitle: Text(
                                'จำนวนพัสดุ : ${his[index].orNum} กล่อง\nยอดชำระเงิน : ${his[index].paySale} บาท',
                              ),
                              trailing: Image.asset(
                                'assets/images/ps01.png',
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/historydetail',
                                    arguments: {
                                      'or_id': his[index].orId,
                                      'or_address': his[index].orAddress,
                                      'or_status': his[index].orStatus,
                                      'or_date': his[index].orDate,
                                      'or_time': his[index].orTime,
                                      'or_num': his[index].orNum,
                                      'or_detail': his[index].orDetail,
                                      'or_office': his[index].orOffice,
                                      'pay_date': his[index].payDate,
                                      'pay_time': his[index].payTime,
                                      'pay_sale': his[index].paySale,
                                      'pay_bank': his[index].payBank,
                                    });
                              },
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 95),
                            //   child: Row(
                            //     children: [
                            //       Text(
                            //         'สถานะ : ',
                            //         style: TextStyle(color: Colors.grey[600]),
                            //       ),
                            //       _status0(context, status?[index].orStatus)
                            //     ],
                            //   ),
                            // ),
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
    );
  }
}
