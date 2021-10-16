import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class BKKBankPage extends StatefulWidget {
  BKKBankPage({Key key}) : super(key: key);

  @override
  _BKKBankPageState createState() => _BKKBankPageState();
}

class _BKKBankPageState extends State<BKKBankPage> {
  var _orId;
  var _saveSale;
  var bank = 'ธนาคารกรุงเทพ';
  var change = '4';

  // Getorderimage _orImg;
  var formatter = DateFormat('dd/MM/y');

  Map<String, dynamic> _rec_order;
  var token;
  bool load = true;

  Future gettoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print('token = $token');
  }

  // payment
  void _payment(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/Payment';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Payment Success');
      _showSnack();
      // Navigator.pop(context, true);
    } else {
      print('Payment not Success!!');
      print(response.body);
    }
  }

  // update status
  Future<void> _updatestatus(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/updatestatus/$_orId';
    var response = await http.put(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));
    print(values);
    if (response.statusCode == 200) {
      print('Update Success');
      // Navigator.pop(context, true);
    } else {
      print('Update Fail');
    }
  }

  Future getInfo() async {
    // รับค่า
    _rec_order = ModalRoute.of(context).settings.arguments;
    _orId = _rec_order['or_id'];
    _saveSale = _rec_order['total'];
    print(_saveSale);
  }

  //Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';
  var filename;

//multi_image_picker
  Future<String> _multiUploadimage(ast) async {
    var _urlUpload = '${Connectapi().domain}/uploadImPm/$_orId';
    // ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
    // create multipart request
    http.MultipartRequest request =
        http.MultipartRequest("PUT", Uri.parse(_urlUpload));
    ByteData byteData = await ast.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();

    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'picture', //key of the api
      imageData,
      filename: 'some-file-name.jpg',
      contentType: MediaType("image",
          "jpg"), //this is not nessessory variable. if this getting error, erase the line.
    );
// add file to multipart
    request.files.add(multipartFile);
// send
    var response = await request.send();
    return response.reasonPhrase;
  }

  //multi_image_picker
  List<Asset> images = <Asset>[];
  Asset asset;
  String _error = 'No Error Dectected';

  // @override
  // void initState() {

  // }

  //สร้าง GridView
  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 1,
      children: List.generate(images.length, (index) {
        return AssetThumb(
          asset: images[index],
          width: 500,
          height: 500,
        );
      }),
    );
  }

  //LoadAssets
  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#FFCC00",
          actionBarTitle: "อัพโหลดรูปภาพ",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
      print('path : ${images.length}');
      _error = error;
    });
  }

  //Loop รูปภาพ
  Future<void> _sendPathImage() async {
    print('path : ${images.length}');
    for (int i = 0; i < images.length; i++) {
      asset = images[i];
      print('image : $i');
      var res = _multiUploadimage(asset);
    }
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    gettoken();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ชำระค่าจัดส่ง',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Card(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Column(
                            children: [
                              Text('ธนาคารกรุงเทพ',
                                  style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ชื่อบัญชี : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('บริษัท รับฝากส่ง จำกัด',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ))
                                ],
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('เลขที่บัญชี : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('0501123366',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ))
                                ],
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ยอดชำระ : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600])),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('${_saveSale} บาท',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black87,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Container(
                            width: 200,
                            height: 200,
                            child: Image.asset('assets/images/QRcode.jpg')),
                      ],
                    )),
                elevation: 10,
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 50, right: 50, top: 10, bottom: 10),
                  child: Column(
                    children: [
                      image(),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.height * 0.3,
                        child: buildGridView(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      btnsubmit()
                    ],
                  ),
                ),
                elevation: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnsubmit() {
    return SizedBox(
      width: 230,
      height: 40,
      child: RaisedButton(
        child: Text(
          'ชำระเงิน',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        color: Colors.amber,
        onPressed: () {
          return showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 30,
                          color: Colors.green
                        ),
                        Expanded(
                          child: Text('ยืนยันการชำระเงิน'),
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
                          Map<String, dynamic> valuse = Map();
                          valuse['or_id'] = _orId;
                          valuse['pay_sale'] = _saveSale;
                          valuse['pay_bank'] = bank;

                          _payment(valuse);
                          print(valuse);
                          _sendPathImage();
                          changeStatus();
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 3);
                        },
                      ),
                    ],
                  ));
        },
      ),
    );
  }

  Future changeStatus() {
    Map<String, dynamic> valuse = Map();
    valuse['or_status'] = change;
    print(valuse);
    _updatestatus(valuse);
  }

  Widget image() {
    return SizedBox(
      height: 40,
      width: 290,
      child: OutlineButton(
        child: Text('เพิ่มรูปภาพใบเสร็จชำระเงิน',
            style: TextStyle(
              fontSize: 18,
            )),
        // Icon(Icons.add_photo_alternate, size: 25),
        onPressed: () {
          loadAssets();
        },
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
      // validator: (values) {
      //   if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      // },
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
                child: Text('ชำระเงินสำเร็จ'),
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
