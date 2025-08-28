import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/screen/login_page.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:lottie/lottie.dart' as lottie;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  /// ✅ Signup Function
  Future<void> signupWithFirebase() async {
    try {
      _unfocusAll();

      if (_formKey.currentState!.validate()) {
        // Loading indicator
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1,
            ),
          ),
          barrierDismissible: false,
        );

        // 🔹 Create user in FirebaseAuth
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // // 🔹 Get userId
        // String uid = userCredential.user!.uid;

        // // 🔹 Save user details in Firestore
        // await FirebaseFirestore.instance.collection("users").doc(uid).set({
        //   "uid": uid,
        //   "name": _nameController.text.trim(),
        //   "email": _emailController.text.trim(),
        //   "createdAt": DateTime.now(),
        // });

        Get.back(); // close loading

        // 🔹 Success Message
        Get.snackbar(
          "Success",
          "Signup Successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // 🔹 Redirect to Login Page
        Get.offAll(() => const LoginPage());
      }
    } on FirebaseAuthException catch (e) {
      Get.back(); // close loading
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
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white12,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  void _unfocusAll() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocusAll,
      child: Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Top Header
                Container(
                  height: Get.height / 3.4,
                  padding: const EdgeInsets.only(bottom: 8),
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: AppWidget.form_yellow_color(),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Column(
                    children: [
                      Flexible(
                        child: lottie.Lottie.asset(
                          'images/Cooking.json',
                          width: 220,
                          height: 180,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Image.asset(
                        'images/name_logo.png',
                        width: 150,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),

                /// Page Title
                const Text(
                  "SignUp",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Create your account to get started",
                  style: AppWidget.form_text_style(),
                ),
                const SizedBox(height: 20),

                /// Signup Form
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        /// Name
                        TextFormField(
                          controller: _nameController,
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(_emailFocus),
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        /// Email
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r"^[^@]+@[^@]+\.[^@]+")
                                .hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        /// Password
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocus),
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),

                        /// Confirm Password
                        TextFormField(
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          textInputAction: TextInputAction.done,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 25),

                        /// Signup Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffffefbf),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: signupWithFirebase,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// Already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            GestureDetector(
                              onTap: () => Get.offAll(() => const LoginPage()),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
