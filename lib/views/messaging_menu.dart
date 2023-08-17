import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:where_is_the_man/models/audio.dart';
import 'package:where_is_the_man/models/periodic_timer.dart';

class Messaging extends StatelessWidget {
  const Messaging({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = "";
    User? user = FirebaseAuth.instance.currentUser;
    PeriodicTimer.mmt();
    final nameHolder = TextEditingController();
    final DateFormat formatterHm = DateFormat('Hm');
    int coolDown = 0;
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            actions: <Widget>[
              IconButton(
                color: Colors.blueAccent,
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Audio.navigation();
                  Get.toNamed('/settings');
                  PeriodicTimer.mmTimer?.cancel();
                },
              ),
            ],
            title: const Text("Where's The Man?", style: TextStyle(color: Colors.black),),
            centerTitle: true,
            backgroundColor: Colors.yellow,
          ),
          body: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('messages').orderBy('timestamp').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Uh Oh... Something Went Wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }

                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        String formattedDate = formatterHm.format((data['timestamp'] as Timestamp).toDate()).toString();

                        //check if 15 minutes have passed
                        if (DateTime.now().millisecondsSinceEpoch ~/ 1000 >= data['cutofftime']) FirebaseFirestore.instance.collection('messages').doc(document.id).delete();

                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            data['user'] == user?.uid.toString() ? 64.0 : 16.0,
                            4,
                            data['user'] == user?.uid.toString() ? 16.0 : 64.0,
                            4,
                          ),
                          child: Align(
                            // align the child within the container
                            alignment: data['user'] == user?.uid.toString() ? Alignment.centerRight : Alignment.centerLeft,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: data['user'] == user?.uid.toString() ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  "${data['message']}   $formattedDate",
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                      color: data['user'] == user?.uid.toString() ? Colors.white : Colors.black87),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.black,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        controller: nameHolder,
                        decoration: const InputDecoration(
                          hintText: "Where is the man?",
                          border: OutlineInputBorder(),
                        ),
                        maxLength: 40,
                        onChanged: (newText) => message = newText,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      Get.closeCurrentSnackbar();
                      final ConnectivityResult result = await Connectivity().checkConnectivity();
                      if (result != ConnectivityResult.none) {
                        if (coolDown == 0 || DateTime.now().millisecondsSinceEpoch ~/ 1000 - coolDown > 30) {
                          try {
                            if (message != "") {
                              FirebaseFirestore.instance.collection('messages').add({"message":message, "user":user?.uid.toString(), "timestamp":Timestamp.fromDate(DateTime.now()), "cutofftime":DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900});
                              Audio.message();
                              coolDown = DateTime.now().millisecondsSinceEpoch ~/ 1000;
                            }
                          } on FirebaseAuthException catch (e) {
                            Audio.snackbar();
                            Get.snackbar(
                                e.code, "If you are still having issues please notify an admin",
                                backgroundColor: Colors.red[800],
                                colorText: Colors.black,
                                icon: const Icon(Icons.error_outline),
                                snackPosition: SnackPosition.BOTTOM
                            );
                          }
                        } else {
                          Audio.snackbar();
                          Get.snackbar(
                              "Cool Down Activated", "Please wait ${30 - (DateTime.now().millisecondsSinceEpoch ~/ 1000 - coolDown)} seconds before you send a message",
                              backgroundColor: Colors.red[800],
                              colorText: Colors.black,
                              icon: const Icon(Icons.error_outline),
                              snackPosition: SnackPosition.BOTTOM
                          );
                        }
                      } else {
                        Audio.snackbar();
                        Get.snackbar(
                            "No Internet Connection", "Please get a stable internet connection before you send a message",
                            backgroundColor: Colors.red[800],
                            colorText: Colors.black,
                            icon: const Icon(Icons.error_outline),
                            snackPosition: SnackPosition.BOTTOM
                        );
                      }
                      nameHolder.clear();
                      message = "";
                    },
                    icon: const Icon(Icons.send),
                    color: Colors.blueAccent,
                  )
                ],
              ),
            ],
          ),
        ),
    );
  }
}
