import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:where_is_the_man/models/ad_creator.dart';
import 'package:where_is_the_man/models/audio.dart';
import 'package:where_is_the_man/models/check_update.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";
    String password2 = "";
    AdCreator.initialize();
    AdCreator.createInterstitialAd();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Where's The Man?", style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.yellow,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "Sign Up",
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
                      width: 150,
                      height: 70,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Get.closeCurrentSnackbar();
                          Audio.snackbar();
                          if (password == password2) {
                            try {
                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: "NOTVALIDATED$email", password: password
                              );
                              AdCreator.showInterstitialAd();
                              Audio.navigation();
                              Get.offAllNamed('/activationinformation');
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                Get.snackbar(
                                  "Password is too weak", "Please choose a new password",
                                  backgroundColor: Colors.red[800],
                                  colorText: Colors.black,
                                  icon: const Icon(Icons.error_outline),
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else if (e.code == 'email-already-in-use') {
                                Get.snackbar(
                                    "Email is already in use", "Please choose a new email or sign in",
                                    backgroundColor: Colors.red[800],
                                    colorText: Colors.black,
                                    icon: const Icon(Icons.error_outline),
                                    snackPosition: SnackPosition.BOTTOM
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
                              "Your passwords do not match",
                              "Please re-enter your passwords and make sure that they are correct",
                              backgroundColor: Colors.red[800],
                              colorText: Colors.black,
                              icon: const Icon(Icons.error_outline),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        label: const Icon(Icons.arrow_forward_rounded),
                        icon: const Text("Sign Up"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?   "),
                    InkWell(
                      onTap: () {
                        Audio.navigation();
                        Get.offAllNamed('/signin');
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    )
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
