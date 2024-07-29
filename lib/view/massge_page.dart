import 'dart:developer';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:chat_app/helper/local_notifications.dart';
import 'package:chat_app/helper/login_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/home_controller.dart';
import '../helper/fcm_helper.dart';
import '../helper/firestore_helper.dart';

class MassgePage extends StatefulWidget {
  HomeController controller = Get.put(HomeController());

  MassgePage({super.key});

  @override
  State<MassgePage> createState() => _MassgePageState();
}

class _MassgePageState extends State<MassgePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController chatController = TextEditingController();
  AssetsAudioPlayer audio = AssetsAudioPlayer();

  Future<void> fetchFCMToken() async {
    String? token = await FCMHelper.fcmHelper.getFCMToken();

    log("==================");
    print("$token");
    log("==================");
  }

  @override
  void initState() {
    super.initState();
    fetchFCMToken();
    handleFCMNotificationsInteraction();

  }

  Future handleFCMNotificationsInteraction() async {
    RemoteMessage? remoteMessage =
        await FCMHelper.firebaseMessaging.getInitialMessage();

    if (remoteMessage != null) {
      print("==============");
      print("${remoteMessage.notification!.title}");
      print("${remoteMessage.notification!.body}");
      print("${remoteMessage.data['']}");
      print("==============");
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      print("==============");
      print("${remoteMessage.notification!.title}");
      print("${remoteMessage.notification!.body}");
      print("${remoteMessage.data['']}");
      print("==============");
    });
  }

  @override
  Widget build(BuildContext context) {
    String receiver_email = ModalRoute.of(context)!.settings.arguments as String;
    

    return Scaffold(
      appBar: AppBar(
        leadingWidth: double.infinity,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
              ),
            ),
            CircleAvatar(
              radius: 20,
              child: Text("${receiver_email}"[0]
                  .toString()
                  .toUpperCase()),
            ),
            SizedBox(width: 8,),
            Text("${receiver_email}",style: TextStyle(fontSize: 13),),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
              flex: 16,
              child: FutureBuilder(
                future: FirestoreHelper.firestoreHelper
                    .fetchMessages(receiver_email: receiver_email),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("ERROR: ${snapshot.error}"),
                    );
                  } else {
                    return StreamBuilder(
                      stream: snapshot.data,
                      builder: (context, ss) {
                        if (ss.hasError) {
                          return Center(
                            child: Text("ERROR: ${ss.error}"),
                          );
                        } else if (ss.hasData) {
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              allDocs = (ss.data == null) ? [] : ss.data!.docs;

                          return ListView.builder(
                            reverse: true,
                            itemCount: allDocs.length,
                            itemBuilder: (context, i) {
                              return Row(
                                mainAxisAlignment:
                                    (allDocs[i].data()["sent_by"] ==
                                            LoginHelper
                                                .firebaseAuth.currentUser!.email)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CupertinoContextMenu(
                                        actions: [
                                          CupertinoContextMenuAction(
                                            child: Text("Update"),
                                            onPressed: () {},
                                          ),
                                          CupertinoContextMenuAction(
                                              child: Text("Delete"),
                                              isDestructiveAction: true,
                                              onPressed: () {}),
                                        ],
                                        child: Material(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: widget.controller
                                                          .isDark.value
                                                      ? Colors.white
                                                      : Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                                "${allDocs[i].data()["msg"]}"),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        DateFormat.jm().format((allDocs[i].data()["timestamp"] as Timestamp).toDate()),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        hintText: "Enter your msg...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () async {
                      if (chatController.text.toString().isNotEmpty) {
                        String message = chatController.text;
                        await FirestoreHelper.firestoreHelper.sendMessage(
                          receiver_email: receiver_email,
                          msg: message,
                        );
                        await audio.open(Audio("assets/massage.mp3"));
                        chatController.clear();
                        LocalNotifications.localNotifications.showSimpleNotification(
                          title: "New Message",
                          body: message,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a message")),
                        );
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
