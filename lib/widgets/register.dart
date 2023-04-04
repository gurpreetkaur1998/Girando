import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'txtBox.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameControl =
      TextEditingController(text: '');
  final TextEditingController _emailControl = TextEditingController(text: '');
  final TextEditingController _passwordControl =
      TextEditingController(text: '');
  final TextEditingController _firmname = TextEditingController(text: '');
  final TextEditingController phone = TextEditingController(text: '');
  final TextEditingController _additionalShipping =
      TextEditingController(text: '');
  final TextEditingController _confirmPassword =
      TextEditingController(text: '');

  final TextEditingController _billing_address =
      TextEditingController(text: '');
  final TextEditingController _billing_postcode =
      TextEditingController(text: '');
  final TextEditingController _billing_city = TextEditingController(text: '');
  final TextEditingController _billing_additionalInfo =
      TextEditingController(text: '');

  final TextEditingController _shipping_address =
      TextEditingController(text: '');
  final TextEditingController _shipping_company =
      TextEditingController(text: '');
  final TextEditingController _shipping_name = TextEditingController(text: '');
  final TextEditingController _shipping_familyName =
      TextEditingController(text: '');
  final TextEditingController _shipping_postcode =
      TextEditingController(text: '');
  final TextEditingController _shipping_city = TextEditingController(text: '');
  final TextEditingController _shipping_additionalInfo =
      TextEditingController(text: '');

  final ScrollController _scrollController = ScrollController();

  Helper hlp = Helper();
  bool privacy = false;
  bool isSameAddress = false;

  @override
  void initState() {
    super.initState();

    // _usernameControl.text = "";
    // _emailControl.text = "";
    // _passwordControl.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.greyBg,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        title: Text(
          'Registrieren',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 100),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  txtBox(
                    txtcontroller: _usernameControl,
                    hintText: 'Name',
                    icon: Icons.perm_identity_outlined,
                  ),
                  const SizedBox(height: 10.0),
                  txtBox(
                    txtcontroller: _firmname,
                    hintText: 'Firmenname',
                    icon: Icons.note,
                  ),
                  const SizedBox(height: 10.0),
                  txtBox(
                    txtcontroller: phone,
                    hintText: 'Telefonnummer',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 10.0),

                  txtBox(
                    txtcontroller: _emailControl,
                    hintText: 'Email',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10.0),
                  txtBox(
                      txtcontroller: _passwordControl,
                      hintText: 'Passwort',
                      icon: Icons.lock_outline,
                      isObscure: true),
                  const SizedBox(height: 10.0),
                  txtBox(
                      txtcontroller: _confirmPassword,
                      hintText: 'Passwort bestätigen',
                      icon: Icons.lock_outline,
                      isObscure: true),
                  const SizedBox(height: 20.0),

                  Text(
                    'Ihre Adresse',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    thickness: 1,
                  ),

                  const SizedBox(height: 10.0),
                  txtBox(
                      txtcontroller: _billing_address,
                      hintText: 'Straße und Nr.',
                      icon: Icons.home,
                      isObscure: false),
                  const SizedBox(height: 10.0),
                  txtBox(
                      txtcontroller: _billing_additionalInfo,
                      hintText: 'Lieferhinweise',
                      icon: Icons.home,
                      isObscure: false),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: txtBox(
                            txtcontroller: _billing_postcode,
                            hintText: 'PLZ',
                            icon: Icons.home,
                            keyboardType: TextInputType.number,
                            isObscure: false),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 2,
                        child: txtBox(
                            txtcontroller: _billing_city,
                            hintText: 'Ort',
                            icon: Icons.home,
                            isObscure: false),
                      ),
                    ],
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Die Lieferadresse weicht von der Rechnungsadresse ab.',
                      style: TextStyle(fontSize: 13),
                    ),
                    autofocus: false,
                    activeColor: Colors.grey.shade700,
                    checkColor: Colors.white,
                    selected: isSameAddress,
                    value: isSameAddress,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        isSameAddress = value!;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (isSameAddress == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Ihre abweichende Lieferadresse',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        const SizedBox(height: 10.0),
                        txtBox(
                            txtcontroller: _shipping_company,
                            hintText: 'Firma',
                            icon: Icons.note,
                            isObscure: false),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: txtBox(
                                  txtcontroller: _shipping_name,
                                  hintText: 'Vorname',
                                  icon: Icons.person,
                                  isObscure: false),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: txtBox(
                                  txtcontroller: _shipping_familyName,
                                  hintText: 'Nachname',
                                  icon: Icons.person,
                                  isObscure: false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        txtBox(
                            txtcontroller: _shipping_address,
                            hintText: 'Straße und Nr.',
                            icon: Icons.home,
                            isObscure: false),
                        const SizedBox(height: 10.0),
                        txtBox(
                            txtcontroller: _shipping_additionalInfo,
                            hintText: 'Lieferhinweise',
                            icon: Icons.home,
                            isObscure: false),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: txtBox(
                                  txtcontroller: _shipping_postcode,
                                  hintText: 'PLZ',
                                  icon: Icons.home,
                                  keyboardType: TextInputType.number,
                                  isObscure: false),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 2,
                              child: txtBox(
                                  txtcontroller: _shipping_city,
                                  hintText: 'Ort',
                                  icon: Icons.home,
                                  isObscure: false),
                            ),
                          ],
                        ),
                      ],
                    ),

                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: InkWell(
                        onTap: () {
                          _launchInBrowser(
                              "https://girando.app/wp-content/uploads/2022/05/AGB-Girando-GmbH.pdf");
                        },
                        child: Text(
                          'Ich erkläre mich mit den AGB´s einverstanden',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontSize: 14,
                          ),
                        )),
                    autofocus: false,
                    activeColor: Colors.grey.shade700,
                    checkColor: Colors.white,
                    selected: privacy,
                    value: privacy,
                    onChanged: (value) {
                      setState(() {
                        privacy = value!;
                      });
                    },
                  ), //CheckboxListTile
                  SizedBox(
                    height: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  const SizedBox(height: 20.0),
                  Constants.customButton('Bestätigen', () {
                    registerUser();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    FocusScope.of(context).unfocus();
    FocusManager.instance.primaryFocus?.unfocus();

    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    if (_usernameControl.text.isEmpty) {
      hlp.showErrorToast("Bitte Namen eingeben");
      return;
    } else if (_firmname.text.isEmpty) {
      hlp.showErrorToast("Bitte Firmennamen eingeben");
      return;
    } else if (phone.text.isEmpty) {
      hlp.showErrorToast("Please enter Phone number");
      return;
    } else if (_emailControl.text.isEmpty) {
      hlp.showErrorToast("Bitte E-Mail Adresse eingeben");
      return;
    } else if (_emailControl.text.isEmail == false) {
      hlp.showErrorToast("E-Mail Adresse nicht gültig");
      return;
    } else if (_passwordControl.text.isEmpty) {
      hlp.showErrorToast("Bitte Passwort eingeben");
      return;
    } else if (_confirmPassword.text.isEmpty) {
      hlp.showErrorToast("Bitte Passwort bestätigen");
      return;
    } else if (_passwordControl.text != _confirmPassword.text) {
      hlp.showErrorToast("Passwörter stimmen nicht überein, bitte überprüfen.");
      return;
    } else if (_billing_address.text.isEmpty) {
      hlp.showErrorToast("Bitte Rechnungsadresse eintragen");
      return;
    } else if (_billing_city.text.isEmpty) {
      hlp.showErrorToast("Bitte Rechnungs Stadt eingeben");
      return;
    } else if (_billing_postcode.text.isEmpty) {
      hlp.showErrorToast("Bitte Rechnungs PLZ eingeben");
      return;
    } else if (isSameAddress == true) {
      if (_shipping_name.text.isEmpty) {
        hlp.showErrorToast("Bitte Name der Lieferadresse eingeben");
        return;
      } else if (_shipping_familyName.text.isEmpty) {
        hlp.showErrorToast("Bitte Familienname der Lieferadersse eingeben");
        return;
      } else if (_shipping_address.text.isEmpty) {
        hlp.showErrorToast("Bitte Rechnungs PLZ eingeben");
        return;
      } else if (_shipping_postcode.text.isEmpty) {
        hlp.showErrorToast("Bitte Rechnungs PLZ eingeben");
        return;
      } else if (_shipping_city.text.isEmpty) {
        hlp.showErrorToast("Bitte Stadt der Lieferadresse eingeben");
        return;
      }
    }

    if (privacy == false) {
      hlp.showErrorToast("Um fortzufahren müssen Sie unsere AGB´s bestätigen");
      return;
    }

    Map<String, dynamic> params = {
      "name": _usernameControl.text,
      "password": _passwordControl.text,
      "email": _emailControl.text,
      "firmname": _firmname.text,
      "phone": phone.text,
      "billing_address": _billing_address.text,
      "billing_additionalInfo": _billing_additionalInfo.text,
      "billing_city": _billing_city.text,
      "billing_postcode": _billing_postcode.text,
      "shipping_additionalInfo": _shipping_additionalInfo.text,
      "shipping_address": _shipping_address.text,
      "shipping_company": _shipping_company.text,
      "shipping_name": _shipping_name.text,
      "shipping_familyName": _shipping_familyName.text,
      "shipping_city": _shipping_city.text,
      "shipping_postcode": _shipping_postcode.text,
      "isSameAddress": isSameAddress,
      "one_signal_id": osUserID.toString()
    };

    Get.find<AuthController>().registerUser(params);
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    )) {
      throw 'Could not launch $url';
    }
  }
}
