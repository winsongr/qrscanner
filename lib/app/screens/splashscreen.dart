import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/app/screens/home.dart';
import 'package:qrscanner/app/res/custom_colors.dart';
import 'package:qrscanner/app/screens/sign_in_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String id = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var colorizeTextStyle = const TextStyle(fontSize: 30.0, fontFamily: 'Lato');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      if (user != null) {
        Get.offAll(Home(
          user: user!,
        ));
      } else {
        Get.offAll(SignInScreen());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.baseNavy,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * 0.2,
              child: Image.asset(
                'assets/icon.png',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'QRSCANNER',
              style: TextStyle(
                color: CustomColors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Made With ❤️ WD',
              style: TextStyle(
                color: CustomColors.baseOrange,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
