import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/controller/nav_controller.dart';
import 'package:hot_bite/screen/home.dart';
import 'package:hot_bite/screen/order.dart';
import 'package:hot_bite/screen/profile.dart';
import 'package:hot_bite/screen/wallet.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 NavController — home se profile navigate karne deta hai
    final NavController navController = Get.put(NavController());

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final List<Widget> pages = const [
      HomePage(),
      OrderPage(),
      WalletPage(),
      ProfilePage(),
    ];

    return Obx(() => Scaffold(
          extendBody: true,
          bottomNavigationBar: CurvedNavigationBar(
            index: navController.currentIndex.value,
            height: 60,
            backgroundColor: Colors.transparent,
            color: const Color.fromARGB(255, 231, 135, 135),
            animationDuration: const Duration(milliseconds: 300),
            items: const [
              Icon(Icons.home, size: 25, color: Colors.black54),
              Icon(Icons.shopping_bag, size: 25, color: Colors.black54),
              Icon(Icons.wallet, size: 25, color: Colors.black54),
              Icon(Icons.person, size: 25, color: Colors.black54),
            ],
            onTap: (index) => navController.goTo(index),
          ),
          body: pages[navController.currentIndex.value],
        ));
  }
}