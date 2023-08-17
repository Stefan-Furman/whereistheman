import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:where_is_the_man/views/activation_information.dart';
import 'package:where_is_the_man/views/change_password.dart';
import 'package:where_is_the_man/views/loading.dart';
import 'package:where_is_the_man/views/messaging_menu.dart';
import 'package:where_is_the_man/views/reset_password.dart';
import 'package:where_is_the_man/views/settings.dart';
import 'package:where_is_the_man/views/sign_in.dart';
import 'package:where_is_the_man/views/sign_up.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/loading',
      getPages: [
        GetPage(name: '/signup', page: () => const SignUp()),
        GetPage(name: '/signin', page: () => const SignIn()),
        GetPage(name: '/activationinformation', page: () => const ActivationInformation()),
        GetPage(name: '/messaging', page: () => const Messaging()),
        GetPage(name: '/settings', page: () => const Settings()),
        GetPage(name: '/resetpassword', page: () => const ResetPassword()),
        GetPage(name: '/changepassword', page: () => const ChangePassword()),
        GetPage(name: '/loading', page: () => const Loading()),
      ],
    );
  }
}
