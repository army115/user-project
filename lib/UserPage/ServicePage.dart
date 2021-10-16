import 'package:flutter/material.dart';
import 'package:flutter_project_app/Widgets/Show_progress.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ServicePage extends StatefulWidget {
  ServicePage({Key key}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

bool load = true;

class _ServicePageState extends State<ServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('อัตราค่าบริการจัดส่ง', style: TextStyle(color: Colors.black)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'อัตราค่าบริการรับฝากส่ง',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Image.asset('assets/images/box.jpg')
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('อัตราค่าจัดส่ง Kerry Express',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Image.asset('assets/images/kerry.jpg'),
                      TextButton(
                        child: Text('รายละเอียดเพิ่มเติม...',
                        style: TextStyle(
                              fontSize: 16)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text('รายละเอียดเพิ่มเติม'),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              body: WebView(
                                      initialUrl:
                                          'https://th.kerryexpress.com/th/services/price-estimation?fbclid=IwAR2C38-t6QzBAfZo_LeKxV7ZaLIHKB_WpmwW_WA-bUDNG62y_oXUw9_Fk5c',
                                          javascriptMode: JavascriptMode.unrestricted,
                                    ),
                            );
                          }));
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('อัตราค่าจัดส่ง Flash Express',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Image.asset('assets/images/flash.jpg'),
                      TextButton(
                        child: Text('รายละเอียดเพิ่มเติม...',
                        style: TextStyle(
                              fontSize: 16,)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text('รายละเอียดเพิ่มเติม'),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              body:  WebView(
                                      initialUrl:
                                          'https://www.flashexpress.co.th/check-price/?fbclid=IwAR2G1LGWKaVLfI8JtE_aar4tULSQyfblzy6IOFwSfKwnyW3CplT0h582dxQ',
                                          javascriptMode: JavascriptMode.unrestricted,
                                    ),
                            );
                          }));
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('อัตราค่าจัดส่ง J&T Express',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Image.asset('assets/images/jt.jpg'),
                      TextButton(
                        child: Text('รายละเอียดเพิ่มเติม...',
                        style: TextStyle(
                              fontSize: 16,)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text('รายละเอียดเพิ่มเติม'),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              body:  WebView(
                                      initialUrl:
                                          'https://jtexpress.co.th/index/query/query.html?fbclid=IwAR1RZXEe572_xIaejkegvKnRAKgXCyLxGVM3eTjGxD7Mk421BbVKndvypUU',
                                          javascriptMode: JavascriptMode.unrestricted,
                                    ),
                            );
                          }));
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('อัตราค่าจัดส่ง ไปรษณีย์ไทย',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Image.asset('assets/images/post.jpg'),
                      Image.asset('assets/images/ems.jpg'),
                      TextButton(
                        child: Text('รายละเอียดเพิ่มเติม...',
                        style: TextStyle(
                              fontSize: 16)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text('รายละเอียดเพิ่มเติม'),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              body:  WebView(
                                      initialUrl:
                                          'https://www.thailandpost.co.th/th/index/?fbclid=IwAR1AcoPmWGgYcCNpk1YPY6h_UcKmuL4ZzA_AVsYXyemMx1SN5bIYHyzwD1Y',
                                          javascriptMode: JavascriptMode.unrestricted,
                                    ),
                            );
                          }));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
