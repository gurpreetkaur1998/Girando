import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:lottie/lottie.dart';

class OrderModified extends StatefulWidget {
  @override
  _OrderModifiedState createState() => _OrderModifiedState();
}

class _OrderModifiedState extends State<OrderModified> {
  Helper hlp = Helper();
  bool loading = true;
  List categories = [];
  AuthController auth = Get.find<AuthController>();

  bool isNew = false;

  @override
  void initState() {
    super.initState();
    // EasyLoading.show(maskType: EasyLoadingMaskType.black);
    // Future.delayed(Duration(seconds: 5)).then((value) {
    //   EasyLoading.dismiss();
    // });
    dynamic arguments = Get.arguments;
    print(Get.arguments['order']);
    print(arguments);
    if (Get.arguments['type'] != null && Get.arguments['type'] == 'new') {
      isNew = true;
    }
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
            const Text(
              "Ihr Angebot wurde erstellt!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Constants.spaceHeight20,
            const Text(
              "Klicken Sie auf den Button um zu Ihrem Angebot zu gelangen.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Constants.spaceHeight30,
            Constants.customButton('Zum Angebot', () async {
              EasyLoading.show(maskType: EasyLoadingMaskType.black);
              Map<String, dynamic> data = await hlp.getData(
                  "f=getOrderById&user_id=${auth.loggedInUser.value.ID}&order_id=${Get.arguments['order'].toString()}");
              print(data['data']);

              Map<String, dynamic> orderData = data['data'];

              if (orderData['status'] == 'Pending')
                orderData['status'] = 'wc-pending';
              if (orderData['status'] == 'Inprogress')
                orderData['status'] = 'wc-processing';
              if (orderData['status'] == 'Completed')
                orderData['status'] = 'wc-completed';
              if (orderData['status'] == 'Rejected')
                orderData['status'] = 'wc-failed';

              Get.toNamed("/orderDetailScreen", arguments: {
                "order": orderData,
                "modified": true,
              });
              EasyLoading.dismiss();
            }),
          ],
        ),
      ),
    );
  }
}
