import 'package:flutter/material.dart';
import 'package:flutter_project_app/UserPage/HomePage.dart';
import 'package:flutter_project_app/UserPage/Menu.dart';
import 'package:flutter_project_app/UserPage/OrderPage.dart';
import 'package:flutter_project_app/UserPage/PaymentPage.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key key}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _currentPage;

  @override
  void initState() {
    _currentPage = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(_currentPage),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: AnimatedBottomNav(
              currentIndex: _currentPage,
              onChange: (index) {
                setState(() {
                  _currentPage = index;
                });
              }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 70,
        height: 70,
        child: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/addorder');
            }),
      ),
    );
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return Homepage();
      case 1:
        return OrderPage();
      case 2:
        return PaymentPage();
      case 3:
        return Menu();
    }
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;
  const AnimatedBottomNav({Key key, this.currentIndex, this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      // decoration: BoxDecoration(color: Colors.amber),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => onChange(0),
              child: BottomNavItem(
                icon: Icons.home,
                title: 'หน้าหลัก',
                isActive: currentIndex == 0,
              ),
            ),
          ),
          // Expanded(
          //   child: InkWell(
          //     onTap: () => onChange(1),
          //     child: BottomNavItem(
          //       icon: Icons.receipt_outlined,
          //       title: 'รายการ',
          //       isActive: currentIndex == 1,
          //     ),
          //   ),
          // ), 
          // Expanded(
          //   child: InkWell(
          //     onTap: () => onChange(2),
          //     child: BottomNavItem(
          //       icon: Icons.paid_outlined,
          //       // icon: Icons.attach_money,
          //       title: 'ชำระเงิน',
          //       isActive: currentIndex == 2,
          //     ),
          //   ),
          // ),
          Expanded(
            child: Text(''),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(3),
              child: BottomNavItem(
                icon: Icons.person,
                // icon: Icons.reorder,
                title: 'เมนู',
                isActive: currentIndex == 3,
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final String title;
  const BottomNavItem(
      {Key key,
      this.isActive = false,
      this.icon,
      this.activeColor,
      this.inactiveColor,
      this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 200),
      child: isActive
          ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
              icon,
              color: inactiveColor ?? Colors.black,
              size: 30,
            ),
            
                  // const SizedBox(height: 5.0),
                  // Container(
                  //   width: 5.0,
                  //   height: 5.0,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: activeColor ?? Theme.of(context).primaryColor,
                  //   ),
                  // ),
                ],
              ),
            )
          : Icon(
              icon,
              color: inactiveColor ?? Colors.white,
              size: 30,
            ),
    );
  }
}
