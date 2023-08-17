import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:where_is_the_man/models/ad_creator.dart';
import 'package:where_is_the_man/models/audio.dart';
import 'package:where_is_the_man/models/periodic_timer.dart';

class ActivationInformation extends StatelessWidget {
  const ActivationInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AdCreator.initialize();
    PeriodicTimer.ait();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Audio.navigation();
                Get.toNamed('/settings');
                PeriodicTimer.aiTimer?.cancel();
              },
              color: Colors.blueAccent,
            ),
          ],
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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Center(
                  child: Text(
                    "Hey There!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Text(
                  "You have been redirected to this page because your account has not been activated."
                      "\nOur admins will activate your account as soon as possible, "
                      "you will receive an email with instructions when your account is activated",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
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
