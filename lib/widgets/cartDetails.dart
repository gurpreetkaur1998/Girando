import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/controller/cart.dart';
import 'package:girando/models/productsModel.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:girando/widgets/productDetail.dart';

class CartDetail extends StatefulWidget {
  const CartDetail({Key? key}) : super(key: key);

  @override
  State<CartDetail> createState() => _CartDetailState();
}

class _CartDetailState extends State<CartDetail> {
  Helper hlp = Helper();
  bool loading = true;
  AuthController auth = Get.find<AuthController>();
  CartController cart = Get.find<CartController>();

  @override
  void initState() {
    Get.closeAllSnackbars();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constants.greyBg,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                cart.emptyCart();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
          ],
          elevation: 1,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.black,
          title: Obx(() => Text(
                cart.isModifying.value == true
                    ? 'Anfrage bearbeiten # ${cart.orderId.value}'
                    : 'Warenkorb',
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        bottomNavigationBar: Obx(() {
          return Visibility(
            visible: cart.products.length > 0 ? true : false,
            child: Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
              child: Row(
                children: [
                  if (cart.isModifying.value == true)
                    Expanded(
                      child: Constants.customButton('Abbrechen', () {
                        cart.emptyCart();
                        cart.cancelModification();
                        Get.offAndToNamed("/main");
                      }),
                    ),
                  if (cart.isModifying.value == true)
                    SizedBox(
                      width: 20,
                    ),
                  Expanded(
                    child: Constants.customButton('Anfragen', () {
                      cart.checkout(auth.loggedInUser.value.ID);
                    }),
                  ),
                ],
              ),
            ),
          );
        }),
        body: GetX<CartController>(
            initState: (_) {},
            builder: (_) {
              if (_.products.length == 0) {
                return Center(
                  child: Container(
                    // padding: EdgeInsets.all(40),
                    child: Text(
                      'Warenkorb leer',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          Map _product = _.products[index];
                          ProductModel product = _product['product'];
                          print(product.toJson());

                          return Container(
                            color: (index % 2 == 0)
                                ? Colors.grey.shade50
                                : Colors.white,
                            margin: const EdgeInsets.only(bottom: 2),
                            child: ListTile(
                              onTap: () {
                                Get.to(
                                  ProductDetail(),
                                  fullscreenDialog: true,
                                  transition: Transition.cupertinoDialog,
                                  arguments: {
                                    "id": product.id.toString(),
                                    "index": index,
                                    "variationId": product.variationId,
                                    "productModification": true,
                                    "item_id": product.item_id.toString(),
                                  },
                                );
                              },
                              focusColor: Colors.red,
                              iconColor: Colors.black,
                              trailing: Wrap(
                                direction: Axis.vertical,
                                alignment: WrapAlignment.center,
                                runAlignment: WrapAlignment.center,
                                verticalDirection: VerticalDirection.down,
                                children: [
                                  Container(
                                    width: 40,
                                    child: MaterialButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () {
                                        cart.removeProduct(product);
                                      },
                                      child: const Icon(
                                        Icons.remove_circle_outline_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  //   Container(
                                  //     decoration: BoxDecoration(
                                  //       borderRadius: BorderRadius.circular(
                                  //         10,
                                  //       ),
                                  //       color: Constants.greyBg,
                                  //     ),
                                  //     padding: EdgeInsets.only(
                                  //       left: 10,
                                  //       right: 10,
                                  //       top: 5,
                                  //       bottom: 5,
                                  //     ),
                                  //     width: 50,
                                  //     child: Text(
                                  //       _product['quantity'].toString(),
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(
                                  //         fontSize: 17,
                                  //         fontWeight: FontWeight.bold,
                                  //         color: Colors.grey.shade700,
                                  //       ),
                                  //     ),
                                  //   ),
                                  //   Container(
                                  //     width: 40,
                                  //     child: MaterialButton(
                                  //       splashColor: Colors.transparent,
                                  //       highlightColor: Colors.transparent,
                                  //       onPressed: () {
                                  //         cart.addProduct(product);
                                  //       },
                                  //       child: const Icon(
                                  //         Icons.add_circle_outline_outlined,
                                  //         color: Colors.green,
                                  //       ),
                                  //     ),
                                  //   ),
                                ],
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    product.title.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    product.variationText!
                                        .toString()
                                        .capitalize
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: _.products.length,
                      ),
                    ),
                    if (cart.isModifying.value == true)
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Constants.customButton(
                          'Produkt hinzufügen',
                          () {
                            Get.toNamed("/categories");
                          },
                          color: Colors.grey.shade800,
                        ),
                      ),
                  ],
                );
              }
            }));
  }
}
