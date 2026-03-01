import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  String? id;
  int selectedAmount = 0;
  late Razorpay _razorpay;

  var options = {
    'key': 'rzp_test_RB3FEePW83UaOV',
    'amount': 0,
    'currency': 'INR',
    'name': "Kapil's FoodGo",
    'description': 'Add money to wallet',
    'prefill': {'contact': '0000000000', 'email': 'test@razorpay.com'},
  };

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _loadId();
  }

  Future<void> _loadId() async {
    // 🔹 Sirf ID load karo — wallet Stream se real-time aayega
    id = await SharedPrefHelper().getUserId();
    if (mounted) setState(() {});
  }

  // 🔹 ScaffoldMessenger use karo — Overlay crash nahi hoga
  void _showMessage(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildAmountBox(int amount) {
    bool isSelected = selectedAmount == amount;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAmount = amount;
          options['amount'] = amount * 100;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 95,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.red : Colors.grey.shade400,
            width: 2,
          ),
          color: isSelected ? Colors.red.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.red.shade100, blurRadius: 6)]
              : [],
        ),
        child: Center(
          child: Text(
            '₹$amount',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.red : Colors.black87,
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
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Text('Wallet', style: AppWidget.onboarding_heading_textstyle()),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // 🔹 StreamBuilder — real-time wallet balance by ID
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Image.asset('images/wallet.png',
                                  height: 80, width: 80, fit: BoxFit.cover),
                              const SizedBox(width: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Your Wallet',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 6),
                                  // 🔹 id null check — loading dikhao
                                  id == null
                                      ? const CircularProgressIndicator(
                                          strokeWidth: 1.5, color: Colors.red)
                                      : StreamBuilder<DocumentSnapshot>(
                                          stream: Database()
                                              .getWalletStream(id!),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator(
                                                  strokeWidth: 1.5,
                                                  color: Colors.red);
                                            }
                                            if (snapshot.hasError ||
                                                !snapshot.hasData ||
                                                !snapshot.data!.exists) {
                                              return const Text('₹0',
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red));
                                            }
                                            // 🔹 Real-time balance — har update pe automatic refresh
                                            String walletVal = snapshot
                                                    .data!['Wallet']
                                                    ?.toString() ??
                                                '0';
                                            return Text(
                                              '₹$walletVal',
                                              style: const TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Amount selection boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAmountBox(100),
                        _buildAmountBox(500),
                        _buildAmountBox(1000),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Agar koi amount select nahi to warning
                    if (selectedAmount == 0)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          'Please select an amount above',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),

                    const SizedBox(height: 25),

                    // Add Money button
                    GestureDetector(
                      onTap: () {
                        // 🔹 Amount select karna zaroori
                        if (selectedAmount == 0) {
                          _showMessage(
                              'Please select an amount first!', Colors.orange);
                          return;
                        }
                        if (id == null) {
                          _showMessage('User not found. Please login again.',
                              Colors.red);
                          return;
                        }
                        _razorpay.open(options);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: selectedAmount == 0
                              ? Colors.grey.shade400 // disabled look
                              : AppWidget.primary_red_color(),
                        ),
                        child: Center(
                          child: Text(
                            selectedAmount == 0
                                ? 'Select Amount First'
                                : 'Add ₹$selectedAmount to Wallet',
                            style: AppWidget.white_text_field_style(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
    if (id == null) return;
    int amount = (options['amount'] as int) ~/ 100;

    try {
      // 🔹 ID se update — email ki zaroorat nahi
      await Database().updateUserWallet(amount.toString(), id!);
      // StreamBuilder khud refresh karega — manual setState nahi chahiye
      setState(() {
        selectedAmount = 0;
        options['amount'] = 0;
      });
      _showMessage('₹$amount added to wallet!', Colors.green);
    } catch (e) {
      _showMessage('Payment done but wallet update failed. Contact support.',
          Colors.orange);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showMessage('Payment failed. Please try again.', Colors.red);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showMessage('External wallet selected: ${response.walletName}',
        Colors.blue);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}