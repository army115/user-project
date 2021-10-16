import 'package:flutter/material.dart';
import 'package:flutter_project_app/keys.dart';
import 'package:flutter_project_app/model/Connectapi.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_webservice/directions.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  MapPage({Key key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

  // bool load = true;
  PickResult selectedPlace;
  var APIKeys = new keys();

  final kInitialPosition = LatLng(-33.8567844, 151.213108);
  final _formkey = GlobalKey<FormState>();
  final _asdetail = TextEditingController();

  //connect server api
  void _address(Map<String, dynamic> values) async {
    var url = '${Connectapi().domain}/address';
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: convert.jsonEncode(values));

    if (response.statusCode == 200) {
      print('Add Success');

      // Navigator.pop(context, true);
    } else {
      print('Add not Success!!');
      print(response.body);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.amber,
      //   title: Text('MAP', style: TextStyle(color: Colors.black)),
      // ),
      body: buildCenter(),
    );
  }

  Center buildCenter() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.height * 0.6,
                child: map(),
              ),
              SizedBox(
                height: 15,
              ),
              // address(),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(55, 20, 0, 10),
              Column(
                children: [
                  Center(
                    // children: [
                    // btncancel(),
                    // SizedBox(width: 15),
                    child: btnSubmit(),
                    // ],
                  )
                ],
              ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget address() {
    return TextFormField(
      controller: _asdetail,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        hintText: 'เพิ่มที่อยู่ของคุณ',
        icon: Icon(Icons.map_outlined, size: 30),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (values) {
        if (values.isEmpty) return 'กรุณากรอกที่อยู่ของคุณ';
      },
    );
  }

  Widget btnSubmit() {
    return SizedBox(
      width: 300,
      height: 40,
      child: RaisedButton(
        child: Text(
          'บันทึก',
          style: TextStyle(fontSize: 18),
        ),
        color: Colors.amber,
        onPressed: () {
          // Navigator.pushNamed(context, '/');

          //ถ้ากรอกครบทุกช่องมันจะเข้า if
          if (_formkey.currentState.validate()) {
            Map<String, dynamic> valuse = Map();

            var lat = selectedPlace.geometry.location.lat;
            var lng = selectedPlace.geometry.location.lng;

            valuse['as_lat'] = lat;
            valuse['as_lng'] = lng;
            valuse['as_detail'] = _asdetail.text;

            print(_asdetail.text);
            print('$lat,$lng');

            _address(valuse);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
      ),
    );
  }

  Widget map() {
    return Container(
        child: PlacePicker(
      apiKey: APIKeys.apikey,
      initialPosition: kInitialPosition,
      useCurrentLocation: true,
      selectInitialPosition: true,
      usePlaceDetailSearch: true,

      // onPlacePicked: (result) {
      //   selectedPlace = result;
      //   Navigator.of(context).pop();
      //   setState(() {});
      // },

      forceSearchOnZoomChanged: true,
      automaticallyImplyAppBarLeading: true,
      autocompleteLanguage: 'th',
      region: 'th',

      selectedPlaceWidgetBuilder:
(geometry, selectedPlace, state, isSearchBarFocused) {
        print("state: $state, isSearchBarFocused: $isSearchBarFocused");
        return isSearchBarFocused
            ? Container()
            : FloatingCard(
                bottomPosition:
                    3.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                leftPosition: 6.0,
                rightPosition: 65.0,
                width: MediaQuery.of(context).size.height * 0.6,
                borderRadius: BorderRadius.circular(10.0),
                child: state == SearchingState.Searching
                    ? Center(child: CircularProgressIndicator())
                    : TextFormField(
                        controller: _asdetail,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          hintText: 'เพิ่มรายละเอียดที่อยู่ของคุณ',
                          // icon: Icon(Icons.map_outlined, size: 30),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (values) {
                          if (values.isEmpty) return 'กรุณากรอกที่อยู่ของคุณ';
                        },
                      ),

      //              : RaisedButton(
      //   child: Text(
      //     'บันทึก',
      //     style: TextStyle(fontSize: 18),
      //   ),
      //   color: Colors.amber,
      //   onPressed: () {
      //     // Navigator.pushNamed(context, '/');

      //     //ถ้ากรอกครบทุกช่องมันจะเข้า if
      //     if (_formkey.currentState.validate()) {
      //       Map<String, dynamic> valuse = Map();

      //       var lat = selectedPlace.geometry.location.lat;
      //       var lng = selectedPlace.geometry.location.lng;

      //       valuse['as_lat'] = lat;
      //       valuse['as_lng'] = lng;
      //       valuse['as_detail'] = _asdetail.text;

      //       print(_asdetail.text);
      //       print('$lat,$lng');

      //       _address(valuse);
      //       Navigator.pop(context);
      //     }
      //   },
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      //   elevation: 10,
      // ),
              );
      },
      // pinBuilder: (context, state) {
      //   if (state == PinState.Idle) {
      //     return Icon(Icons.favorite_border);
      //   } else {
      //     return Icon(Icons.favorite);
      //   }
      // },
    ));
  }
}
