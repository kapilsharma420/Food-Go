import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserOrderDetails(
    Map<String, dynamic> userOrderMap,
    String id,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection('orders')
        .doc(orderId)
        .set(userOrderMap);
  }

  Future addAdminOrderDetails(
    Map<String, dynamic> userOrderMap,
    String orderId,
  ) async {
    return await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .set(userOrderMap);
  }

  Future<Stream<QuerySnapshot>> getUserOrders(String userId) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("orders")
        .snapshots();
  }

  Future<QuerySnapshot> getUserWallet(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("Email", isEqualTo: email)
        .get();
  }

  Future<DocumentSnapshot> getUserWalletById(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get();
  }

  // Real-time wallet stream by ID
  Stream<DocumentSnapshot> getWalletStream(String id) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .snapshots();
  }

  Future updateUserWallet(String addAmount, String id) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get();

    int currentWallet = int.tryParse(userDoc["Wallet"].toString()) ?? 0;
    int newWallet = currentWallet + int.parse(addAmount);

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'Wallet': newWallet.toString()});
  }

  Future deductUserWallet(String amount, String id) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get();

    int currentWallet = int.tryParse(userDoc["Wallet"].toString()) ?? 0;
    int newWallet = currentWallet - int.parse(amount);
    if (newWallet < 0) newWallet = 0;

    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({'Wallet': newWallet.toString()});
  }

  // Cancel order — dono collections se delete + wallet refund
  Future<void> cancelOrder(String userId, String orderId, String amount) async {
    // User ki orders subcollection se delete
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("orders")
        .doc(orderId)
        .delete();

    // Admin orders collection se delete
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .delete();

    // Wallet mein amount refund
    await updateUserWallet(amount, userId);
  }

  Future<Stream<QuerySnapshot>> getAdminOrders() async {
    return FirebaseFirestore.instance
        .collection("orders")
        .where("status", isEqualTo: 'Pending')
        .snapshots();
  }

  Future updateAdminOrder(String docid) async {
    return await FirebaseFirestore.instance
        .collection("orders")
        .doc(docid)
        .update({"status": "Delivered"});
  }

  Future updateUserOrder(String userId, String orderDocId) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection('orders')
        .doc(orderDocId)
        .update({'status': 'Delivered'});
  }

  Future<Stream<QuerySnapshot>> getAllUsers() async {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }

  Future deleteUser(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .delete();
  }
  Future setUserDisabled(String id, bool disabled) async {
  return await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .update({'isDisabled': disabled});
}
}