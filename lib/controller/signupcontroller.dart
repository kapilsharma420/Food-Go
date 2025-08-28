import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hot_bite/screen/login_page.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:random_string/random_string.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final confirmPasswordFocus = FocusNode();

  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;

  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPassword() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  void unfocusAll() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> signupWithFirebase() async {
    if (!formKey.currentState!.validate()) return;

    unfocusAll();

    try {
      // Firebase create user
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String id = randomAlphaNumeric(10);

      Map<String, dynamic> userInfoMap = {
        "Id": id,
        "Name": nameController.text.trim(),
        "Email": emailController.text.trim(),
      };

      await SharedPrefHelper().saveUserEmail(emailController.text.trim());
      await SharedPrefHelper().saveUserName(nameController.text.trim());
      await Database().addUserDetails(userInfoMap, id);

      // ✅ Success snackbar
      Get.snackbar(
        "Success",
        "Signup Successful!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate to login page
      Get.offAll(() => LoginPage());

    } on FirebaseAuthException catch (e) {
      String errorMessage;

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email format.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'Password is too weak.';
      } else {
        errorMessage = e.message ?? 'Something went wrong';
      }

      // ❌ Error snackbar
      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.onClose();
  }
}
