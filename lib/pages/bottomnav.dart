import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hot_bite/pages/home.dart';
import 'package:hot_bite/pages/order.dart';
import 'package:hot_bite/pages/profile.dart';
import 'package:hot_bite/pages/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late HomePage home;
  late OrderPage order;
  late WalletPage wallet;
  late ProfilePage profile;
  int currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    home = HomePage();
    order = OrderPage();
    wallet = WalletPage();
    profile = ProfilePage();
    pages = [home, order, wallet, profile];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 231, 135, 135),
        animationDuration: Duration(milliseconds: 300),

        items: [
          Icon(Icons.home, size: 25, color: Colors.black54),
          Icon(Icons.shopping_bag, size: 25, color: Colors.black54),
          Icon(Icons.wallet, size: 25, color: Colors.black54),
          Icon(Icons.person, size: 25, color: Colors.black54),
        ],
        onTap: (index) {
         
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: pages[currentPageIndex],
    );
  }
}
