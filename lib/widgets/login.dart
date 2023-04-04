import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/widgets/forgot.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:girando/widgets/txtBox.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameControl = new TextEditingController();
  final TextEditingController _passwordControl = new TextEditingController();
  Helper hlp = new Helper();
  AuthController auth = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
// sun@sun.com
// 123456
    _usernameControl.text = '';
    _passwordControl.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              height: 160,
              child: Image.asset('assets/images/logo.png'),
            ),
            txtBox(
              txtcontroller: _usernameControl,
              hintText: 'Email',
              icon: LineIcons.userAlt,
            ),
            const SizedBox(height: 10.0),
            txtBox(
              txtcontroller: _passwordControl,
              hintText: 'Password',
              icon: LineIcons.lock,
              isObscure: true,
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: GestureDetector(
                onTap: () {
                  Get.to(ForgotScreen());
                },
                child: Text(
                  'Passwort vergessen',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            Constants.customButton('Login', () {
              loginUser();
            }),
            Constants.customButton('Registrieren', () {
              Get.toNamed("/register");
            }),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    if (_usernameControl.text.isEmpty) {
      hlp.showErrorToast("Bitte Email eingeben");
      return;
    }
    if (!_usernameControl.text.isEmail) {
      hlp.showErrorToast("Bitte gültige Email eingeben");
      return;
    } else if (_passwordControl.text.isEmpty) {
      hlp.showErrorToast("Bitte Passwort eingeben");
      return;
    }

    Get.find<AuthController>().loginUser(
        _usernameControl.text, _passwordControl.text, osUserID.toString());
  }
}
