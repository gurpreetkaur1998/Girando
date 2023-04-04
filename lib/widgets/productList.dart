import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/controller/cart.dart';
import 'package:girando/models/productsModel.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Helper hlp = Helper();
  bool loading = true;
  List<ProductModel> products = [];
  AuthController auth = Get.find<AuthController>();
  CartController cart = Get.find<CartController>();
  dynamic arguments;
  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    if (mounted) getData();
  }

  getData() async {
    Map<String, dynamic> data = await hlp.getData(
        "f=getProductByCateogry&category_id=${arguments['term_id']}&paged=1");

    List _data = data['data'];
    if (data.length > 0) {
      if (mounted) {
        setState(() {
          loading = false;
          products = _data.map((e) => ProductModel.fromJson(e)).toList();
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
          arguments['name'],
          style: const TextStyle(
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
                    )),
              ],
            ),
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(),
        child: loading == true
            ? Container(
                height: Get.height,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
              )
            : products.length == 0
                ? Center(child: Text('Bald verfügbar'))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      ProductModel product = products[index];

                      return Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 2),
                        child: ListTile(
                          onTap: () {
                            Get.toNamed(
                              "/productDetail",
                              arguments: {
                                "id": product.id.toString(),
                                "productModification": false,
                                "index": index,
                                "variationId": product.variationId,
                              },
                            );
                          },
                          focusColor: Colors.red,
                          iconColor: Colors.black,
                          trailing: Container(
                            width: 50,
                            height: 40,
                            child: Icon(Icons.chevron_right_sharp),
                          ),
                          title: Text(
                            product.title.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: products.length,
                  ),
      ),
    );
  }
}
