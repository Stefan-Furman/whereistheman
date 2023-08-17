import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:where_is_the_man/models/audio.dart';
import 'package:where_is_the_man/models/check_update.dart';

class PeriodicTimer{
  static User? user = FirebaseAuth.instance.currentUser;
  static final player = AudioCache();
  static Timer? mmTimer;
  static Timer? aiTimer;

  static void mmt() {
    mmTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      user = FirebaseAuth.instance.currentUser;
      user?.reload();
      if (user == null) {
        timer.cancel();
        Audio.snackbar();
        Audio.navigation();
        Get.offAllNamed('/signin');
        Get.snackbar(
            "YOU HAVE BEEN BANNED", "If you would like appeal this decision, you can speak with an admin",
            backgroundColor: Colors.red[800],
            colorText: Colors.black,
            icon: const Icon(Icons.error_outline),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(days: 365)
        );
      }
      if (await CheckUpdate.checkUpdate()) {
        timer.cancel();
        Audio.snackbar();
        Get.offAllNamed('/signin');
        Get.snackbar(
          "Your App Needs Update", "Please update your app before you sign in again",
          backgroundColor: Colors.red[800],
          colorText: Colors.black,
          icon: const Icon(Icons.error_outline),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  static void ait() {
    aiTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      user = FirebaseAuth.instance.currentUser;
      user?.reload();
      if (user == null) {
        timer.cancel();
        Audio.snackbar();
        Get.offAllNamed('/signin');
        Get.snackbar(
            "Congratulations, Your Account Has Been Activated!", "Please follow the instructions sent to you by email",
            backgroundColor: Colors.green,
            colorText: Colors.black,
            icon: const Icon(Icons.error_outline),
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(days: 365)
        );
      }
      if (await CheckUpdate.checkUpdate()) {
        timer.cancel();
        Audio.snackbar();
        Audio.navigation();
        Get.offAllNamed('/signin');
        Get.snackbar(
          "Your App Needs Update", "Please update your app before you sign in again",
          backgroundColor: Colors.red[800],
          colorText: Colors.black,
          icon: const Icon(Icons.error_outline),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }
}