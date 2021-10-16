import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_app/keys.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  String _chosenoffice;
  PickResult selectedPlace;
  var APIKeys = new keys();
  var token;
  var uId;

  //เช็คการกรอกข้อมูล

  final kInitialPosition = LatLng(16.19847505, 103.271562);
  final _formkey = GlobalKey<FormState>();
  final _ornum = TextEditingController();
  final _oraddress = TextEditingController();
  final _ordetail = TextEditingController();

  Future getOr() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    uId = prefs.getInt('id');
    print('uId = $uId');
    print('token = $token');
  }

  void _addorder(Map<String, dynamic> values) async {
    String url = '${Connectapi().domain}/addorder/$uId';
    var response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('AddOrder Success');
      Navigator.pop(context, true);
      _showSnack();
    } else {
      print('AddOrder not Success!!');
      print(response.body);
    }
  }

  //Upload Images อัพโหลดรูปภาพ =====================
  //ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ
  // File _image;
  // File _camera;
  // String imgstatus = '';
  // String error = 'Error';
  var filename;
  var _urlUpload = '${Connectapi().domain}/uploads';
  // ตัวแปรเกี่ยวกับ อัพโหลดรูปภาพ

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

//multi_image_picker
  Future<String> _multiUploadimage(ast) async {
// create multipart request
    http.MultipartRequest request =
        http.MultipartRequest("POST", Uri.parse(_urlUpload));
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
    getOr();
    return Scaffold(
      appBar: AppBar(
        title: Text('แจ้งรายการส่ง', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.amber,
      ),
      // drawer: MenuPage(),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formkey,
            child: Center(
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 1, left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          // office(),
                          // size(),
                          number(),
                          detail(),
                          office()
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 5, left: 10, right: 10, bottom: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              image(),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.height * 0.3,
                            child: buildGridView(),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 5, left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.map_outlined,
                                  size: 30, color: Colors.grey),
                              SizedBox(
                                width: 15,
                              ),
                              map(),
                            ],
                          ),
                          address(),
                          Padding(
                            padding: EdgeInsets.only(top: 5, left: 20),
                            child: selectedPlace == null
                                ? Container()
                                : Column(
                                    children: [
                                      Text('ตำแหน่งปัจจุบันของคุณ'),
                                      Row(
                                        children: [
                                          Text('ละติจูดที่ : '),
                                          Text(selectedPlace
                                                  .geometry.location.lat
                                                  .toString() ??
                                              ""),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('ลองะติจูด : '),
                                          Text(selectedPlace
                                                  .geometry.location.lat
                                                  .toString() ??
                                              ""),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 5),
                      btnSubmit()
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget address() {
    return TextFormField(
      controller: _oraddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 15.0),
        hintText: 'เพิ่มรายละเอียดที่อยู่ของคุณ',
        // labelText: 'เพิ่มรายละเอียดที่อยู่ของคุณ',
        hintStyle: TextStyle(fontSize: 17),
        icon: Icon(Icons.home, size: 30),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกที่อยู่ของคุณ';
      },
      textCapitalization: TextCapitalization.sentences,
      maxLines: 2,
    );
  }

  Widget office() {
    return Container(
      padding: EdgeInsets.only(left: 40),
      child: DropdownButtonFormField<String>(
        dropdownColor: Colors.white,
        value: _chosenoffice,
        // icon: Icon(Icons.airport_shuttle_sharp,
        //         size: 25),
        icon: Icon(Icons.arrow_drop_down_sharp, size: 30),
        items: <String>[
          'ไปรษณีย์ไทย',
          'Kerry Express',
          'Flash Express',
          'J&T Express',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        hint: Text(
          "เลือกบริษัทขนส่ง",
          style: TextStyle(fontSize: 17),
        ),
        onChanged: (String value) {
          setState(() {
            _chosenoffice = value;
          });
        },
      ),
    );
  }

  // Widget size() {
  //   return TextFormField(
  //     decoration: InputDecoration(
  //       hintText: 'เลือกขนาดพัสดุ',
  //       hintStyle: TextStyle(fontSize: 14),
  //       icon: Icon(Icons.inbox_rounded, size: 30),
  //       // border: OutlineInputBorder(
  //       //     borderRadius: BorderRadius.circular(10.0),
  //       // ),
  //     ),
  //     // validator: (values) {
  //     //   if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
  //     // },
  //   );
  // }

  Widget number() {
    return TextFormField(
      controller: _ornum,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 20.0),
        hintText: 'จำนวนพัสดุที่ต้องการส่ง',
        hintStyle: TextStyle(fontSize: 17),
        icon: Icon(Icons.add_circle_outline_sharp, size: 30),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกชื่อผู้ใช้';
      },
    );
  }

  Widget detail() {
    return TextFormField(
      controller: _ordetail,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(5.0, 20.0, 10.0, 20.0),
        hintText: 'รายละเอียดเพิ่มเติม',
        hintStyle: TextStyle(fontSize: 17),
        icon: Icon(Icons.playlist_add, size: 30),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกรายละเอียด';
      },
    );
  }

  Widget image() {
    return SizedBox(
      height: 40,
      width: 290,
      child: OutlineButton(
        child: Text('เพิ่มรูปภาพ',
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

  Widget map() {
    return SizedBox(
      height: 40,
      width: 290,
      child: OutlineButton(
        child: Text('เพิ่มที่อยู่',
            style: TextStyle(
              fontSize: 18,
            )),
        // Icon(Icons.add_photo_alternate, size: 25),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PlacePicker(
                  apiKey: APIKeys.apikey,
                  initialPosition: kInitialPosition,
                  useCurrentLocation: true,
                  selectInitialPosition: true,
                  usePlaceDetailSearch: true,

                  onPlacePicked: (result) {
                    selectedPlace = result;
                    Navigator.of(context).pop();
                    setState(() {});
                  },

                  forceSearchOnZoomChanged: true,
                  automaticallyImplyAppBarLeading: true,
                  autocompleteLanguage: "th",
                  region: 'th',

                  // selectedPlaceWidgetBuilder:
                  //     (_, selectedPlace, state, isSearchBarFocused) {
                  //   print(
                  //       "state: $state, isSearchBarFocused: $isSearchBarFocused");
                  //   return isSearchBarFocused
                  //       ? Container()
                  //       : FloatingCard(
                  //           bottomPosition:
                  //               3.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                  //           leftPosition: 6.0,
                  //           rightPosition: 65.0,
                  //           width: MediaQuery.of(context).size.height * 0.6,
                  //           borderRadius: BorderRadius.circular(10.0),
                  //           child: state == SearchingState.Searching
                  //               ? Center(child: CircularProgressIndicator())
                  //               // : TextFormField(
                  //               //     controller: _asdetail,
                  //               //     decoration: InputDecoration(
                  //               //       contentPadding:
                  //               //           EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                  //               //       hintText: 'เพิ่มรายละเอียดที่อยู่ของคุณ',
                  //               //       // icon: Icon(Icons.map_outlined, size: 30),
                  //               //       border: OutlineInputBorder(
                  //               //         borderRadius: BorderRadius.circular(10.0),
                  //               //       ),
                  //               //     ),
                  //               //     validator: (values) {
                  //               //       if (values.isEmpty) return 'กรุณากรอกที่อยู่ของคุณ';
                  //               //     },
                  //               //   ),

                  //               : RaisedButton(
                  //                   child: Text(
                  //                     'บันทึก',
                  //                     style: TextStyle(fontSize: 18),
                  //                   ),
                  //                   color: Colors.amber,
                  //                   onPressed: () {

                  //                     var lat = selectedPlace.geometry.location.lat;
                  //                     var lng = selectedPlace.geometry.location.lng;
                  //                     var add = selectedPlace.formattedAddress;

                  //                     print('$lat,$lng,');

                  //                     print('$add');
                  //                     Navigator.of(context).pop();
                  //                     setState(() {});
                  //                   },
                  //                   shape: RoundedRectangleBorder(
                  //                       borderRadius:
                  //                           BorderRadius.circular(20)),
                  //                   elevation: 10,
                  //                 ),
                  //         );
                  // },
                  // pinBuilder: (context, state) {
                  //   if (state == PinState.Idle) {
                  //     return Icon(Icons.favorite_border);
                  //   } else {
                  //     return Icon(Icons.favorite);
                  //   }
                  // },
                );
              },
            ),
          );
        },
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        // ),
      ),
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: RaisedButton(
        child: Text('ยืนยันการแจ้งส่ง', style: TextStyle(fontSize: 20)),
        color: Colors.amber,
        onPressed: () {
          if (_formkey.currentState.validate()) {
            Map<String, dynamic> valuse = Map();
            var lat = selectedPlace.geometry.location.lat;
            var lng = selectedPlace.geometry.location.lng;

            valuse['or_num'] = _ornum.text;
            valuse['or_office'] = _chosenoffice.toString();
            valuse['or_detail'] = _ordetail.text;
            valuse['or_lat'] = lat;
            valuse['or_lng'] = lng;
            valuse['or_address'] = _oraddress.text;

            print(_ornum.text);
            print(_ordetail.text);
            print(_sendPathImage);
            print('$lat,$lng');
            print(_oraddress.text);

            _sendPathImage();
            _addorder(valuse);

            // Navigator.pushNamed(context, '/order');
          }
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
                child: Text('แจ้งส่งพัสดุสำเร็จ'),
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

  // Widget btncancel(){
  //     return SizedBox(
  //       width : 150,
  //       height: 40,
  //       child: RaisedButton(
  //         child: Text('ยกเลิก'),
  //         color: Colors.red,
  //         onPressed: () {
  //           Navigator.pop(context,);
  //         },
  //         ),
  //     );
  // }
} //class
