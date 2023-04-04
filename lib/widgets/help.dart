import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
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
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
        title: Text(
          "Hilfe",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: ListView(
          children: [
            Text(
                'Sie können mit unserer App ganz einfach Anfragen tätigen. Einfach das Produkt in den Warenkorb legen und schon können unsere Mitarbeiter für Sie den besten Preis ermitteln.'),
            SizedBox(
              height: 20,
            ),
            Text(
                'Sie haben Fragen zu Ihrer Bestellung oder ein anderes Anliegen?'),
            SizedBox(
              height: 20,
            ),
            Text('Dann nehmen Sie jederzeit gerne Kontakt zu uns aut:'),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                String _url = "mailto:info@girando.de";
                try {
                  await canLaunch(_url)
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                } catch (e) {
                  print("Error launchUrlGeo $e");
                }
              },
              child: Text(
                'info@girando.de',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              onPressed: () async {
                String _url =
                    "https://wa.me/+4915229660340?text=${"Contact from girando app".replaceAll(" ", "+")}";
                try {
                  await canLaunch(_url)
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                } catch (e) {
                  print("Error launchUrlGeo $e");
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.whatsapp,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Kontaktieren Sie uns auf WhatsApp.')
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
