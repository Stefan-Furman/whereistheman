import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:where_is_the_man/models/ad_creator.dart';
import 'package:get/get.dart';
import 'package:where_is_the_man/models/audio.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String email = "";
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
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
                      "Reset Password",
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
                          hintText: "Enter email"
                      ),
                      maxLength: 40,
                      onChanged: (newText) => email = newText.trim(),
                    ),
                    const SizedBox(height: 50,),
                    SizedBox(
                      width: 150,
                      height: 70,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Get.closeCurrentSnackbar();
                          Audio.snackbar();
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                            Get.snackbar(
                                "Successfully Sent Password Reset Email", "Check your email address to reset your password",
                                backgroundColor: Colors.green,
                                colorText: Colors.black,
                                icon: const Icon(Icons.error_outline),
                                snackPosition: SnackPosition.BOTTOM
                            );
                            Audio.navigation();
                            Get.offAllNamed('/signin');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: "NOTVALIDATED$email");
                                Get.snackbar(
                                    "User not validated", "You cannot receive a password reset email if your account is not activated",
                                    backgroundColor: Colors.red[800],
                                    colorText: Colors.black,
                                    icon: const Icon(Icons.error_outline),
                                    snackPosition: SnackPosition.BOTTOM,
                                    duration: const Duration(seconds: 6),
                                );
                                Audio.navigation();
                                Get.offAllNamed('/signin');
                              } on FirebaseAuthException catch (e) {
                                Get.snackbar(
                                  e.code, "If you are still having issues please notify an admin",
                                  backgroundColor: Colors.red[800],
                                  colorText: Colors.black,
                                  icon: const Icon(Icons.error_outline),
                                  snackPosition: SnackPosition.BOTTOM,
                                  duration: const Duration(seconds: 6),
                                );
                              }
                            } else {
                              Get.snackbar(
                                e.code, "If you are still having issues please notify an admin",
                                backgroundColor: Colors.red[800],
                                colorText: Colors.black,
                                icon: const Icon(Icons.error_outline),
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 6),
                              );
                            }
                          }
                        },
                        label: const Icon(Icons.email),
                        icon: const Text("Send Email"),
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
      ),
    );
  }
}
