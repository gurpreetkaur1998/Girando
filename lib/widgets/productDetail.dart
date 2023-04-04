import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/controller/cart.dart';
import 'package:girando/models/productsModel.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:girando/widgets/cartDetails.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  Helper hlp = Helper();
  bool loading = true;
  AuthController auth = Get.find<AuthController>();
  CartController cart = Get.find<CartController>();

  Map<String, dynamic> productData = {};
  String label = "";
  List variations = [];
  String variationId = "";
  String item_id = "";
  String variationText = "";
  bool productModification = false;
  int cartIndex = 0;

  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: Text("Menge auswählen"), value: ""),
  ];

  @override
  void initState() {
    super.initState();
    if (mounted) getData();
    if (Get.arguments['productModification'] != null) {
      print(Get.arguments);
      productModification = Get.arguments['productModification'];
      cartIndex = Get.arguments['index'];
      item_id = Get.arguments['item_id'] ?? '';
    }
  }

  getData() async {
    Map<String, dynamic> data =
        await hlp.getData("f=getProductById&productId=${Get.arguments['id']}");
    if (data != null) {
      Map<String, dynamic> _data = data['data'];

      // _data['id'] = int.parse(Get.parameters['id'].toString());
      Map<dynamic, dynamic> _variation_data = _data['variation_data'];
      if (_variation_data != null && _variation_data.entries.length > 0) {
        Map<String, dynamic> _attribute =
            _variation_data.entries.first.value as Map<String, dynamic>;

        String _label = _attribute['label'];

        List _variations = _attribute['terms'];
        _variations.forEach((element) {
          variations.add(element['name'].toString());
          menuItems.add(DropdownMenuItem(
              child: Text(element['name'].toString() + " " + _label),
              value: element['variations_id'].toString()));
        });
        setState(() {
          variations = _attribute['terms'];
          label = _attribute['label'];
        });

        if (productModification == true) {
          variationId = Get.arguments['variationId'];
        }
      }
      if (mounted) {
        setState(() {
          loading = false;
          productData = _data;
        });
      }
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
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
            (productData['title'] != null)
                ? productData['title'].toString()
                : '',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            if (productModification == false)
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: Row(
                  children: [
                    Obx(() => Badge(
                          badgeContent: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text(
                              '${cart.products.value.length}',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
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
        body: loading == true
            ? Container(
                height: Get.height,
                child: const Center(
                  child: const CircularProgressIndicator(
                    color: Colors.grey,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.white,
                    height: 300,
                    child: (productData['image'] == null)
                        ? CachedNetworkImage(
                            imageUrl:
                                'https://girando.app/wp-content/uploads/2022/03/orionthemes-placeholder-image-1.png',
                            fit: BoxFit.fitHeight,
                          )
                        : CachedNetworkImage(
                            imageUrl: productData['image'],
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          productData['title'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(productData['description'].toString()),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Menge",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          color: Colors.white,
                          child: DropdownButton(
                            underline: Container(),
                            isExpanded: true,
                            hint: const Text("Product Variation"),
                            value: variationId,
                            onChanged: (String? newValue) {
                              if (newValue!.isNotEmpty) {
                                dynamic v = variations.firstWhere((element) {
                                  return element['variations_id'].toString() ==
                                      newValue.toString();
                                });
                                setState(() {
                                  variationId = newValue.toString();
                                  variationText = v['name'] + " " + label;
                                });
                              }
                            },
                            items: menuItems,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                          child: const Text(
                            'Spezifikationen anfragen ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            elevation: 1,
                            primary: Colors.white,
                            backgroundColor: Colors.black,
                            shadowColor: Colors.grey.shade500,
                          ),
                          onPressed: () {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'info@girando.de',
                              query: encodeQueryParameters(<String, String>{
                                'subject': "Spezifikationen für " +
                                    productData['title'].toString() +
                                    " - " +
                                    productData['sku'].toString()
                              }),
                            );

                            launch(emailLaunchUri.toString());
                          },
                        ),
                        OutlinedButton(
                          child: const Text(
                            'Hinzufügen',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.all(10),
                            elevation: 1,
                            primary: Colors.white,
                            backgroundColor: Colors.green,
                            shadowColor: Colors.grey.shade500,
                          ),
                          onPressed: () {
                            if (variationId == '') {
                              hlp.showErrorToast("Bitte Menge auswählen");
                              return;
                            }

                            CartController cart = Get.find<CartController>();

                            // return;
                            if (productModification == false) {
                              ProductModel _product =
                                  ProductModel.fromJson(productData);
                              _product.variationId = variationId;
                              _product.variationText = variationText;
                              cart.addProduct(_product);
                              Get.back();

                              hlp.showInfo("Produkt wurde hinzugefügt");
                            } else if (productModification == true) {
                              cart.products.removeAt(cartIndex);
                              ProductModel _product =
                                  ProductModel.fromJson(productData);
                              _product.variationId = variationId;
                              _product.variationText = variationText;
                              _product.item_id = item_id;
                              cart.addProduct(_product);
                              Get.back(closeOverlays: true);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ));
  }
}
