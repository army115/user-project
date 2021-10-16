// import 'package:flutter/material.dart';
// import 'package:flutter_project_app/UserPage/MapPage.dart';
// import 'package:flutter_project_app/UserPage/keys.dart';
// import 'package:flutter_project_app/UserPage/test.dart';
// import 'package:flutter_project_app/Widgets/Show_progress.dart';
// import 'package:flutter_project_app/model/Connectapi.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';
// import 'dart:convert' as convert;
// import 'package:http/http.dart' as http;


// class MapTest extends StatefulWidget {
//   MapTest({Key key}) : super(key: key);

//   static final kInitialPosition = LatLng(-33.8567844, 151.213108);

//   @override
//   _MapTestState createState() => _MapTestState();
// }

// class _MapTestState extends State<MapTest> {
//   // CameraPosition position;
//   Position userLocation;
//   Set<Marker> _markers = {};
//   double lat, lng;
//   bool load = true;
//   GoogleMapController mapController;
//   PickResult selectedPlace;
//   var APIKeys = new keys();


//   final _formkey = GlobalKey<FormState>();
//   final _asdetail = TextEditingController();

//   //connect server api
//   void _address(Map<String, dynamic> values) async {
//     var url = '${Connectapi().domain}/address';
//     var response = await http.post(Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: convert.jsonEncode(values));

//     if (response.statusCode == 200) {
//       print('Add Success');

//       // Navigator.pop(context, true);
//     } else {
//       print('Add not Success!!');
//       print(response.body);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     findLatLan();
//   }

//   Future<Null> findLatLan() async {
//     Position position = await findPosition();
//     setState(() {
//       lat = position.latitude;
//       lng = position.longitude;
//       load = false;
//     });
//     print('lat = $lat, lng = $lng, load = $load');
//   }

//   Future<Position> findPosition() async {
//     try {
//       userLocation = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.best);
//     } catch (e) {
//       userLocation = null;
//     }
//     return userLocation;
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     controller.setMapStyle(Utils.mapStyle);
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: MarkerId('id'),
//           position: LatLng(userLocation.latitude, userLocation.longitude),
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.amber,
//         title: Text('MAP', style: TextStyle(color: Colors.black)),
//       ),
//       body: load ? ShowProgress() : buildCenter(),
//     );
//   }

//   Center buildCenter() {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(10),
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formkey,
//                 child: Column(
//                   children: [
//                     ShowMap(),
//                     // map(),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     address(),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(55, 20, 0, 10),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               btncancel(),
//                               SizedBox(width: 15),
//                               btnSubmit(),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget address() {
//     return TextFormField(
//       controller: _asdetail,
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
//         hintText: 'เพิ่มที่อยู่ของคุณ',
//         icon: Icon(Icons.map_outlined, size: 30),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//       ),
//       validator: (values) {
//         if (values.isEmpty) return 'กรุณากรอกที่อยู่ของคุณ';
//       },
//     );
//   }

//   Widget ShowMap() {
//     return Container(
//       margin: EdgeInsets.all(2),
//       color: Colors.black45,
//       height: 380,
//       child: GoogleMap(
//           onMapCreated: _onMapCreated,
//           markers: _markers,
//           // mapType: MapType.normal,
//           myLocationEnabled: true,
//           initialCameraPosition: CameraPosition(
//             target: LatLng(userLocation.latitude, userLocation.longitude),
//             zoom: 17,
//           )),
//     );
//   }

//   Widget btnSubmit() {
//     return SizedBox(
//       width: 100,
//       height: 30,
//       child: RaisedButton(
//         child: Text(
//           'บันทึก',
//           style: TextStyle(fontSize: 18),
//         ),
//         color: Colors.blue,
//         onPressed: () {
//           // Navigator.pushNamed(context, '/');

//           //ถ้ากรอกครบทุกช่องมันจะเข้า if
//           if (_formkey.currentState.validate()) {
//             Map<String, dynamic> valuse = Map();

//             valuse['as_lat'] = lat.toDouble();
//             valuse['as_lng'] = lng.toDouble();
//             valuse['as_detail'] = _asdetail.text;

//             print(_asdetail.text);
//             print('lat = $lat, lng = $lng, load = $load');

//             _address(valuse);
//           }
//         },
//       ),
//     );
//   }

//   Widget btncancel() {
//     return SizedBox(
//       width: 100,
//       height: 30,
//       child: RaisedButton(
//         child: Text(
//           'ยกเลิก',
//           style: TextStyle(fontSize: 18),
//         ),
//         color: Colors.red,
//         onPressed: () {
//           Navigator.pop(context, '/');
//         },
//       ),
//     );
//   }

//   Widget map() {
//     return Container(
//       child: PlacePicker(
//         apiKey: APIKeys.apikey,
//         initialPosition: MapTest.kInitialPosition,
//         useCurrentLocation: true,
//         selectInitialPosition: true,
//           //usePlaceDetailSearch: true,
//         onPlacePicked: (result) {
//           selectedPlace = result;
//           Navigator.of(context).pop();
//           setState(() {});
//         },
//           forceSearchOnZoomChanged: true,
//         automaticallyImplyAppBarLeading: false,
//         autocompleteLanguage: "ko",
//         region: 'au',
//           // selectInitialPosition: true,
//         // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
//         //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
//         //   return isSearchBarFocused
//         //       ? Container()
//         //       : FloatingCard(
//         //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
//         //           leftPosition: 0.0,
//         //           rightPosition: 0.0,
//         //           width: 500,
//         //           borderRadius: BorderRadius.circular(12.0),
//         //           child: state == SearchingState.Searching
//         //               ? Center(child: CircularProgressIndicator())
//         //               : RaisedButton(
//         //                   child: Text("Pick Here"),
//         //                   onPressed: () {
//         //                     var add = selectedPlace.geometry.location.toJson();
//         //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
//         //                     //            this will override default 'Select here' Button.
//         //                     print('do something with  data $add');
//         //                     Navigator.of(context).pop();
//         //                   },
//         //                 ),
//         //         );
//         // },
//         // pinBuilder: (context, state) {
//         //   if (state == PinState.Idle) {
//         //     return Icon(Icons.favorite_border);
//         //   } else {
//         //     return Icon(Icons.favorite);
//         //   }
//         // },
//       )
//     );
//   }
// }