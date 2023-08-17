import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:where_is_the_man/models/ad_creator.dart';
import 'package:get/get.dart';
import 'package:where_is_the_man/models/audio.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String password = "";
    String password2 = "";
    User? user = FirebaseAuth.instance.currentUser;
    AdCreator.initialize();
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.blueAccent),
            elevation: 0,
            centerTitle: true,
            title: const Text("Where's The Man?", style: TextStyle(color: Colors.black),),
            backgroundColor: Colors.yellow,
          ),
          bottomNavigationBar: SizedBox(
            height: 50,
            child: AdWidget(ad: AdCreator.getBannerAd()..load(),),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 50,),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Enter password"
                        ),
                        maxLength: 40,
                        obscureText: true,
                        onChanged: (newText) => password = newText,
                      ),
                      const SizedBox(height: 50,),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Enter password again"
                        ),
                        maxLength: 40,
                        obscureText: true,
                        onChanged: (newText) => password2 = newText,
                      ),
                      const SizedBox(height: 50,),
                      SizedBox(
                        width: 175,
                        height: 70,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Get.closeCurrentSnackbar();
                            Audio.snackbar();
                            if (password == password2) {
                              try {
                                await user!.updatePassword(password);
                                Get.snackbar(
                                    "Successfully Changed Password", "Please sign in again",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.black,
                                    icon: const Icon(Icons.error_outline),
                                    snackPosition: SnackPosition.BOTTOM
                                );
                                Audio.navigation();
                                Get.offAllNamed('/signin');
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'requires-recent-login') {
                                  Get.snackbar(
                                    "Signed In Too Long Ago", "Please sign out and sign in again to change password",
                                    backgroundColor: Colors.red[800],
                                    colorText: Colors.black,
                                    icon: const Icon(Icons.error_outline),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } else {
                                  Get.snackbar(
                                    e.code, "If you are still having issues please notify an admin",
                                    backgroundColor: Colors.red[800],
                                    colorText: Colors.black,
                                    icon: const Icon(Icons.error_outline),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              }
                            }
                            else if (password != password2) {
                              Get.snackbar(
                                "Your passwords do not match", "Please re-enter your passwords and make sure that they are correct",
                                backgroundColor: Colors.red[800],
                                colorText: Colors.black,
                                icon: const Icon(Icons.error_outline),
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          label: const Icon(Icons.lock_open),
                          icon: const Text("Change Password"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
