import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/controller/cart.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Helper hlp = Helper();
  bool loading = true;
  List categories = [];
  AuthController auth = Get.find<AuthController>();
  CartController cart = Get.find<CartController>();
  @override
  void initState() {
    super.initState();
    if (mounted) getData();
  }

  getData() async {
    Map<String, dynamic> data = await hlp.getData("f=getCategories");

    if (data.length > 0) {
      if (mounted) {
        setState(() {
          loading = false;
          categories = data['data'];
        });
      }
    }
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
          'Kategorien',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: Row(
              children: [
                Obx(() => Badge(
                      badgeContent: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          '${cart.products.value.length}',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.toNamed("/cart");
                        },
                        icon: const Icon(Icons.shopping_cart),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        child: loading == true
            ? Container(
                height: Get.height,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];

                  return Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(
                      bottom: 10,
                      top: 3,
                    ),
                    child: ListTile(
                      onTap: () {
                        Get.toNamed("/productList", arguments: {
                          "term_id": cat['term_id'].toString(),
                          "name": cat['name'].toString(),
                        });
                      },
                      focusColor: Colors.red,
                      iconColor: Colors.black,
                      trailing: Icon(
                        Icons.chevron_right,
                      ),
                      title: Text(
                        cat['name'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: categories.length,
              ),
      ),
    );
  }
}
