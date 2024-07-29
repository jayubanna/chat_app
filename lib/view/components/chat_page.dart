import 'package:chat_app/helper/login_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/firestore_helper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        child: StreamBuilder(
          stream: FirestoreHelper.firestoreHelper.fetchAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("ERROR: ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              QuerySnapshot<Map<String, dynamic>>? querySnapshot =
                  snapshot.data;

              List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                  (querySnapshot != null) ? querySnapshot.docs : [];

              return (allDocs.isEmpty)
                  ? Center(
                      child: Text("No any users...."),
                    )
                  : ListView.builder(
                      itemCount: allDocs.length,
                      itemBuilder: (context, i) {
                        Timestamp timestamp = allDocs[i].data()["created_at"];

                        DateTime dateTime = timestamp.toDate();

                        return (allDocs[i].data()["email"] ==
                                LoginHelper.firebaseAuth.currentUser!.email)
                            ? Container()
                            : ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: Text(allDocs[i]
                                      .data()["email"][0]
                                      .toString()
                                      .toUpperCase()),
                                ),
                                title: Text("${allDocs[i].data()["email"]}"),
                                subtitle: Text(
                                    "${dateTime.day}-${dateTime.month}-${dateTime.year} | ${dateTime.hour}:${dateTime.minute}"),
                          onTap: () async {
                            String receiverEmail = allDocs[i].data()["email"];
                            await FirestoreHelper.firestoreHelper.createChatroom(
                              receiver_email: receiverEmail,
                            );
                            Get.toNamed("massge_page", arguments: receiverEmail);
                          },
                              );
                      },
                    );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
