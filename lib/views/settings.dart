import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:where_is_the_man/models/ad_creator.dart';
import 'package:get/get.dart';
import 'package:where_is_the_man/models/audio.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdCreator.initialize();
    return SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.blueAccent),
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
                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 50,),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Audio.snackbar();
                      Get.snackbar(
                          "Successfully Signed Out", "Have A Great Day :)",
                          backgroundColor: Colors.green,
                          colorText: Colors.black,
                          icon: const Icon(Icons.error_outline),
                          snackPosition: SnackPosition.BOTTOM
                      );
                      Audio.navigation();
                      Get.offAllNamed('/signin');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Sign Out"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      shape: const StadiumBorder(),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Audio.navigation();
                      Get.toNamed('/changepassword');
                    },
                    icon: const Icon(Icons.lock),
                    label: const Text("Change Account Password"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      shape: const StadiumBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
