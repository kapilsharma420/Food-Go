import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/share_pref.dart';
import 'package:hot_bite/service/widget_support.dart';



class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String? id;
  Stream<QuerySnapshot>? orderstream;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    id = await SharedPrefHelper().getUserId();
    if (id != null) {
      orderstream = await Database().getUserOrders(id!);
    }
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
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Cancel confirm dialog
  Future<void> _confirmCancel(
      String orderId, String amount, String foodName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: Colors.red),
            SizedBox(width: 8),
            Text('Cancel Order',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to cancel:',
                style: TextStyle(color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(foodName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.wallet, color: Colors.green.shade700, size: 18),
                  const SizedBox(width: 8),
                  Text('₹$amount will be refunded to wallet',
                      style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No, Keep',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Cancel',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Database().cancelOrder(id!, orderId, amount);
        _showMessage(
            '₹$amount refunded to your wallet!', Colors.green);
      } catch (e) {
        _showMessage('Failed to cancel. Try again.', Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 16),
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Text('My Orders',
                  style: AppWidget.onboarding_heading_textstyle()),
            ),
          ),

          // Orders list
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: id == null
                  ? const Center(child: CircularProgressIndicator(color: Colors.red))
                  : StreamBuilder<QuerySnapshot>(
                      stream: orderstream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.red));
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_bag_outlined,
                                    size: 80,
                                    color: Colors.grey.shade400),
                                const SizedBox(height: 16),
                                Text('No orders yet!',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 8),
                                Text('Order something delicious 🍕',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 14)),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 16, 12, 80),
                          physics: const BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot ds =
                                snapshot.data!.docs[index];
                            bool isPending = ds['status'] == 'Pending';

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.07),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Status bar at top
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isPending
                                          ? Colors.orange.shade50
                                          : Colors.green.shade50,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              isPending
                                                  ? Icons.access_time_rounded
                                                  : Icons.check_circle,
                                              color: isPending
                                                  ? Colors.orange
                                                  : Colors.green,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              ds['status'],
                                              style: TextStyle(
                                                color: isPending
                                                    ? Colors.orange.shade800
                                                    : Colors.green.shade800,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Order ID
                                        Text(
                                          '#${ds['order_id'].toString().substring(0, 6).toUpperCase()}',
                                          style: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Order details
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        // Food image
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: Image.asset(
                                            ds['image'],
                                            height: 90,
                                            width: 90,
                                            fit: BoxFit.cover,
                                            errorBuilder: (c, e, s) =>
                                                Container(
                                              height: 90,
                                              width: 90,
                                              color: Colors.grey.shade200,
                                              child: const Icon(
                                                  Icons.fastfood,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 14),

                                        // Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ds['foodName'],
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 16),
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),

                                              // Qty + Price row
                                              Row(
                                                children: [
                                                  _infoChip(
                                                      Icons.format_list_numbered,
                                                      'Qty: ${ds['quantity']}'),
                                                  const SizedBox(width: 10),
                                                  _infoChip(
                                                      Icons.currency_rupee,
                                                      ds['total_price']),
                                                ],
                                              ),
                                              const SizedBox(height: 6),

                                              // Address
                                              Row(
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.red
                                                          .shade300,
                                                      size: 14),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      ds['address'],
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey.shade600),
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Cancel button — only for Pending orders
                                  if (isPending)
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          12, 0, 12, 12),
                                      child: GestureDetector(
                                        onTap: () => _confirmCancel(
                                          ds.id,
                                          ds['total_price'],
                                          ds['foodName'],
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.red.shade300),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.red.shade50,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.cancel_outlined,
                                                  color: Colors.red.shade600,
                                                  size: 18),
                                              const SizedBox(width: 6),
                                              Text(
                                                'Cancel Order',
                                                style: TextStyle(
                                                    color: Colors.red.shade600,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppWidget.primary_red_color()),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}