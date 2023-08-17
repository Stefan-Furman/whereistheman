import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:where_is_the_man/models/ad_creator.dart';
import 'package:where_is_the_man/models/audio.dart';
import 'package:where_is_the_man/models/check_update.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = "";
    String password = "";
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
                      "Sign In",
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
                    SizedBox(
                      width: 150,
                      height: 70,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          Get.closeCurrentSnackbar();
                          Audio.snackbar();
                          try {
                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            AdCreator.showInterstitialAd();
                            Audio.navigation();
                            Get.offAllNamed('/messaging');
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              try {
                                await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: "NOTVALIDATED" + email,
                                  password: password,
                                );
                                AdCreator.showInterstitialAd();
                                Audio.navigation();
                                Get.offAllNamed('/activationinformation');
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  Get.snackbar(
                                      "User not found", "We could not find a user with that email address",
                                      backgroundColor: Colors.red[800],
                                      colorText: Colors.black,
                                      icon: const Icon(Icons.error_outline),
                                      snackPosition: SnackPosition.BOTTOM
                                  );
                                } else if (e.code == 'wrong-password') {
                                  Get.snackbar(
                                      "Incorrect password", "Please try again",
                                      backgroundColor: Colors.red[800],
                                      colorText: Colors.black,
                                      icon: const Icon(Icons.error_outline),
                                      snackPosition: SnackPosition.BOTTOM
                                  );
                                }
                              }
                            } else if (e.code == 'wrong-password') {
                              Get.snackbar(
                                  "Incorrect password", "Please try again",
                                  backgroundColor: Colors.red[800],
                                  colorText: Colors.black,
                                  icon: const Icon(Icons.error_outline),
                                  snackPosition: SnackPosition.BOTTOM
                              );
                            } else if (e.code == 'user-disabled') {
                              Get.snackbar(
                                "This account has been banned", "If you would like appeal this decision, you can speak with an admin",
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
                                  snackPosition: SnackPosition.BOTTOM
                              );
                            }
                          }
                        },
                        label: const Icon(Icons.arrow_forward_rounded),
                        icon: const Text("Sign In"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?   "),
                        InkWell(
                          onTap: () {
                            Audio.navigation();
                            Get.offAllNamed('/signup');
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Forgot your password?   "),
                        InkWell(
                          onTap: () {
                            Audio.navigation();
                            Get.toNamed('/resetpassword');
                          },
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ],
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
