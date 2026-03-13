import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static String userIdKey = 'USERIDKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailKey = 'USEREMAILKEY';
  static String userImageKey = 'USERIMAGEKEY';
  static String userAddressKey = 'USERADDRESSKEY';
  static String onboardingSeenKey = 'ONBOARDINGSEENKEY';
  static String adminLoggedInKey = 'ADMINLOGGEDINKEY'; // 🔹 Admin flag

  // ---------------- SAVE METHODS ----------------
  Future<bool> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userIdKey, userId);
  }

  Future<bool> saveUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName);
  }

  Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, userEmail);
  }

  Future<bool> saveUserImage(String userImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImageKey, userImage);
  }

  Future<bool> saveUserAddress(String userAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userAddressKey, userAddress);
  }

  Future<bool> saveOnboardingSeen(bool seen) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(onboardingSeenKey, seen);
  }

  // 🔹 Admin login flag — save/get/clear
  Future<bool> saveAdminLoggedIn(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(adminLoggedInKey, value);
  }

  Future<bool> getAdminLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(adminLoggedInKey) ?? false;
  }

  Future<void> clearAdminLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(adminLoggedInKey);
  }

  // ---------------- GET METHODS ----------------
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdKey);
  }

  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }

  Future<String?> getUserImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImageKey);
  }

  Future<String?> getUserAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userAddressKey);
  }

  Future<bool?> getOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(onboardingSeenKey);
  }

  // ---------------- CLEAR ----------------
  Future<bool> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
    await prefs.remove(userNameKey);
    await prefs.remove(userEmailKey);
    await prefs.remove(userImageKey);
    await prefs.remove(userAddressKey);
    return true;
  }
}