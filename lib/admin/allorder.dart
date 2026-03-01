import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/widget_support.dart';

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  Stream? orderstream;

  // Track which order is being marked delivered (loading state)
  final Set<String> _loadingOrders = {};

  @override
  void initState() {
    super.initState();
    _getOnTheLoad();
  }

  Future<void> _getOnTheLoad() async {
    orderstream = await Database().getAdminOrders();
    if (mounted) setState(() {});
  }

  Future<void> _markDelivered(DocumentSnapshot ds) async {
    final orderId = ds.id;
    if (_loadingOrders.contains(orderId)) return; // already processing

    setState(() => _loadingOrders.add(orderId));

    try {
      await Database().updateAdminOrder(orderId);
      await Database().updateUserOrder(ds['id'], orderId);
      // StreamBuilder khud update karega — koi setState nahi chahiye
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update order. Try again.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }

    if (mounted) setState(() => _loadingOrders.remove(orderId));
  }

  Widget _buildOrderList() {
    return StreamBuilder(
      stream: orderstream,
      builder: (context, AsyncSnapshot snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        // Error state
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong!',
                style: TextStyle(color: Colors.red.shade600)),
          );
        }

        final docs = snapshot.data.docs;

        // ── Empty State ──
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline_rounded,
                    size: 80, color: Colors.green.shade300),
                const SizedBox(height: 16),
                const Text(
                  'No Pending Orders!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'All orders have been delivered.',
                  style: TextStyle(fontSize: 14, color: Colors.black38),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = docs[index];
            final bool isLoading = _loadingOrders.contains(ds.id);

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: 3,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Address Row ──
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded,
                              color: AppWidget.primary_red_color(), size: 20),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              ds['address'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Status chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.orange.shade300),
                            ),
                            child: Text(
                              ds['status'] ?? 'Pending',
                              style: TextStyle(
                                color: Colors.orange.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 16),

                      // ── Food Info Row ──
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Food Image — asset with error fallback
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              ds['image'] ?? '',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.fastfood_rounded,
                                    color: Colors.grey.shade400, size: 40),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Order Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Food Name
                                Text(
                                  ds['foodName'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),

                                // Qty + Price
                                Row(
                                  children: [
                                    _InfoChip(
                                      icon: Icons.shopping_bag_outlined,
                                      label: 'x${ds['quantity']}',
                                      color: Colors.blue.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                    _InfoChip(
                                      icon: Icons.currency_rupee_rounded,
                                      label: ds['total_price'] ?? '0',
                                      color: Colors.green.shade600,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Customer Name
                                Row(
                                  children: [
                                    Icon(Icons.person_outline_rounded,
                                        color: AppWidget.primary_red_color(),
                                        size: 16),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        ds['name'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                // Email
                                Row(
                                  children: [
                                    Icon(Icons.email_outlined,
                                        color: AppWidget.primary_red_color(),
                                        size: 16),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        ds['email'] ?? 'N/A',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── Delivered Button ──
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isLoading
                                ? Colors.grey.shade300
                                : Colors.green.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isLoading ? null : () => _markDelivered(ds),
                          icon: isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.check_rounded, size: 20),
                          label: Text(
                            isLoading ? 'Updating...' : 'Mark as Delivered',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 52, bottom: 18, left: 16, right: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppWidget.primary_red_color(),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'Pending Orders',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ),
                ),
                const SizedBox(width: 36), // balance spacing
              ],
            ),
          ),

          // Body
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: _buildOrderList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Small reusable info chip
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}