import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:girando/widgets/txtBox.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController emailControl = new TextEditingController();
  Helper hlp = new Helper();
  AuthController auth = Get.put(AuthController());

  @override
  void initState() {
    super.initState();

    emailControl.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
        alignment: Alignment.center,
        child: ListView(
          children: <Widget>[
            Container(
              height: 150,
              child: Image.asset('assets/images/logo.png'),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Passwort wiederherstellen',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            txtBox(
              txtcontroller: emailControl,
              hintText: 'Email',
              icon: LineIcons.userAlt,
            ),
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Constants.customButton('Absenden', () {
                    forgotPassword();
                  }),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        'Zurück',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> forgotPassword() async {
    if (emailControl.text.isEmpty) {
      hlp.showErrorToast("Bitte E-Mail Adresse eingeben");
      return;
    }
    if (!emailControl.text.isEmail) {
      hlp.showErrorToast("E-Mail Adresse nicht gültig");
      return;
    }

    Get.find<AuthController>().forgotPassword(emailControl.text);
  }
}
