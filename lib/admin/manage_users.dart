import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hot_bite/service/daatabase.dart';
import 'package:hot_bite/service/widget_support.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({super.key});

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  Stream? userstream;
  final Set<String> _processingUsers = {};

  @override
  void initState() {
    super.initState();
    _getOnTheLoad();
  }

  Future<void> _getOnTheLoad() async {
    userstream = await Database().getAllUsers();
    if (mounted) setState(() {});
  }

  Future<void> _confirmDisable(DocumentSnapshot ds) async {
    final bool isCurrentlyDisabled = ds['isDisabled'] ?? false;

    // Enable karne pe seedha karo — confirm nahi chahiye
    if (isCurrentlyDisabled) {
      await _toggleUser(ds, false);
      return;
    }

    // Disable karne pe confirm maango
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.block_rounded, color: Colors.orange.shade700),
            const SizedBox(width: 8),
            const Text('Disable User',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            children: [
              const TextSpan(text: 'Are you sure you want to disable '),
              TextSpan(
                text: ds['Name'] ?? 'this user',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                  text: '?\n\nThey will be blocked from logging in. You can re-enable them anytime.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Disable', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) await _toggleUser(ds, true);
  }

  Future<void> _toggleUser(DocumentSnapshot ds, bool disable) async {
    final userId = ds.id;
    setState(() => _processingUsers.add(userId));

    try {
      await Database().setUserDisabled(userId, disable);

      if (mounted) {
        final msg = disable
            ? '${ds['Name']} has been disabled.'
            : '${ds['Name']} has been re-enabled.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: disable ? Colors.orange.shade700 : Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed. Please try again.'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }

    if (mounted) setState(() => _processingUsers.remove(userId));
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: userstream,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!', style: TextStyle(color: Colors.red.shade600)));
        }

        final docs = snapshot.data.docs;

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline_rounded, size: 80, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No Users Found',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 8),
                const Text('No registered users yet.',
                    style: TextStyle(fontSize: 14, color: Colors.black38)),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = docs[index];
            final bool isProcessing = _processingUsers.contains(ds.id);
            final bool isDisabled = ds['isDisabled'] ?? false;

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDisabled ? Colors.grey.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: isDisabled ? Border.all(color: Colors.orange.shade200) : null,
                  ),
                  child: Row(
                    children: [
                      // Avatar — greyscale agar disabled
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDisabled ? Colors.orange.shade200 : Colors.red.shade100,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: ColorFiltered(
                                colorFilter: isDisabled
                                    ? const ColorFilter.matrix([
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0.2126, 0.7152, 0.0722, 0, 0,
                                        0,      0,      0,      1, 0,
                                      ])
                                    : const ColorFilter.matrix([
                                        1, 0, 0, 0, 0,
                                        0, 1, 0, 0, 0,
                                        0, 0, 1, 0, 0,
                                        0, 0, 0, 1, 0,
                                      ]),
                                child: Image.asset('images/user.png', height: 65, width: 65, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          if (isDisabled)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                child: Icon(Icons.block_rounded, color: Colors.orange.shade700, size: 16),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 14),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_outline_rounded, color: AppWidget.primary_red_color(), size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    ds['Name'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDisabled ? Colors.black38 : Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Disabled badge
                                if (isDisabled)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.orange.shade300),
                                    ),
                                    child: Text('Disabled',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.orange.shade700,
                                            fontWeight: FontWeight.w600)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.email_outlined, color: AppWidget.primary_red_color(), size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    ds['Email'] ?? 'N/A',
                                    style: TextStyle(fontSize: 12, color: isDisabled ? Colors.black26 : Colors.black54),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.wallet_rounded, color: Colors.green.shade600, size: 16),
                                const SizedBox(width: 6),
                                Text(
                                  '₹${ds['Wallet'] ?? '0'}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDisabled ? Colors.black26 : Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Disable / Enable Button
                      GestureDetector(
                        onTap: isProcessing ? null : () => _confirmDisable(ds),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isProcessing
                                ? Colors.grey.shade100
                                : isDisabled
                                    ? Colors.green.shade50
                                    : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isProcessing
                                  ? Colors.grey.shade300
                                  : isDisabled
                                      ? Colors.green.shade300
                                      : Colors.orange.shade300,
                            ),
                          ),
                          child: isProcessing
                              ? SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.orange.shade400),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isDisabled ? Icons.check_circle_outline_rounded : Icons.block_rounded,
                                      size: 15,
                                      color: isDisabled ? Colors.green.shade700 : Colors.orange.shade700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isDisabled ? 'Enable' : 'Disable',
                                      style: TextStyle(
                                        color: isDisabled ? Colors.green.shade700 : Colors.orange.shade700,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
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
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                  ),
                ),
                const Expanded(
                  child: Center(
                    child: Text('Manage Users',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
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
              child: _buildUserList(),
            ),
          ),
        ],
      ),
    );
  }
}