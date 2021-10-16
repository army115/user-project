import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<String> _images = [
    'assets/images/home.jpg',
    'assets/images/map.jpg',
    'assets/images/send.jpg',
    'assets/images/box.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(55.0),
        child: AppBar(
          title: Text('แอปพลิเคชันบริการรับฝากส่งพัสดุ',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Theme.of(context).primaryColor,
          // actions: [
          //   IconButton(
          //       icon: Icon(
          //         Icons.notifications_outlined,
          //         color: Colors.black,
          //       ),
          //       onPressed: () {}),
          // ],
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Stack(fit: StackFit.expand, children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(bottom: 100),
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
                  // ),
                  child: Swiper(
                    autoplay: true,
                    loop: true,
                    // fade: 0.0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Column(
                          children: [
                            Image.asset(_images[index].toString(),
                                // width: MediaQuery.of(context).size.width * 0.9,
                                height: 240),
                          ],
                        ),
                      );
                    },
                    // ),
                    itemCount: 4,
                    scale: 1.0,
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        activeColor : Colors.black
                      )
                    ),
                  ),
                  elevation: 10,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 30, left: 10, right: 10),
          child: SafeArea(
            child: Column(children: [
              Container(
                padding: EdgeInsets.only(top: 250),
                width: 500,
                height: 650,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Flexible(
                      // << Grid Dashboard
                      child: GridView.count(
                        // scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        childAspectRatio: 1.0,
                        padding: EdgeInsets.all(10),
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        primary: true,
                        children: [
                          GridMenu(
                            press: () {
                              Navigator.pushNamed(context, '/order');
                            },
                            img: 'assets/images/ps01.png',
                            // icon: Icons.ac_unit_outlined,
                            title: "รายการแจ้งส่งพัสดุ",
                            // subtitle: "subtitle",
                          ),
                          GridMenu(
                            press: () {
                              Navigator.pushNamed(context, '/service');
                            },
                            img: 'assets/images/trans.png',
                            // icon: Icons.ac_unit_outlined,
                            title: "อัตราค่าบริการจัดส่ง",
                            // subtitle: "subtitle",
                          ),
                          GridMenu(
                            press: () {
                              Navigator.pushNamed(context, '/payment');
                            },
                            img: 'assets/images/dollar.png',
                            // icon: Icons.ac_unit_outlined,
                            title: "การชำระเงิน",
                            // subtitle: "subtitle",
                          ),
                          GridMenu(
                            press: () {
                              Navigator.pushNamed(context, '/history');
                            },
                            img: 'assets/images/his.png',
                            // icon: Icons.ac_unit_outlined,
                            title: "ประวัติการส่ง",
                            // subtitle: "subtitle",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ]),
    );
  }
}

//  Grid Menu Dashboard
class GridMenu extends StatelessWidget {
  const GridMenu({
    Key key,
    @required this.press,
    @required this.img,
    // @required this.icon,
    @required this.title,
    // @required this.subtitle,
  }) : super(key: key);

  final VoidCallback press;
  final String img;
  // final icon;
  final String title;
  // final String subtitle;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: press,
      child: Card(
        elevation: 5,
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              img,
              width: 80,
            ),
            // Icon(icon),
            SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
