import 'package:get/get.dart';

// Shared controller — home se profile tab pe jump karne ke liye
class NavController extends GetxController {
  var currentIndex = 0.obs;

  void goToProfile() => currentIndex.value = 3;
  void goTo(int index) => currentIndex.value = index;
}