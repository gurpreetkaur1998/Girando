import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:girando/controller/authController.dart';
import 'package:girando/controller/cart.dart';
import 'package:girando/models/productsModel.dart';
import 'package:girando/utils/const.dart';
import 'package:girando/utils/helper.dart';
import 'package:intl/intl.dart';

class OrderDetail extends StatefulWidget {
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Helper hlp = Helper();
  bool loading = true;
  List products = [];
  AuthController auth = Get.find<AuthController>();
  Map orderBase = Get.arguments['order'];
  ScrollController sc = new ScrollController();
  String status = "";
  CartController cart = Get.find<CartController>();

  Map orderData = {};
  @override
  void initState() {
    super.initState();

    if (mounted) getData();
  }

  getData() async {
    Map<String, dynamic> data = await hlp.getData(
        "f=getOrderById&user_id=${auth.loggedInUser.value.ID}&order_id=${orderBase['order_id']}");
    if (data != null) {
      Map _data = data['data'];
      print(data);
      Map _products = _data['product'];

      if (mounted) {
        setState(() {
          loading = false;
          products = _products['product'];
          orderData = _data;
          if (orderData['status'] == 'Pending') status = 'Anfrage';
          if (orderData['status'] == 'Inprogress') status = 'Angebot';
          if (orderData['status'] == 'Completed') status = 'Angenommen';
          if (orderData['status'] == 'Rejected') status = 'Abgelehnt';
        });
      }
    }
  }

  changeStatus(String status) async {
    Map<String, dynamic> params = {
      "order_status": status,
    };
    EasyLoading.show(status: 'Bitte warten');
    Map<String, dynamic> data = await hlp.postData(
        "f=updateOrderStatus&user_id=${auth.loggedInUser.value.ID}&order_id=${orderBase['order_id']}",
        params);

    if (data['err'] == "-1") {
      if (status == 'wc-failed') {
        Get.offAndToNamed("/orderFailed");
      } else {
        Get.offAndToNamed("/orderStatusChanged");
      }
    }
    EasyLoading.dismiss();
  }

  redoOrder() async {
    EasyLoading.show(status: 'Bitte warten');
    Map<String, dynamic> data = await hlp.getData(
        "f=reorder_product&user_id=${auth.loggedInUser.value.ID}&order_id=${orderBase['order_id']}");
    print(data);

    Get.offAndToNamed("/orderComplete");

    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.greyBg,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          onTap: () {
            if (Get.arguments['modified'] != null &&
                Get.arguments['modified'] == true) {
              Get.offAndToNamed("/orderScreen");
            } else {
              Get.back();
            }
          },
          child: Icon(
            Icons.chevron_left_sharp,
            size: 40,
          ),
        ),
        foregroundColor: Colors.black,
        title: Text(
          "Anfragen # ${orderBase['order_id']}",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: loading == true
          ? Container(
              height: Get.height,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
            )
          : ListView(
              physics: BouncingScrollPhysics(),
              controller: sc,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Constants.spaceHeight10,
                      metaInfo(
                        'Datum',
                        orderBase['order_date'],
                      ),
                      Constants.spaceHeight10,
                      metaInfo(
                        'Status',
                        status,
                      ),
                      Constants.spaceHeight10,
                      if (orderData['dari_estimated_amount'] != null &&
                          orderBase['status'] != 'wc-pending')
                        metaInfo(
                          'Preis',
                          orderData['amount'].replaceAll('euro', "€"),
                        ),
                      if (orderData['agent_notes'] != null)
                        Constants.spaceHeight20,
                      if (orderData['agent_notes'] != null)
                        Text(
                          orderData['agent_notes'],
                          textAlign: TextAlign.left,
                        ),
                    ],
                  ),
                ),
                ListView.builder(
                  controller: sc,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Map pro = products[index];
                    String indicator = '';
                    if (pro['old_price_unit'] != '' &&
                        pro['indicator'] != 'equal') {
                      indicator = pro['indicator'];
                    }

                    String attribute = pro['attributes'];
                    String attributes_value = pro['attributes_value'];

                    return Container(
                      color: Colors.white,
                      margin: EdgeInsets.only(
                        bottom: 1,
                        top: 1,
                      ),
                      child: ListTile(
                        onTap: () {},
                        minLeadingWidth: 40,
                        contentPadding: EdgeInsets.all(10),
                        focusColor: Colors.red,
                        iconColor: Colors.black,
                        title: Row(
                          children: [
                            if (indicator != '')
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 0,
                                  right: 15,
                                ),
                                child: Container(
                                  height: 70,
                                  // padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: indicator == 'up'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  width: 60,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        indicator == 'up'
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${pro['percentChange']}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(pro['name'].toString(),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      if (orderBase['status'] != 'wc-pending')
                                        Text("${pro['item_price']} €",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text("Menge",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Text(
                                          "${pro['attributes_value']} ${attribute.toString().capitalizeFirst}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                            "Preis pro ${attribute.toString().capitalizeFirst}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1),
                                      ),
                                      Text("${pro['pricePerUnit']} €",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  if (pro['old_price_unit'] != '' &&
                                      pro['indicator'] != 'equal')
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                              "Alter Preis pro ${attribute.toString().capitalize}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                        Text("${pro['old_price_unit']} €",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1)
                                      ],

                                      // Text(
                                      //     "Preis pro ${pro['variation_key'].toString().replaceFirst("pa_", "").toUpperCase()}  ${pro['pricePerUnit']} €",
                                      //     style: Theme.of(context).textTheme.bodyText1),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: products.length,
                ),
              ],
            ),
      bottomNavigationBar: Visibility(
        visible: true,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (orderBase['status'] == 'wc-processing')
                OutlinedButton(
                  child: Text(
                    'Annehmen',
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
                    changeStatus('wc-completed');
                  },
                ),
              if (orderBase['status'] == 'wc-processing')
                OutlinedButton(
                  child: Text(
                    'Ablehnen',
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
                    backgroundColor: Colors.red,
                    shadowColor: Colors.grey.shade500,
                  ),
                  onPressed: () {
                    changeStatus('wc-failed');
                  },
                ),
              if (orderBase['status'] == 'wc-completed')
                OutlinedButton(
                  child: Text(
                    'Erneut bestellen', //reorder
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
                    redoOrder();
                  },
                ),
              if (orderBase['status'] == 'wc-processing')
                OutlinedButton(
                  child: Text(
                    'Bestellung bearbeiten', //reorder
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
                    populateCart();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  metaInfo(String name, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  void populateCart() {
    print(products);
    cart.emptyCart();
    products.forEach((e) {
      ProductModel _product = ProductModel(
          id: e['product_id'],
          title: e['name'],
          item_id: e['item_id'].toString(),
          description: '',
          variationId: int.parse(e['variation_id'].toString()).toString(),
          variationText: " ${e['attributes_value']} ${e['attributes']} ");
      print(_product.toJson());
      cart.addProduct(_product);
    });
    cart.modifyOrder(orderBase['order_id'].toString());
    Get.toNamed("/cart");
  }
}
