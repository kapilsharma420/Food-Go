import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:hot_bite/service/widget_support.dart';
import 'package:random_string/random_string.dart';

class DetailPage extends StatefulWidget {
  final String image, name, price;
  const DetailPage(
      {required this.image, required this.name, required this.price, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  int totalprice = 0;
  bool isOrdering = false;

  TextEditingController addresscontroller = TextEditingController();
  String? name, id, email;

  @override
  void initState() {
    super.initState();
    totalprice = int.parse(widget.price);
    _loadSharedPref();
  }

  Future<void> _loadSharedPref() async {
    name = await SharedPrefHelper().getUserName();
    id = await SharedPrefHelper().getUserId();
    email = await SharedPrefHelper().getUserEmail();
    final savedAddress = await SharedPrefHelper().getUserAddress();
    if (savedAddress != null) addresscontroller.text = savedAddress;
    if (mounted) setState(() {});
  }

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

  Future<void> _placeOrder() async {
    if (addresscontroller.text.trim().isEmpty) {
      _openAddressDialog();
      return;
    }
    if (id == null || email == null) {
      _showMessage('User session expired. Please login again.', Colors.red);
      return;
    }

    setState(() => isOrdering = true);

    try {
      DocumentSnapshot userDoc = await Database().getUserWalletById(id!);
      int currentWallet = int.tryParse(userDoc["Wallet"].toString()) ?? 0;

      if (currentWallet < totalprice) {
        setState(() => isOrdering = false);
        _showMessage('Insufficient balance! Add money to wallet first.', Colors.red);
        return;
      }

      await Database().deductUserWallet(totalprice.toString(), id!);

      String orderid = randomAlphaNumeric(10);
      Map<String, dynamic> userOrderMap = {
        "name": name,
        "id": id,
        "quantity": quantity.toString(),
        "email": email,
        "total_price": totalprice.toString(),
        "foodName": widget.name,
        "image": widget.image,
        "status": "Pending",
        "order_id": orderid,
        "address": addresscontroller.text.trim(),
      };

      await Database().addUserOrderDetails(userOrderMap, id!, orderid);
      await Database().addAdminOrderDetails(userOrderMap, orderid);

      DocumentSnapshot updatedDoc = await Database().getUserWalletById(id!);
      String updatedWallet = updatedDoc["Wallet"].toString();

      if (!mounted) return;
      setState(() => isOrdering = false);
      _showMessage('Order placed! Remaining balance: ₹$updatedWallet', Colors.green);

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => isOrdering = false);
      _showMessage('Something went wrong. Please try again.', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isOrdering,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ── Main scrollable content ──
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Hero image as sliver app bar ──
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () {
                      if (!isOrdering) Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8)
                        ],
                      ),
                      child: Icon(Icons.arrow_back,
                          color: AppWidget.primary_red_color()),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Food image
                        Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: Colors.grey.shade100,
                            child: Icon(Icons.fastfood,
                                size: 80, color: Colors.grey.shade400),
                          ),
                        ),
                        // Bottom fade
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.white,
                                  Colors.white.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Content ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Price row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.name,
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppWidget.primary_red_color(),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '₹${widget.price}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Description
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Text(
                            "Enjoy the perfect blend of taste and quality with every bite. Prepared fresh with premium ingredients to satisfy your cravings. Ideal for quick snacks or hearty meals, this delicious treat brings flavor and comfort together. A must-try for food lovers!",
                            style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey.shade600,
                                height: 1.6),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Address chip
                        GestureDetector(
                          onTap: _openAddressDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: addresscontroller.text.isEmpty
                                  ? Colors.orange.shade50
                                  : Colors.green.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: addresscontroller.text.isEmpty
                                    ? Colors.orange.shade200
                                    : Colors.green.shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: addresscontroller.text.isEmpty
                                      ? Colors.orange.shade600
                                      : Colors.green.shade600,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    addresscontroller.text.isEmpty
                                        ? 'Tap to add delivery address'
                                        : addresscontroller.text,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: addresscontroller.text.isEmpty
                                          ? Colors.orange.shade700
                                          : Colors.green.shade700,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.edit,
                                    size: 16,
                                    color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Quantity label
                        const Text('Quantity',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),

                        // Quantity controls — styled
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _qtyButton(Icons.remove, () {
                                if (!isOrdering && quantity > 1)
                                  setState(() {
                                    quantity--;
                                    totalprice -= int.parse(widget.price);
                                  });
                              }),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              _qtyButton(Icons.add, () {
                                if (!isOrdering)
                                  setState(() {
                                    quantity++;
                                    totalprice += int.parse(widget.price);
                                  });
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Bottom sticky bar — Total + Order Now ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -5))
                  ],
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28)),
                ),
                child: Row(
                  children: [
                    // Total price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Total',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500)),
                        Text(
                          '₹$totalprice',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppWidget.primary_red_color()),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    // Order button
                    Expanded(
                      child: GestureDetector(
                        onTap: isOrdering ? null : _placeOrder,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 54,
                          decoration: BoxDecoration(
                            color: isOrdering
                                ? Colors.grey.shade500
                                : Colors.black,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isOrdering
                                ? []
                                : [
                                    BoxShadow(
                                        color: Colors.black38,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4))
                                  ],
                          ),
                          child: Center(
                            child: isOrdering
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                        color: Colors.white, strokeWidth: 2.5),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.shopping_bag_outlined,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text('ORDER NOW',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              letterSpacing: 0.5)),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Full screen ordering overlay ──
            if (isOrdering)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text('Placing your order...',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppWidget.primary_red_color(),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.red.shade200,
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Future<void> _openAddressDialog() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.location_on, color: Color(0xff008080)),
            SizedBox(width: 8),
            Text('Delivery Address',
                style: TextStyle(
                    color: Color(0xff008080),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter your delivery address',
                  style: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: addresscontroller,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'e.g. 123 Main St, Delhi',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff008080),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    if (addresscontroller.text.trim().isEmpty) return;
                    await SharedPrefHelper()
                        .saveUserAddress(addresscontroller.text.trim());
                    if (mounted) {
                      Navigator.pop(ctx);
                      setState(() {}); // address chip update karo
                      _showMessage(
                          'Address saved! Now place your order.', Colors.green);
                    }
                  },
                  child: const Text('Save Address',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    addresscontroller.dispose();
    super.dispose();
  }
}