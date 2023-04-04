import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:lottie/lottie.dart';

class OrderFailed extends StatefulWidget {
  @override
  _OrderFailedState createState() => _OrderFailedState();
}

class _OrderFailedState extends State<OrderFailed> {
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/con-failed.json', repeat: false),
            Constants.spaceHeight20,
            Text(
              'Tut uns Leid, dass Ihnen unser aktuelles Angebot nicht zusagt. Gerne können Sie uns jederzeit für ein weiteres Angebot kontaktieren.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Constants.spaceHeight10,
            Text(
              'Tipp: Je mehr Unterschiedliche Artikel und Mengen Sie wählen, desto besser wird Ihr Angebot.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Constants.spaceHeight30,
            Constants.customButton('Home', () {
              Get.offAndToNamed("/main");
            }),
          ],
        ),
      ),
    );
  }
}
