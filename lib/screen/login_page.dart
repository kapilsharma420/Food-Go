import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hot_bite/screen/forgotpassword.dart';
import 'package:hot_bite/screen/home.dart';
import 'package:hot_bite/screen/signup.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _obscurePassword = true;

  //login function used in login button
  Future<void> loginWithFirebase() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      // Loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white,strokeWidth: 1,)),
        barrierDismissible: false,
      );

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ); 

        Get.back(); // close loading

        Get.snackbar(
          "Success",
          "Login Successful!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
       
        // यहाँ पर तुम्हें HomePage या Dashboard पर navigate करना चाहिए
        // Example:
         Get.offAll(() => const HomePage());
      } on FirebaseAuthException catch (e) {
        Get.back(); // close loading

        String errorMessage;
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address.';
        } else {
          errorMessage = e.message ?? 'Login failed.';
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
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // notch area transparent
        systemNavigationBarColor: Colors.white12, // bottom nav bar transparent
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      Get.snackbar(
        "Success",
        "Login Successful!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Top Header
              Container(
                height: Get.height / 3.5,
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
                    lottie.Lottie.asset(
                      'images/Cooking.json',
                      width: 220,
                      height: 180,
                      fit: BoxFit.fill,
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
              Text(
                "LogIn",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Welcome back! Please login to continue",
                style: AppWidget.form_text_style(),
              ),

              const SizedBox(height: 20),

              /// Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// Email
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
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
                          if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(value)) {
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
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submitForm(),
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
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),

                      /// Forgot Password 
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.to(() =>  ForgotPasswordPage());
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Login Button
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
                          onPressed: () {
                            loginWithFirebase();
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// Don't have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () => Get.offAll(const SignupPage()),
                            child: const Text(
                              "SignUp",
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
    );
  }
}
