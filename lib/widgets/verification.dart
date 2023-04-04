import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  Helper hlp = Helper();
  bool loading = true;
  List categories = [];
  AuthController auth = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.greyBg,
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/87580-email-icon-animation.json',
                repeat: false),
            const Text(
              ' Bestätigungs Email gesendet ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Bitte bestätigen Sie die E-Mail in Ihrem Posteingang'),
            SizedBox(
              height: 20,
            ),
            Constants.customButton('Anmelden/Login', () {
              Get.offAndToNamed("/login");
            }),
          ],
        ),
      ),
    );
  }
}
