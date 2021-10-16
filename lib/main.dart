import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_project_app/LoginPage.dart';
import 'package:flutter_project_app/MapTest.dart';
import 'package:flutter_project_app/UserPage/AddOrder.dart';
import 'package:flutter_project_app/UserPage/BKK.dart';
import 'package:flutter_project_app/UserPage/KSK.dart';
import 'package:flutter_project_app/UserPage/Password.dart';
import 'package:flutter_project_app/UserPage/SCB.dart';
import 'package:flutter_project_app/UserPage/ServicePage.dart';
import 'package:flutter_project_app/UserPage/Thai.dart';
import 'package:flutter_project_app/UserPage/CheckPayment.dart';
import 'package:flutter_project_app/UserPage/HistoryPage.dart';
import 'package:flutter_project_app/UserPage/HistoryDetail.dart';
import 'package:flutter_project_app/UserPage/OrderCheck.dart';
import 'package:flutter_project_app/UserPage/OrderSent.dart';
import 'package:flutter_project_app/UserPage/PaymentPage.dart';
import 'package:flutter_project_app/UserPage/HomePage.dart';
import 'package:flutter_project_app/UserPage/MapPage.dart';
import 'package:flutter_project_app/UserPage/Menu.dart';
import 'package:flutter_project_app/UserPage/OrderDetail.dart';
import 'package:flutter_project_app/UserPage/OrderPage.dart';
import 'package:flutter_project_app/UserPage/PaymentDetail.dart';
import 'package:flutter_project_app/UserPage/ProfilePage.dart';
import 'package:flutter_project_app/UserPage/RegisterPage.dart';
import 'package:flutter_project_app/UserPage/Track.dart';
import 'package:flutter_project_app/UserPage/UpdatePage.dart';
import 'package:flutter_project_app/UserPage/test.dart';
import 'package:flutter_project_app/utility/multi_form.dart';
import 'package:hexcolor/hexcolor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login' : (context) => LoginPage(),
        '/homepage' :(context) => Homepage(),
        '/register' :(context) => RegisterPage(),
        '/addorder' : (context) => AddOrder(),
        '/order' :(context) => OrderPage(),
        '/orderdetail' :(context) => OrderDetail(),
        '/ordercheck' :(context) => OrderCheck(),
        '/ordersent' :(context) => OrderSent(),
        '/profile' : (context) => ProfilePage(),
        '/update' : (context) => UpdatePage(),
        '/map' : (context) => MapPage(),
        '/payment' : (context) => PaymentPage(),
        '/paymentdetail' : (context) => PaymentDetail(),
        '/checkpayment' : (context) => CheckPayment(),
        '/menu' : (context) => Menu(),
        '/thaibank' : (context) => ThaiBankPage(),
        '/bkkbank' : (context) => BKKBankPage(),
        '/kskbank' : (context) => KSKBankPage(),
        '/scbbank' : (context) => SBCBankPage(),
        '/history' : (context) => HistoryPage(),
        '/historydetail' : (context) => HistoryDetail(),
        '/track' : (context) => Track(),
        '/service' : (context) => ServicePage(),
        '/password' : (context) => Password(),
      },
      // home: UserProfilePage(),
    );
  }
}

  ThemeData mytheme() {
    return ThemeData(
       primaryColor: HexColor('#F9B208'),
      // primaryColor: HexColor('#f34dc3'),
      primaryColorLight: HexColor('#F9F9F9'),
      primaryColorDark: HexColor('#1B1A17'),
      // primaryColorDark: HexColor('#6930c3'),
      // canvasColor: HexColor('#3DB2FF'),
      // errorColor: HexColor('#d90429'),
      backgroundColor: HexColor('#EEEEEE'),
      // scaffoldBackgroundColor: HexColor('#b7efc5'),
      // scaffoldBackgroundColor: HexColor('#ffffff'),
      // cardColor: HexColor('#fffcf9'),
      // cardColor: HexColor('#f5cb5c'),
      // accentColor: HexColor('#0d41e1'),
      fontFamily: 'IBMPlexSansThai',

      appBarTheme: AppBarTheme(
        // centerTitle: true,
        // color: HexColor('#1a1e22'),
        color: HexColor('#ffffff'),
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(
          color: HexColor('#000000'),
        ),
        textTheme: TextTheme(
          headline6: TextStyle(
            fontFamily: 'IBMPlexSansThai',
            color: HexColor('#000000'),
            fontSize: 18,
          ),
        ),
      ),
    );
  }

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.orange[900], Colors.amber],
                begin: Alignment.topCenter,
                end: Alignment.center)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 20,),
              CircleAvatar(
                radius: 120,
                backgroundImage: AssetImage('assets/images/Logo.png'),
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Center(
                    child: LinearProgressIndicator(
                  backgroundColor: Colors.amber,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )),
              ),
              Image.asset('assets/images/city.png'),
            ],
          ),
          
        ),
      ),
    );
  }
}
