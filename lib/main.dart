import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrscanner/app/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      title: "SCAN QR",
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
    ),
  );
}
