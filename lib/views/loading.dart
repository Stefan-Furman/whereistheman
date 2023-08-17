import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:where_is_the_man/models/audio.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  void init() async {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    Audio.init();
    User? user = FirebaseAuth.instance.currentUser;
    String nextPage = user == null ?
    '/signup' : user.email!.startsWith('notvalidated') ? '/activationinformation' : '/messaging';
    Get.offAllNamed(nextPage);
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/man.jpg'),
                const SizedBox(height: 50,),
                const SpinKitThreeBounce(
                  color: Colors.blueAccent,
                  size: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
