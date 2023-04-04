import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:lottie/lottie.dart';

class OrderHold extends StatefulWidget {
  @override
  _OrderHoldState createState() => _OrderHoldState();
}

class _OrderHoldState extends State<OrderHold> {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Lottie.asset('assets/lf30_editor_j0jtm9by.json', height: 200),
            const Text(
              ' Vielen Dank für Ihre Anfrage!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Wir werden Ihre Daten nun erstmalig mit unserem System verknüpfen und Sie erhalten in Kürze ein Angebot. ',
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'Vielen Dank für Ihre Geduld!',
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'Tel.: +49 7142-9727-23',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'Fax: +49 7142-9727-27',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'E-mail: info@girando.de',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const Text(
              'Für Rückfragen stehen wir Ihnen jederzeit gerne zur Verfügung.',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Constants.customButton('Home', () {
              Get.offAndToNamed("/main");
            }),
          ],
        ),
      ),
    );
  }
}
