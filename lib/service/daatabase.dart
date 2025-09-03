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
    return await FirebaseFirestore.instance
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

 Future updateUserWallet(String addAmount, String id) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(id).get();

  int currentWallet = int.tryParse(userDoc["Wallet"].toString()) ?? 0;
  int newWallet = currentWallet + int.parse(addAmount);

  return await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .update({'Wallet': newWallet.toString()});
}

Future deductUserWallet(String amount, String id) async {
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("users").doc(id).get();

  int currentWallet = int.tryParse(userDoc["Wallet"].toString()) ?? 0;
  int newWallet = currentWallet - int.parse(amount);

  return await FirebaseFirestore.instance
      .collection("users")
      .doc(id)
      .update({'Wallet': newWallet.toString()});
}

Future<DocumentSnapshot> getUserWalletById(String id) async {
  return await FirebaseFirestore.instance.collection("users").doc(id).get();
}


}
