import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/controller/cart.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:upgrader/upgrader.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AuthController auth = Get.put(AuthController());
  final CartController cartController = Get.put(CartController());
  Helper hlp = Helper();
  int waitingOrders = 0;

  @override
  void initState() {
    getWaitingOrders();
    super.initState();
  }

  getWaitingOrders() async {
    Map<String, dynamic> data = await hlp.getData(
        "f=getOrdersByUserIdCount&user_id=${auth.loggedInUser.value.ID}&paged=1&status=wc-processing");
    setState(() {
      waitingOrders = data['data'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.greyBg,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(1, 5),
                ),
              ],
              color: Colors.white,
            ),
            // padding: EdgeInsets.only(top: 30),
            child: Image.asset('assets/images/logo.png'),
          ),
          Constants.spaceHeight20,
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      decoration: const BoxDecoration(boxShadow: []),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              "Hello ${auth.loggedInUser.value.displayName.toString()},",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )),
                          Constants.spaceHeight10,
                          Text(
                            "${auth.loggedInUser.value.userEmail.toString()},",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Constants.spaceHeight30,
                    InkWell(
                      onTap: () {
                        Get.toNamed("/categories");
                      },
                      child: boxContainer(Icons.category, 'Produkte'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                Get.toNamed("/profile");
                              },
                              child: boxContainer(
                                  Icons.person_outline, 'Mein Konto')),
                        ),
                        Constants.spaceWidth20,
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                Get.toNamed("/orderScreen");
                              },
                              child: boxContainer(
                                Icons.list,
                                'Anfragen',
                                waitingOrders: waitingOrders,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.toNamed("/productList", arguments: {
                                "term_id": '51',
                                "name": 'Sonderposten & Aktionen',
                              });
                            },
                            child: boxContainer(
                                Icons.local_offer_outlined, 'Aktionen'),
                          ),
                        ),
                        Constants.spaceWidth20,
                        Expanded(
                          child: Obx(() => InkWell(
                                onTap: () {
                                  Get.toNamed("/cart");
                                },
                                child: boxContainer(
                                  Icons.shopping_cart_outlined,
                                  'Warenkorb',
                                  waitingOrders:
                                      cartController.products.value.length,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: InkWell(
                                onTap: () {
                                  Get.toNamed("/help");
                                },
                                child:
                                    boxContainer(Icons.help_outline, 'Hilfe'))),
                        Constants.spaceWidth20,
                        Expanded(
                          child: InkWell(
                              onTap: () {
                                auth.logout();
                              },
                              child: boxContainer(Icons.exit_to_app, 'Logout')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class boxContainer extends StatelessWidget {
  String s;
  IconData icon;
  int waitingOrders;

  boxContainer(
    this.icon,
    this.s, {
    this.waitingOrders = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      position: BadgePosition.topEnd(),
      badgeContent: waitingOrders == 0
          ? Container()
          : Text(
              waitingOrders.toString(),
              style: const TextStyle(color: Colors.white),
            ),
      padding: waitingOrders == 0
          ? const EdgeInsets.all(0)
          : const EdgeInsets.all(10),
      child: Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(1, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              size: 40,
            ),
            Text(
              s,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
