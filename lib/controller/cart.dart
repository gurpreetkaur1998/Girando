import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:girando/models/productsModel.dart';
import 'package:girando/utils/helper.dart';

class CartController extends GetxController {
  RxList products = [].obs;
  RxList removedProducts = [].obs;
  RxString orderId = "".obs;
  RxBool isModifying = false.obs;
  Helper hlp = new Helper();
  final storage = GetStorage();
  @override
  void onInit() {
    super.onInit();
    reloadCartFromStorage();
  }

  modifyOrder(orderId) {
    this.isModifying.value = true;
    this.orderId.value = orderId;
    this.removedProducts.value = [];

    update();
  }

  cancelModification() {
    this.isModifying.value = false;
    this.orderId.value = '';
    this.removedProducts.value = [];
    update();
  }

  void addProduct(ProductModel _product) {
    print(products.length);
    int? _id = _product.id;
    int index = products.indexWhere(
        (element) => element['variationId'] == _product.variationId);
    print(index);
    if (index == -1) {
      products.add({
        "product": _product,
        "quantity": 1,
        "ID": _product.id,
        "variationId": _product.variationId,
        "item_id": _product.item_id,
        "variationText": _product.variationText,
      });
    } else {
      // Map _lineItem = products.elementAt(index);
      // _lineItem['quantity'] = _lineItem['quantity'] + 1;
      // products[index] = _lineItem;
    }

    update();

    print(products.toString());
    storeCartContent();
    // hlp.showToastWarning("Product Added");
  }

  void removeProduct(ProductModel _product) {
    int? _id = _product.id;
    print(_id);
    int index = products.indexWhere(
        (element) => element['variationId'] == _product.variationId);
    print(index);
    if (this.isModifying.value == true) {
      if (_product.item_id != null) {
        removedProducts.add(_product.toJson());
      }
    }
    products.removeAt(index);
    storeCartContent();
    return;

    if (index == -1) {
      products.add({
        "product": _product,
        "quantity": 1,
        "ID": _product.id,
        "variationId": _product.variationId,
        "variationText": _product.variationText,
      });
    } else {
      Map _lineItem = products.elementAt(index);
      if (_lineItem['quantity'] == 0) {
        _lineItem['quantity'] = 0;
      } else {
        _lineItem['quantity'] = _lineItem['quantity'] - 1;
      }
      products[index] = _lineItem;
      if (_lineItem['quantity'] == 0) {
        products.removeAt(index);
      }
    }
    storeCartContent();
  }

  emptyCart() {
    Get.offAndToNamed("/main");
    products.value = [];
    storage.remove("products");
    update();
  }

  storeCartContent() {
    storage.write("products", products);
  }

  reloadCartFromStorage() {
    if (storage.read("products") != null) {
      List _products = storage.read("products");
      if (_products != null && _products.length > 0) {
        _products.forEach((element) {
          print(element);
          Map<String, dynamic> _product = element['product'];
          int _quantity = element['quantity'];
          ProductModel _p = ProductModel.fromJson(_product);
          // print("-----");
          // print(element['variationId']);
          // print(element['variationText']);
          products.add({
            "product": ProductModel.fromJson(_product),
            "quantity": 1,
            "ID": _product['id'],
            "variationId": _p.variationId,
            "variationText": _p.variationText,
          });
        });

        // products.value = _products.toList();
        update();
      }
    }
  }

  checkout(String? id) async {
    print(products.toJson());

    Map<String, dynamic> params = {"user_id": id};
    List data = [];
    products.forEach((element) {
      print(element);
      data.add(
        {
          "product_id": element['ID'],
          "quantity": element['quantity'],
          "variation_id": element['variationId'],
          "item_id": element['item_id'].toString()
        },
      );
    });

    String checkoutUrl = "f=checkout";
    if (this.isModifying.value == true) {
      params['order_id'] = this.orderId.toString();
      params['deletedProducts'] = this.removedProducts.value;
      checkoutUrl = 'f=updateCheckout';
    }
    params['data'] = data;

    print(jsonEncode(params));

    try {
      EasyLoading.show(
          status:
              "Bitte haben Sie einen Moment Geduld. Wir berechnen aktuell den besten Preis für Sie. Dies kann bis zu 60 Sekunden in Anspruch nehmen.",
          maskType: EasyLoadingMaskType.black);
      dynamic response = await hlp.postJson(checkoutUrl, params);
      print(response);

      products.value = [];
      storage.remove("products");

      update();

      if (this.isModifying.value == true) {
        EasyLoading.dismiss();
        Get.offAndToNamed("/orderModified", arguments: {
          "order": response['data']['order_id'],
          "type": "modified"
        });
      } else {
        EasyLoading.dismiss();

        if (response['data']['order_status'] == 'wc-on-hold') {
          Get.offAndToNamed("/OrderHold");
        } else {
          Get.offAndToNamed("/orderModified", arguments: {
            "order": response['data']['order_id'],
            "type": "new",
          });
        }
      }
      this.cancelModification();
    } catch (e) {
      EasyLoading.dismiss();
    }
  }
}
