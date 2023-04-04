import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:lottie/lottie.dart';

class OrderStatusChanged extends StatefulWidget {
  @override
  _OrderStatusChangedState createState() => _OrderStatusChangedState();
}

class _OrderStatusChangedState extends State<OrderStatusChanged> {
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
            Lottie.asset('assets/lf30_1brnbltb.json', repeat: false),
            Constants.spaceHeight20,
            Text(
              'Vielen dank für die Annahme unseres Angebots, die Zustellung Ihrer Ware erfolgt innerhalb der nächsten 3-5 Werktage.',
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
