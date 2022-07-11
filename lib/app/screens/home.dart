import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:qrscanner/app/screens/webview.dart';

import '../res/custom_colors.dart';
import 'sign_in_screen.dart';
import '../utils/authentication.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late User _user;
  bool isSigningOut = false;

  var qrstr = "";
  var hiegh, widt;

  void _handleURLButtonPress(String url, String title) {
    Get.to(WebViewPage(url, title));
  }

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }

  Widget build(BuildContext context) {
    String username = _user.displayName!;
    widt = MediaQuery.of(context).size.width;
    hiegh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: CustomColors.baseNavy,
      appBar: AppBar(
        title: Text(
          'Hi ❤️ $username ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: CustomColors.baseOrange,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  setState(() {
                    isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    isSigningOut = false;
                  });
                  Get.offAll(SignInScreen());
                },
                height: 20,
                child: SizedBox(
                  width: Get.width * 0.25,
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      Text(
                        "Sign Out",
                        style: TextStyle(color: CustomColors.black),
                      )
                    ],
                  ),
                ),
              ),
            ],
            offset: Offset(0, 50),
            color: Colors.white,
            elevation: 1,
          ),
        ],
        leading: _user.photoURL != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    _user.photoURL!,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  child: Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.2,
              ),
              Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15.0,
                      offset: Offset(0.0, 0.75))
                ]),
                height: 100,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code,
                      size: 50,
                      color: CustomColors.baseYellow,
                    ),
                    Text(
                      'Scan QR',
                      style: TextStyle(fontSize: 20, color: CustomColors.black),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            blurRadius: 15.0,
                            offset: Offset(0.0, 0.75))
                      ]),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  child: Text('Tap To Scan',
                      style: TextStyle(
                        color: CustomColors.baseNavy,
                        fontSize: 16,
                      )),
                  onPressed: () {
                    scanQR();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: CustomColors.baseYellow)),
              SizedBox(
                  child: Text(
                'Result:$qrstr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.black,
                  fontSize: 16,
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: Text('Open in Browser',
                          style: TextStyle(
                            color: CustomColors.baseNavy,
                            fontSize: 16,
                          )),
                      onPressed: () {
                        _handleURLButtonPress(qrstr, qrstr);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: CustomColors.baseAmber)),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: qrstr));
                        Get.snackbar('Text copied', qrstr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.grey,
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(20));
                      },
                      child: Text("Copy To ClipBoard",
                          style: TextStyle(
                            color: CustomColors.baseNavy,
                            fontSize: 16,
                          )),
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors.baseAmber,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> scanQR() async {
    try {
      FlutterBarcodeScanner.scanBarcode('#39FF14', 'Back', true, ScanMode.QR)
          .then((value) {
        setState(() {
          qrstr = value;
        });
      });
    } catch (e) {
      setState(() {
        qrstr = 'unable to read this';
      });
    }
  }
}
