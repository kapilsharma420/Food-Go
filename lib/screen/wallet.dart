import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String? email, wallet, id;
  getthesharedpref() async {
    email = await SharedPrefHelper().getUserEmail();
    id = await SharedPrefHelper().getUserId();
    setState(() {});
  }

  getUserWallet() async {
    await getthesharedpref();
    QuerySnapshot querySnapshot = await Database().getUserWallet(email!);
    wallet = querySnapshot.docs[0]["Wallet"].toString();

    setState(() {});
  }

  Razorpay _razorpay = Razorpay();
  int selectedAmount = 0; // Track which amount is selected
  var options = {
    'key': 'rzp_test_RB3FEePW83UaOV',
    'amount': 0,
    'currency': 'INR',
    'name': "kapil's FoodGo",
    'description': 'Delicious food delivered to your doorstep',
    'prefill': {'contact': '0000000000', 'email': 'test@razorpay.com'},
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserWallet();
    options['amount'] = 0 * 100; // paise me set

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // 🔹 Reusable function for amount box
  Widget buildAmountBox(int amount) {
    bool isSelected = selectedAmount == amount;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
          options['amount'] = amount * 100; // Razorpay me paise me set
        });
      },
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey,
            width: 2,
          ),
          color: isSelected ? Colors.red[50] : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            '₹$amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.red : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Text('Wallet', style: AppWidget.onboarding_heading_textstyle()),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Image.asset(
                                'images/wallet.png',
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 50),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Wallet',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "₹" + wallet.toString(),
                                    style: AppWidget.bold_textfield_style(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildAmountBox(100),
                          buildAmountBox(500),
                          buildAmountBox(1000),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        _razorpay.open(options);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          //
                          border: Border.all(color: Colors.red, width: 1),
                          color: AppWidget.primary_red_color(),
                          // borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Add Money',
                            style: AppWidget.white_text_field_style(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    int amount = (options['amount'] as int) ~/ 100; // paise → ₹ convert

    await Database().updateUserWallet(amount.toString(), id!);

    await getUserWallet(); // UI update
    Get.snackbar(
      "Success",
      "₹$amount Added Successfully!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get.snackbar(
      "Error",
      "Payment Failed!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(12),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    Get.snackbar(
      "Info",
      "External Wallet Selected!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      margin: const EdgeInsets.all(12),
    );
  }

  dispose() {
    _razorpay.clear();
     super.dispose();
  }
}
