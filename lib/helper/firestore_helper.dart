import 'dart:developer';

import 'package:chat_app/helper/login_helper.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> insertUser({required UserModel userModel}) async {
    try {
      DocumentReference<Map<String, dynamic>> userDocRef =
      db.collection("users").doc(userModel.email);

      await userDocRef.set({
        "email": userModel.email,
        "auth_uid": userModel.auth_uid,
        "created_at": userModel.created_at,
        "logged_in_at": DateTime.now(),
      }, SetOptions(merge: true));

      DocumentReference<Map<String, dynamic>> recordsDocRef =
      db.collection("records").doc("users");

      DocumentSnapshot<Map<String, dynamic>> recordsDocSnapshot =
      await recordsDocRef.get();

      Map<String, dynamic>? recordsData = recordsDocSnapshot.data();

      int id = 0;
      int counter = 0;

      if (recordsData != null) {
        id = recordsData["id"] ?? 0;
        counter = recordsData["counter"] ?? 0;
      } else {
        await recordsDocRef.set({"id": 0, "counter": 0});
      }

      await recordsDocRef.update({"id": id, "counter": counter + 1});
    } catch (e) {
      log("Error inserting user: $e");
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return db.collection("users").snapshots();
  }
  Future<void> createChatroom({required String receiver_email}) async {
    await db.collection("chatrooms").doc(receiver_email).set({
      "users": [receiver_email, LoginHelper.firebaseAuth.currentUser!.email]
    });
  }

  Future<void> sendMessage(
      {required String receiver_email, required String msg}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
    await db.collection("chatrooms").get();

    List<dynamic> users = [];
    String docId = "";

    querySnapshots.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      users = doc.data()?["users"] ?? [];
      if (users.contains(receiver_email) &&
          users.contains(LoginHelper.firebaseAuth.currentUser!.email)) {
        docId = doc.id;
      }
    });

    await db.collection("chatrooms").doc(docId).collection("chat").add({
      "msg": msg,
      "sent_by": LoginHelper.firebaseAuth.currentUser!.email,
      "received_by": docId,
      "timestamp": DateTime.now(),
    });
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchMessages(
      {required String receiver_email}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshots =
    await db.collection("chatrooms").get();

    String docId = "";

    querySnapshots.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
      List<dynamic> users = doc.data()?["users"] ?? [];
      if (users.contains(receiver_email) &&
          users.contains(LoginHelper.firebaseAuth.currentUser!.email)) {
        docId = doc.id;
      }
    });

    if (docId.isNotEmpty) {
      return db
          .collection("chatrooms")
          .doc(docId)
          .collection("chat")
          .orderBy("timestamp", descending: true)
          .snapshots();
    } else {
      print("No chatroom found for the given users");
      return Stream.empty();
    }
  }
}