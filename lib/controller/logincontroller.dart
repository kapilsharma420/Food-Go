import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/screen/bottomnav.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  var obscurePassword = true.obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> loginWithFirebase() async {
    if (!formKey.currentState!.validate()) return;

    FocusManager.instance.primaryFocus?.unfocus();
    errorMessage.value = '';
    isLoading.value = true;

    try {
      // Step 1: Firebase Auth login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Step 2: Firestore se user data fetch karo
      var userSnapshot =
          await Database().getUserWallet(emailController.text.trim());

      if (userSnapshot.docs.isEmpty) {
        // Doc nahi milaa — kuch toh gadbad hai
        await FirebaseAuth.instance.signOut();
        isLoading.value = false;
        errorMessage.value = 'Account not found. Please signup first.';
        return;
      }

      var userData = userSnapshot.docs[0];
      final Map<String, dynamic> userMap =
          userData.data() as Map<String, dynamic>;

      // Step 3: 🔹 isDisabled check — admin ne disable kiya hai kya
      final bool isDisabled = userMap.containsKey('isDisabled')
          ? (userMap['isDisabled'] ?? false)
          : false;

      if (isDisabled) {
        await FirebaseAuth.instance.signOut();
        isLoading.value = false;
        errorMessage.value =
            'Your account has been suspended. Please contact KAPIL SHARMA';
        return;
      }

      // Step 4: SharedPref mein save karo
      await Future.wait([
        SharedPrefHelper()
            .saveUserEmail(userMap['Email'] ?? emailController.text.trim()),
        SharedPrefHelper().saveUserName(userMap['Name'] ?? ''),
        SharedPrefHelper().saveUserId(userMap['Id'] ?? ''),
      ]);

      isLoading.value = false;
      Get.offAll(() => const BottomNav());

    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      errorMessage.value = _getErrorMessage(e.code);
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Something went wrong. Please try again.';
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check and try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}