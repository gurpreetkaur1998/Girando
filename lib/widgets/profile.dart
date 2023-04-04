import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'txtBox.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _usernameControl = TextEditingController();
  final TextEditingController _emailControl = TextEditingController();
  final TextEditingController _passwordControl = TextEditingController();
  final TextEditingController _firmname = TextEditingController();
  final TextEditingController _customerNumber = TextEditingController();
  final TextEditingController _shipping = TextEditingController(text: '');
  final TextEditingController _billing = TextEditingController(text: '');
  final TextEditingController _additionalShipping =
      TextEditingController(text: '');
  final TextEditingController phone = TextEditingController(text: '');

  AuthController auth = Get.find<AuthController>();
  final ScrollController _scrollController = ScrollController();
  Helper hlp = Helper();

  @override
  void initState() {
    super.initState();

    _usernameControl.text = auth.loggedInUser.value.displayName.toString();
    _emailControl.text = auth.loggedInUser.value.userEmail.toString();
    _firmname.text = auth.loggedInUser.value.firmname.toString();
    _shipping.text = auth.loggedInUser.value.shippingAddress_1.toString();
    _billing.text = auth.loggedInUser.value.billingAddress_1.toString();
    phone.text = auth.loggedInUser.value.phone.toString();
    // _customerNumber.text =
    //     auth.loggedInUser.value.girandoCustomerNumber.toString();
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
          'Mein Konto',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30.0, 30, 30, 0),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
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
              if (auth.loggedInUser.value.billingAddress_1 != '')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20.0),
                    Text(
                      'Ihre Adresse',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Text(
                      "${auth.loggedInUser.value.billingAddress_1.toString()}, ${auth.loggedInUser.value.billingAddress_2.toString()}",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${auth.loggedInUser.value.billingCity.toString()}, ${auth.loggedInUser.value.billingPostcode}",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              if (auth.loggedInUser.value.shippingAddress_1 != '')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 15.0),
                    Text(
                      'Ihre abweichende Lieferadresse',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Text(
                      "${auth.loggedInUser.value.shippingFirstName.toString()} ${auth.loggedInUser.value.shippingLastName.toString()} / ${auth.loggedInUser.value.shippingCompany.toString()}",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${auth.loggedInUser.value.shippingAddress_1.toString()}, ${auth.loggedInUser.value.shippingAddress_2.toString()}",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${auth.loggedInUser.value.shippingPostcode.toString()}, ${auth.loggedInUser.value.shippingCity.toString()}",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              const SizedBox(height: 30.0),
              Constants.customButton('Speichern', () {
                registerUser();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    FocusScope.of(context).unfocus();

    if (_usernameControl.text.isEmpty) {
      hlp.showErrorToast("Bitte Namen eingeben");
      return;
    } else if (_firmname.text.isEmpty) {
      hlp.showErrorToast("Bitte Firmennamen eingeben");
      return;
    } else if (_emailControl.text.isEmpty) {
      hlp.showErrorToast("Bitte E-Mail Adresse eingeben");
      return;
    } else if (_emailControl.text.isEmail == false) {
      hlp.showErrorToast("E-Mail Adresse nicht gültig");
      return;
    } else if (phone.text.isEmpty) {
      hlp.showErrorToast("Please enter Phone number");
      return;
    }
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;

    Map<String, dynamic> params = {
      "name": _usernameControl.text,
      "email": _emailControl.text,
      "firmname": _firmname.text,
      "shippingAddress": "",
      "billingAdress": "",
      "additionalShipping": "",
      "phone": phone.text,
      "user_id": auth.loggedInUser.value.ID.toString(),
      "one_signal_id": osUserID.toString()
    };

    print(params);

    Get.find<AuthController>().updateProfile(params);
  }
}
